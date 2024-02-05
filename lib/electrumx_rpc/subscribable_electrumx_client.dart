/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:mutex/mutex.dart';
import 'package:socks_socket/socks_socket.dart';
import 'package:stackwallet/electrumx_rpc/electrumx_client.dart';
import 'package:stackwallet/exceptions/json_rpc/json_rpc_exception.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_connection_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/global_event_bus.dart';
import 'package:stackwallet/services/tor_service.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/prefs.dart';

class ElectrumXSubscription {
  final StreamController<dynamic> _controller =
      StreamController(); // TODO controller params

  Stream<dynamic> get responseStream => _controller.stream;

  void addToStream(dynamic data) => _controller.add(data);
}

class SocketTask {
  SocketTask({this.completer, this.subscription});

  final Completer<dynamic>? completer;
  final ElectrumXSubscription? subscription;

  bool get isSubscription => subscription != null;
}

class SubscribableElectrumXClient {
  int _currentRequestID = 0;
  bool _isConnected = false;
  List<int> _responseData = [];
  final Map<String, SocketTask> _tasks = {};
  Timer? _aliveTimer;
  Socket? _socket;
  SOCKSSocket? _socksSocket;
  late final bool _useSSL;
  late final Duration _connectionTimeout;
  late final Duration _keepAlive;

  bool get isConnected => _isConnected;
  bool get useSSL => _useSSL;
  // Used to reconnect.
  String? _host;
  int? _port;

  void Function(bool)? onConnectionStatusChanged;

  late Prefs _prefs;
  late TorService _torService;
  StreamSubscription<TorPreferenceChangedEvent>? _torPreferenceListener;
  StreamSubscription<TorConnectionStatusChangedEvent>? _torStatusListener;
  final Mutex _torConnectingLock = Mutex();
  bool _requireMutex = false;

  List<ElectrumXNode>? failovers;
  int currentFailoverIndex = -1;

  SubscribableElectrumXClient({
    required bool useSSL,
    required Prefs prefs,
    required List<ElectrumXNode> failovers,
    TorService? torService,
    this.onConnectionStatusChanged,
    Duration connectionTimeout = const Duration(seconds: 5),
    Duration keepAlive = const Duration(seconds: 10),
    EventBus? globalEventBusForTesting,
  }) {
    _useSSL = useSSL;
    _prefs = prefs;
    _torService = torService ?? TorService.sharedInstance;
    _connectionTimeout = connectionTimeout;
    _keepAlive = keepAlive;

    // If we're testing, use the global event bus for testing.
    final bus = globalEventBusForTesting ?? GlobalEventBus.instance;

    // Listen to global event bus for Tor status changes.
    _torStatusListener = bus.on<TorConnectionStatusChangedEvent>().listen(
      (event) async {
        switch (event.newStatus) {
          case TorConnectionStatus.connecting:
            // If Tor is connecting, we need to wait.
            await _torConnectingLock.acquire();
            _requireMutex = true;
            break;

          case TorConnectionStatus.connected:
          case TorConnectionStatus.disconnected:
            // If Tor is connected or disconnected, we can release the lock.
            if (_torConnectingLock.isLocked) {
              _torConnectingLock.release();
            }
            _requireMutex = false;
            break;
        }
      },
    );

    // Listen to global event bus for Tor preference changes.
    try {
      _torPreferenceListener = bus.on<TorPreferenceChangedEvent>().listen(
        (event) async {
          // Close open socket (if open).
          final tempSocket = _socket;
          _socket = null;
          await tempSocket?.close();

          // Close open SOCKS socket (if open).
          final tempSOCKSSocket = _socksSocket;
          _socksSocket = null;
          await tempSOCKSSocket?.close();

          // Clear subscriptions.
          _tasks.clear();

          // Cancel alive timer
          _aliveTimer?.cancel();
        },
      );
    } catch (e, s) {
      print(s);
    }
  }

