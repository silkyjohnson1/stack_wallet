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

import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';
import 'package:stackwallet/networking/socks_socket.dart';
import 'package:stackwallet/networking/tor_service.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/prefs.dart';

// Json RPC class to handle connecting to electrumx servers
class JsonRPC {
  JsonRPC({
    required this.host,
    required this.port,
    this.useSSL = false,
    this.connectionTimeout = const Duration(seconds: 60),
    required ({String host, int port})? proxyInfo,
  });
  final bool useSSL;
  final String host;
  final int port;
  final Duration connectionTimeout;
  ({String host, int port})? proxyInfo;

  final _requestMutex = Mutex();
  final _JsonRPCRequestQueue _requestQueue = _JsonRPCRequestQueue();
  Socket? _socket;
  SOCKSSocket? _socksSocket;
  StreamSubscription<List<int>>? _subscription;
  StreamSubscription<List<int>>? get subscription => _subscription;

  void _dataHandler(List<int> data) {
    _requestQueue.nextIncompleteReq.then((req) {
      if (req != null) {
        req.appendDataAndCheckIfComplete(data);

        if (req.isComplete) {
          _onReqCompleted(req);
        }
      } else {
        Logging.instance.log(
          "_dataHandler found a null req!",
          level: LogLevel.Warning,
        );
      }
    });
  }

  void _errorHandler(Object error, StackTrace trace) {
    _requestQueue.nextIncompleteReq.then((req) {
      if (req != null) {
        req.completer.completeError(error, trace);
        _onReqCompleted(req);
      }
    });
  }

  void _doneHandler() {
    disconnect(reason: "JsonRPC _doneHandler() called");
  }

  void _onReqCompleted(_JsonRPCRequest req) {
    _requestQueue.remove(req).then((_) {
      // attempt to send next request
      _sendNextAvailableRequest();
    });
  }

  void _sendNextAvailableRequest() {
    _requestQueue.nextIncompleteReq.then((req) {
      if (req != null) {
        // \r\n required by electrumx server
        if (_socket != null) {
          _socket!.write('${req.jsonRequest}\r\n');
        }
        if (_socksSocket != null) {
          _socksSocket!.write('${req.jsonRequest}\r\n');
          // _socksSocket!.socket.writeln('${req.jsonRequest}\r\n');
        }

        // TODO different timeout length?
        req.initiateTimeout(
          onTimedOut: () {
            _requestQueue.remove(req);
          },
        );
      }
    });
  }

  Future<JsonRPCResponse> request(
    String jsonRpcRequest,
    Duration requestTimeout,
  ) async {
    await _requestMutex.protect(() async {
      if (!Prefs.instance.useTor) {
        if (_socket == null) {
          Logging.instance.log(
            "JsonRPC request: opening socket $host:$port",
            level: LogLevel.Info,
          );
          await connect();
        }
      } else {
        if (_socksSocket == null) {
          Logging.instance.log(
            "JsonRPC request: opening SOCKS socket to $host:$port",
            level: LogLevel.Info,
          );
          await connect();
        }
      }
    });

    final req = _JsonRPCRequest(
      jsonRequest: jsonRpcRequest,
      requestTimeout: requestTimeout,
      completer: Completer<JsonRPCResponse>(),
    );

    final future = req.completer.future.onError(
      (error, stackTrace) async {
        await disconnect(
          reason: "return req.completer.future.onError: $error\n$stackTrace",
        );
        return JsonRPCResponse(
          exception: error is Exception
              ? error
              : Exception(
                  "req.completer.future.onError: $error\n$stackTrace",
                ),
        );
      },
    );

    // if this is the only/first request then send it right away
    await _requestQueue.add(
      req,
      onInitialRequestAdded: _sendNextAvailableRequest,
    );

    return future;
  }

  Future<void> disconnect({required String reason}) async {
    await _requestMutex.protect(() async {
      await _subscription?.cancel();
      _subscription = null;
      _socket?.destroy();
      _socket = null;
      await _socksSocket?.close();
      _socksSocket = null;

      // clean up remaining queue
      await _requestQueue.completeRemainingWithError(
        "JsonRPC disconnect() called with reason: \"$reason\"",
      );
    });
  }