  factory SubscribableElectrumXClient.from({
    required ElectrumXNode node,
    required Prefs prefs,
    required List<ElectrumXNode> failovers,
    TorService? torService,
  }) {
    return SubscribableElectrumXClient(
      useSSL: node.useSSL,
      prefs: prefs,
      failovers: failovers,
      torService: torService ?? TorService.sharedInstance,
    );
  }

  // Example for returning a future which completes upon connection.
  // static Future<SubscribableElectrumXClient> from({
  //   required ElectrumXNode node,
  //   TorService? torService,
  // }) async {
  //   final client = SubscribableElectrumXClient(
  //     useSSL: node.useSSL,
  //   );
  //
  //   await client.connect(host: node.address, port: node.port);
  //
  //   return client;
  // }

  /// Check if the RPC client is connected and connect if needed.
  ///
  /// If Tor is enabled but not running, it will attempt to start Tor.
  Future<void> _checkRpcClient() async {
    if (_prefs.useTor) {
      // If we're supposed to use Tor...
      if (_torService.status != TorConnectionStatus.connected) {
        // ... but Tor isn't running...
        if (!_prefs.torKillSwitch) {
          // ... and the killswitch isn't set, then we'll just return below.
          Logging.instance.log(
            "Tor preference set but Tor is not enabled, killswitch not set, connecting to ElectrumX through clearnet.",
            level: LogLevel.Warning,
          );
        } else {
          // ... but if the killswitch is set, then let's try to start Tor.
          await _torService.start();
          // TODO [prio=low]: Attempt to restart Tor if needed.  Update Tor package for restart feature.

          // Double-check that Tor is running.
          if (_torService.status != TorConnectionStatus.connected) {
            // If Tor still isn't running, then we'll throw an exception.
            throw Exception("SubscribableElectrumXClient._checkRpcClient: "
                "Tor preference and killswitch set but Tor not enabled and could not start, not connecting to ElectrumX.");
          }
        }
      }
    }

    // Connect if needed.
    if ((!_prefs.useTor && _socket == null) ||
        (_prefs.useTor && _socksSocket == null)) {
      if (currentFailoverIndex == -1) {
        // Check if we have cached node information
        if (_host == null && _port == null) {
          throw Exception("SubscribableElectrumXClient._checkRpcClient: "
              "No host or port provided and no cached node information.");
        }

        // Connect to the server.
        await connect(host: _host!, port: _port!);
      } else {
        // Attempt to connect to the next failover server.
        await connect(
          host: failovers![currentFailoverIndex].address,
          port: failovers![currentFailoverIndex].port,
        );
      }
    }
  }

  /// Connect to the server.
  ///
  /// If Tor is enabled, it will attempt to connect through Tor.
  Future<void> connect({
    required String host,
    required int port,
  }) async {
    // Cache node information.
    _host = host;
    _port = port;

    // If we're already connected, disconnect first.
    try {
      await _socket?.close();
    } catch (_) {}

    // If we're connecting to Tor, wait.
    if (_requireMutex) {
      await _torConnectingLock.protect(() async => await _checkRpcClient());
    } else {
      await _checkRpcClient();
    }

    if (!Prefs.instance.useTor) {
      // If we're not supposed to use Tor, then connect directly.
      await connectClearnet(host, port);
    } else {
      // If we're supposed to use Tor...
      if (_torService.status != TorConnectionStatus.connected) {
        // ... but Tor isn't running...
        if (!_prefs.torKillSwitch) {
          // ... and the killswitch isn't set, then we'll connect clearnet.
          Logging.instance.log(
            "Tor preference set but Tor not enabled, no killswitch set, connecting to ElectrumX through clearnet",
            level: LogLevel.Warning,
          );
          await connectClearnet(host, port);
        } else {
          // ... but if the killswitch is set, then let's try to start Tor.
          await _torService.start();
          // TODO [prio=low]: Attempt to restart Tor if needed.  Update Tor package for restart feature.

          // Doublecheck that Tor is running.
          if (_torService.status != TorConnectionStatus.connected) {
            // If Tor still isn't running, then we'll throw an exception.
            throw Exception(
                "Tor preference and killswitch set but Tor not enabled, not connecting to ElectrumX");
          }

          // Connect via Tor.
          await connectTor(host, port);
        }
      } else {
        // Connect via Tor.
        await connectTor(host, port);
      }
    }

    _updateConnectionStatus(true);

    if (_prefs.useTor) {
      if (_socksSocket == null) {
        final String msg = "SubscribableElectrumXClient.connect(): "
            "cannot listen to $host:$port via SOCKSSocket because it is not connected.";
        Logging.instance.log(msg, level: LogLevel.Fatal);
        throw Exception(msg);
      }

      _socksSocket!.listen(
        _dataHandler,
        onError: _errorHandler,
        onDone: _doneHandler,
        cancelOnError: true,
      );
    } else {
      if (_socket == null) {
        final String msg = "SubscribableElectrumXClient.connect(): "
            "cannot listen to $host:$port via socket because it is not connected.";
        Logging.instance.log(msg, level: LogLevel.Fatal);
        throw Exception(msg);
      }

      _socket!.listen(
        _dataHandler,
        onError: _errorHandler,
        onDone: _doneHandler,
        cancelOnError: true,
      );
    }

    _aliveTimer?.cancel();
    _aliveTimer = Timer.periodic(
      _keepAlive,
      (_) async => _updateConnectionStatus(await ping()),
    );
  }

  /// Connect to the server directly.
  Future<void> connectClearnet(String host, int port) async {
    try {
      Logging.instance.log(
          "SubscribableElectrumXClient.connectClearnet(): "
          "creating a socket to $host:$port (SSL $useSSL)...",
          level: LogLevel.Info);

      if (_useSSL) {
        _socket = await SecureSocket.connect(
          host,
          port,
          timeout: _connectionTimeout,
          onBadCertificate: (_) =>
              true, // TODO do not automatically trust bad certificates.
        );
      } else {
        _socket = await Socket.connect(
          host,
          port,
          timeout: _connectionTimeout,
        );
      }

      Logging.instance.log(
          "SubscribableElectrumXClient.connectClearnet(): "
          "created socket to $host:$port...",
          level: LogLevel.Info);
    } catch (e, s) {
      final String msg = "SubscribableElectrumXClient.connectClearnet: "
          "failed to connect to $host (SSL: $useSSL)."
          "\nError: $e\nStack trace: $s";
      Logging.instance.log(msg, level: LogLevel.Fatal);
      throw JsonRpcException(msg);
    }

    return;
  }

  /// Connect to the server using the Tor service.
  Future<void> connectTor(String host, int port) async {
    // Get the proxy info from the TorService.
    final proxyInfo = _torService.getProxyInfo();

    try {
      Logging.instance.log(
          "SubscribableElectrumXClient.connectTor(): "
          "creating a SOCKS socket at $proxyInfo (SSL $useSSL)...",
          level: LogLevel.Info);

      // Create a socks socket using the Tor service's proxy info.
      _socksSocket = await SOCKSSocket.create(
        proxyHost: proxyInfo.host.address,
        proxyPort: proxyInfo.port,
        sslEnabled: useSSL,
      );

      Logging.instance.log(
          "SubscribableElectrumXClient.connectTor(): "
          "created SOCKS socket at $proxyInfo...",
          level: LogLevel.Info);
    } catch (e, s) {
      final String msg = "SubscribableElectrumXClient.connectTor(): "
          "failed to create a SOCKS socket at $proxyInfo (SSL $useSSL)..."
          "\nError: $e\nStack trace: $s";
      Logging.instance.log(msg, level: LogLevel.Fatal);
      throw JsonRpcException(msg);
    }

    try {
      Logging.instance.log(
          "SubscribableElectrumXClient.connectTor(): "
          "connecting to SOCKS socket at $proxyInfo (SSL $useSSL)...",
          level: LogLevel.Info);

      await _socksSocket?.connect();

      Logging.instance.log(
          "SubscribableElectrumXClient.connectTor(): "
          "connected to SOCKS socket at $proxyInfo...",
          level: LogLevel.Info);
    } catch (e, s) {
      final String msg = "SubscribableElectrumXClient.connectTor(): "
          "failed to connect to SOCKS socket at $proxyInfo.."
          "\nError: $e\nStack trace: $s";
      Logging.instance.log(msg, level: LogLevel.Fatal);
      throw JsonRpcException(msg);
    }

    try {
      Logging.instance.log(
          "SubscribableElectrumXClient.connectTor(): "
          "connecting to $host:$port over SOCKS socket at $proxyInfo...",
          level: LogLevel.Info);

      await _socksSocket?.connectTo(host, port);

      Logging.instance.log(
          "SubscribableElectrumXClient.connectTor(): "
          "connected to $host:$port over SOCKS socket at $proxyInfo",
          level: LogLevel.Info);
    } catch (e, s) {
      final String msg = "SubscribableElectrumXClient.connectTor(): "
          "failed to connect $host over tor proxy at $proxyInfo."
          "\nError: $e\nStack trace: $s";
      Logging.instance.log(msg, level: LogLevel.Fatal);
      throw JsonRpcException(msg);
    }

    return;
  }