  Future<void> connect() async {
    if (!Prefs.instance.useTor) {
      if (useSSL) {
        _socket = await SecureSocket.connect(
          host,
          port,
          timeout: connectionTimeout,
          onBadCertificate: (_) => true,
        ); // TODO do not automatically trust bad certificates
      } else {
        _socket = await Socket.connect(
          host,
          port,
          timeout: connectionTimeout,
        );
      }

      _subscription = _socket!.listen(
        _dataHandler,
        onError: _errorHandler,
        onDone: _doneHandler,
        cancelOnError: true,
      );
    } else {
      if (proxyInfo == null) {
        // TODO await tor / make sure it's running
        proxyInfo = (
          host: InternetAddress.loopbackIPv4.address,
          port: TorService.sharedInstance.port
        );
        Logging.instance.log(
            "ElectrumX.connect(): no tor proxy info, read $proxyInfo",
            level: LogLevel.Warning);
      }

      // instantiate a socks socket at localhost and on the port selected by the tor service
      _socksSocket = await SOCKSSocket.create(
        proxyHost: InternetAddress.loopbackIPv4.address,
        proxyPort: TorService.sharedInstance.port,
        sslEnabled: useSSL,
      );

      try {
        Logging.instance.log(
            "JsonRPC.connect(): connecting to SOCKS socket at $proxyInfo (SSL $useSSL)...",
            level: LogLevel.Info);

        await _socksSocket?.connect();

        Logging.instance.log(
            "JsonRPC.connect(): connected to SOCKS socket at $proxyInfo...",
            level: LogLevel.Info);
      } catch (e) {
        Logging.instance.log(
            "JsonRPC.connect(): failed to connect to SOCKS socket at $proxyInfo, $e",
            level: LogLevel.Error);
        throw Exception(
            "JsonRPC.connect(): failed to connect to SOCKS socket at $proxyInfo, $e");
      }

      try {
        Logging.instance.log(
            "JsonRPC.connect(): connecting to $host:$port over SOCKS socket at $proxyInfo...",
            level: LogLevel.Info);

        await _socksSocket?.connectTo(host, port);

        Logging.instance.log(
            "JsonRPC.connect(): connected to $host:$port over SOCKS socket at $proxyInfo",
            level: LogLevel.Info);
      } catch (e) {
        Logging.instance.log(
            "JsonRPC.connect(): failed to connect to $host over tor proxy at $proxyInfo, $e",
            level: LogLevel.Error);
        throw Exception(
            "JsonRPC.connect(): failed to connect to tor proxy, $e");
      }

      _subscription = _socksSocket!.listen(
        _dataHandler,
        onError: _errorHandler,
        onDone: _doneHandler,
        cancelOnError: true,
      );
    }
  }
}

class _JsonRPCRequestQueue {
  final _lock = Mutex();
  final List<_JsonRPCRequest> _rq = [];

  Future<void> add(
    _JsonRPCRequest req, {
    VoidCallback? onInitialRequestAdded,
  }) async {
    return await _lock.protect(() async {
      _rq.add(req);
      if (_rq.length == 1) {
        onInitialRequestAdded?.call();
      }
    });
  }

  Future<bool> remove(_JsonRPCRequest req) async {
    return await _lock.protect(() async {
      final result = _rq.remove(req);
      return result;
    });
  }

  Future<_JsonRPCRequest?> get nextIncompleteReq async {
    return await _lock.protect(() async {
      int removeCount = 0;
      _JsonRPCRequest? returnValue;
      for (final req in _rq) {
        if (req.isComplete) {
          removeCount++;
        } else {
          returnValue = req;
          break;
        }
      }

      _rq.removeRange(0, removeCount);

      return returnValue;
    });
  }

  Future<void> completeRemainingWithError(
    String error, {
    StackTrace? stackTrace,
  }) async {
    await _lock.protect(() async {
      for (final req in _rq) {
        if (!req.isComplete) {
          req.completer.completeError(Exception(error), stackTrace);
        }
      }
      _rq.clear();
    });
  }

  Future<bool> get isEmpty async {
    return await _lock.protect(() async {
      return _rq.isEmpty;
    });
  }
}

class _JsonRPCRequest {
  // 0x0A is newline
  // https://electrumx-spesmilo.readthedocs.io/en/latest/protocol-basics.html
  static const int separatorByte = 0x0A;

  final String jsonRequest;
  final Completer<JsonRPCResponse> completer;
  final Duration requestTimeout;
  final List<int> _responseData = [];

  _JsonRPCRequest({
    required this.jsonRequest,
    required this.completer,
    required this.requestTimeout,
  });

  void appendDataAndCheckIfComplete(List<int> data) {
    _responseData.addAll(data);
    if (data.last == separatorByte) {
      try {
        final response = json.decode(String.fromCharCodes(_responseData));
        completer.complete(JsonRPCResponse(data: response));
      } catch (e, s) {
        Logging.instance.log(
          "JsonRPC json.decode: $e\n$s",
          level: LogLevel.Error,
        );
        completer.completeError(e, s);
      }
    }
  }

  void initiateTimeout({
    VoidCallback? onTimedOut,
  }) {
    Future<void>.delayed(requestTimeout).then((_) {
      if (!isComplete) {
        try {
          throw Exception("_JsonRPCRequest timed out: $jsonRequest");
        } catch (e, s) {
          completer.completeError(e, s);
          onTimedOut?.call();
        }
      }
    });
  }

  bool get isComplete => completer.isCompleted;
}

class JsonRPCResponse {
  final dynamic data;
  final Exception? exception;

  JsonRPCResponse({this.data, this.exception});
}

bool isIpAddress(String host) {
  try {
    // if the string can be parsed into an InternetAddress, it's an IP.
    InternetAddress(host);
    return true;
  } catch (e) {
    // if parsing fails, it's not an IP.
    return false;
  }
}