  /// Disconnect from the server.
  Future<void> disconnect() async {
    _aliveTimer?.cancel();
    await _socket?.close();
    await _socksSocket?.close();
    onConnectionStatusChanged = null;
  }

  /// Format JSON request string.
  String _buildJsonRequestString({
    required String method,
    required String id,
    required List<dynamic> params,
  }) {
    final paramString = jsonEncode(params);
    return '{"jsonrpc": "2.0", "id": "$id","method": "$method","params": $paramString}\r\n';
  }

  /// Update the connection status and call the onConnectionStatusChanged callback if it exists.
  void _updateConnectionStatus(bool connectionStatus) {
    if (_isConnected != connectionStatus && onConnectionStatusChanged != null) {
      onConnectionStatusChanged!(connectionStatus);
    }
    _isConnected = connectionStatus;
  }

  /// Called when the socket has data.
  void _dataHandler(List<int> data) {
    _responseData.addAll(data);

    // 0x0A is newline
    // https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-basics.html
    if (data.last == 0x0A) {
      try {
        final response = jsonDecode(String.fromCharCodes(_responseData))
            as Map<String, dynamic>;
        _responseHandler(response);
      } catch (e, s) {
        Logging.instance
            .log("JsonRPC jsonDecode: $e\n$s", level: LogLevel.Error);
        rethrow;
      } finally {
        _responseData = [];
      }
    }
  }

  /// Called when the socket has a response.
  void _responseHandler(Map<String, dynamic> response) {
    // subscriptions will have a method in the response
    if (response['method'] is String) {
      _subscriptionHandler(response: response);
      return;
    }

    final id = response['id'] as String;
    final result = response['result'];

    _complete(id, result);
  }

  /// Called when the subscription has a response.
  void _subscriptionHandler({
    required Map<String, dynamic> response,
  }) {
    final method = response['method'];
    switch (method) {
      case "blockchain.scripthash.subscribe":
        final params = response["params"] as List<dynamic>;
        final scripthash = params.first as String;
        final taskId = "blockchain.scripthash.subscribe:$scripthash";

        _tasks[taskId]?.subscription?.addToStream(params.last);
        break;
      case "blockchain.headers.subscribe":
        final params = response["params"];
        const taskId = "blockchain.headers.subscribe";

        _tasks[taskId]?.subscription?.addToStream(params.first);
        break;
      default:
        break;
    }
  }

  /// Called when the socket has an error.
  void _errorHandler(Object error, StackTrace trace) {
    _updateConnectionStatus(false);
    Logging.instance.log(
        "SubscribableElectrumXClient called _errorHandler with: $error\n$trace",
        level: LogLevel.Info);
  }

  /// Called when the socket is closed.
  void _doneHandler() {
    _updateConnectionStatus(false);
    Logging.instance.log("SubscribableElectrumXClient called _doneHandler",
        level: LogLevel.Info);
  }

  /// Complete a task with the given id and data.
  void _complete(String id, dynamic data) {
    if (_tasks[id] == null) {
      return;
    }

    if (!(_tasks[id]?.completer?.isCompleted ?? false)) {
      _tasks[id]?.completer?.complete(data);
    }

    if (!(_tasks[id]?.isSubscription ?? false)) {
      _tasks.remove(id);
    } else {
      _tasks[id]?.subscription?.addToStream(data);
    }
  }

  /// Add a task to the task list.
  void _addTask({
    required String id,
    required Completer<dynamic> completer,
  }) {
    _tasks[id] = SocketTask(completer: completer, subscription: null);
  }

  /// Add a subscription task to the task list.
  void _addSubscriptionTask({
    required String id,
    required ElectrumXSubscription subscription,
  }) {
    _tasks[id] = SocketTask(completer: null, subscription: subscription);
  }

  /// Write call to socket.
  Future<dynamic> _call({
    required String method,
    List<dynamic> params = const [],
  }) async {
    // If we're connecting to Tor, wait.
    if (_requireMutex) {
      await _torConnectingLock.protect(() async => await _checkRpcClient());
    } else {
      await _checkRpcClient();
    }

    // Check socket is connected.
    if (_prefs.useTor) {
      if (_socksSocket == null) {
        final msg = "SubscribableElectrumXClient._call: "
            "SOCKSSocket is not connected.  Method $method, params $params.";
        Logging.instance.log(msg, level: LogLevel.Fatal);
        throw Exception(msg);
      }
    } else {
      if (_socket == null) {
        final msg = "SubscribableElectrumXClient._call: "
            "Socket is not connected.  Method $method, params $params.";
        Logging.instance.log(msg, level: LogLevel.Fatal);
        throw Exception(msg);
      }
    }

    final completer = Completer<dynamic>();
    _currentRequestID++;
    final id = _currentRequestID.toString();

    // Write to the socket.
    try {
      _addTask(id: id, completer: completer);

      if (_prefs.useTor) {
        _socksSocket?.write(
          _buildJsonRequestString(
            method: method,
            id: id,
            params: params,
          ),
        );
      } else {
        _socket?.write(
          _buildJsonRequestString(
            method: method,
            id: id,
            params: params,
          ),
        );
      }

      return completer.future;
    } catch (e, s) {
      final String msg = "SubscribableElectrumXClient._call: "
          "failed to request $method with id $id."
          "\nError: $e\nStack trace: $s";
      Logging.instance.log(msg, level: LogLevel.Fatal);
      throw JsonRpcException(msg);
    }
  }

  /// Write call to socket with timeout.
  Future<dynamic> _callWithTimeout({
    required String method,
    List<dynamic> params = const [],
    Duration timeout = const Duration(seconds: 2),
  }) async {
    // If we're connecting to Tor, wait.
    if (_requireMutex) {
      await _torConnectingLock.protect(() async => await _checkRpcClient());
    } else {
      await _checkRpcClient();
    }

    // Check socket is connected.
    if (_prefs.useTor) {
      if (_socksSocket == null) {
        try {
          if (_host == null || _port == null) {
            throw Exception("No host or port provided");
          }

          // Attempt to conect.
          await connect(
            host: _host!,
            port: _port!,
          );
        } catch (e, s) {
          final msg = "SubscribableElectrumXClient._callWithTimeout: "
              "SOCKSSocket  not connected and cannot connect.  "
              "Method $method, params $params."
              "\nError: $e\nStack trace: $s";
          Logging.instance.log(msg, level: LogLevel.Fatal);
          throw Exception(msg);
        }
      }
    } else {
      if (_socket == null) {
        try {
          if (_host == null || _port == null) {
            throw Exception("No host or port provided");
          }

          // Attempt to conect.
          await connect(
            host: _host!,
            port: _port!,
          );
        } catch (e, s) {
          final msg = "SubscribableElectrumXClient._callWithTimeout: "
              "Socket not connected and cannot connect.  "
              "Method $method, params $params.";
          Logging.instance.log(msg, level: LogLevel.Fatal);
          throw Exception(msg);
        }
      }
    }

    final completer = Completer<dynamic>();
    _currentRequestID++;
    final id = _currentRequestID.toString();

    // Write to the socket.
    try {
      _addTask(id: id, completer: completer);

      if (_prefs.useTor) {
        _socksSocket?.write(
          _buildJsonRequestString(
            method: method,
            id: id,
            params: params,
          ),
        );
      } else {
        _socket?.write(
          _buildJsonRequestString(
            method: method,
            id: id,
            params: params,
          ),
        );
      }

      Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.completeError(
            Exception("Request \"id: $id, method: $method\" timed out!"),
          );
        }
      });

      return completer.future;
    } catch (e, s) {
      final String msg = "SubscribableElectrumXClient._callWithTimeout: "
          "failed to request $method with id $id (timeout $timeout)."
          "\nError: $e\nStack trace: $s";
      Logging.instance.log(msg, level: LogLevel.Fatal);
      throw JsonRpcException(msg);
    }
  }

  ElectrumXSubscription _subscribe({
    required String id,
    required String method,
    List<dynamic> params = const [],
  }) {
    try {
      final subscription = ElectrumXSubscription();
      _addSubscriptionTask(id: id, subscription: subscription);
      _currentRequestID++;

      // Check socket is connected.
      if (_prefs.useTor) {
        if (_socksSocket == null) {
          final msg = "SubscribableElectrumXClient._call: "
              "SOCKSSocket is not connected.  Method $method, params $params.";
          Logging.instance.log(msg, level: LogLevel.Fatal);
          throw Exception(msg);
        }
      } else {
        if (_socket == null) {
          final msg = "SubscribableElectrumXClient._call: "
              "Socket is not connected.  Method $method, params $params.";
          Logging.instance.log(msg, level: LogLevel.Fatal);
          throw Exception(msg);
        }
      }

      // Write to the socket.
      if (_prefs.useTor) {
        _socksSocket?.write(
          _buildJsonRequestString(
            method: method,
            id: id,
            params: params,
          ),
        );
      } else {
        _socket?.write(
          _buildJsonRequestString(
            method: method,
            id: id,
            params: params,
          ),
        );
      }

      return subscription;
    } catch (e, s) {
      final String msg = "SubscribableElectrumXClient._subscribe: "
          "failed to subscribe to $method with id $id."
          "\nError: $e\nStack trace: $s";
      Logging.instance.log(msg, level: LogLevel.Fatal);
      throw JsonRpcException(msg);
    }
  }

  /// Ping the server to ensure it is responding
  ///
  /// Returns true if ping succeeded
  Future<bool> ping() async {
    // If we're connecting to Tor, wait.
    if (_requireMutex) {
      await _torConnectingLock.protect(() async => await _checkRpcClient());
    } else {
      await _checkRpcClient();
    }

    // Write to the socket.
    try {
      final response = (await _callWithTimeout(method: "server.ping")) as Map;
      return response.keys.contains("result") && response["result"] == null;
    } catch (_) {
      return false;
    }
  }

  /// Subscribe to a scripthash to receive notifications on status changes
  ElectrumXSubscription subscribeToScripthash({required String scripthash}) {
    return _subscribe(
      id: 'blockchain.scripthash.subscribe:$scripthash',
      method: 'blockchain.scripthash.subscribe',
      params: [scripthash],
    );
  }

  /// Subscribe to block headers to receive notifications on new blocks found
  ///
  /// Returns the existing subscription if found
  ElectrumXSubscription subscribeToBlockHeaders() {
    return _tasks["blockchain.headers.subscribe"]?.subscription ??
        _subscribe(
          id: "blockchain.headers.subscribe",
          method: "blockchain.headers.subscribe",
          params: [],
        );
  }
}
