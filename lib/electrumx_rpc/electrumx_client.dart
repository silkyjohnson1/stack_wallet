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
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:decimal/decimal.dart';
import 'package:electrum_adapter/electrum_adapter.dart' as electrum_adapter;
import 'package:electrum_adapter/electrum_adapter.dart';
import 'package:electrum_adapter/methods/specific/firo.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_libsparkmobile/flutter_libsparkmobile.dart';
import 'package:mutex/mutex.dart';
import 'package:stackwallet/electrumx_rpc/rpc.dart';
import 'package:stackwallet/exceptions/electrumx/no_such_transaction.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_connection_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/global_event_bus.dart';
import 'package:stackwallet/services/tor_service.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/prefs.dart';
import 'package:stream_channel/stream_channel.dart';

class WifiOnlyException implements Exception {}

class ElectrumXNode {
  ElectrumXNode({
    required this.address,
    required this.port,
    required this.name,
    required this.id,
    required this.useSSL,
  });
  final String address;
  final int port;
  final String name;
  final String id;
  final bool useSSL;

  factory ElectrumXNode.from(ElectrumXNode node) {
    return ElectrumXNode(
      address: node.address,
      port: node.port,
      name: node.name,
      id: node.id,
      useSSL: node.useSSL,
    );
  }

  @override
  String toString() {
    return "ElectrumXNode: {address: $address, port: $port, name: $name, useSSL: $useSSL}";
  }
}

class ElectrumXClient {
  String get host => _host;
  late String _host;

  int get port => _port;
  late int _port;

  bool get useSSL => _useSSL;
  late bool _useSSL;

  JsonRPC? get rpcClient => _rpcClient;
  JsonRPC? _rpcClient;

  StreamChannel<dynamic>? get electrumAdapterChannel => _electrumAdapterChannel;
  StreamChannel<dynamic>? _electrumAdapterChannel;

  ElectrumClient? get electrumAdapterClient => _electrumAdapterClient;
  ElectrumClient? _electrumAdapterClient;

  late Prefs _prefs;
  late TorService _torService;

  List<ElectrumXNode>? failovers;
  int currentFailoverIndex = -1;

  final Duration connectionTimeoutForSpecialCaseJsonRPCClients;

  Coin? get coin => _coin;
  late Coin? _coin;

  // add finalizer to cancel stream subscription when all references to an
  // instance of ElectrumX becomes inaccessible
  static final Finalizer<ElectrumXClient> _finalizer = Finalizer(
    (p0) {
      p0._torPreferenceListener?.cancel();
      p0._torStatusListener?.cancel();
    },
  );
  StreamSubscription<TorPreferenceChangedEvent>? _torPreferenceListener;
  StreamSubscription<TorConnectionStatusChangedEvent>? _torStatusListener;

  final Mutex _torConnectingLock = Mutex();
  bool _requireMutex = false;

  ElectrumXClient({
    required String host,
    required int port,
    required bool useSSL,
    required Prefs prefs,
    required List<ElectrumXNode> failovers,
    Coin? coin,
    JsonRPC? client,
    this.connectionTimeoutForSpecialCaseJsonRPCClients =
        const Duration(seconds: 60),
    TorService? torService,
    EventBus? globalEventBusForTesting,
  }) {
    _prefs = prefs;
    _torService = torService ?? TorService.sharedInstance;
    _host = host;
    _port = port;
    _useSSL = useSSL;
    _rpcClient = client;
    _coin = coin;

    final bus = globalEventBusForTesting ?? GlobalEventBus.instance;
    _torStatusListener = bus.on<TorConnectionStatusChangedEvent>().listen(
      (event) async {
        switch (event.newStatus) {
          case TorConnectionStatus.connecting:
            await _torConnectingLock.acquire();
            _requireMutex = true;
            break;

          case TorConnectionStatus.connected:
          case TorConnectionStatus.disconnected:
            if (_torConnectingLock.isLocked) {
              _torConnectingLock.release();
            }
            _requireMutex = false;
            break;
        }
      },
    );
    _torPreferenceListener = bus.on<TorPreferenceChangedEvent>().listen(
      (event) async {
        // not sure if we need to do anything specific here
        // switch (event.status) {
        //   case TorStatus.enabled:
        //   case TorStatus.disabled:
        // }

        // might be ok to just reset/kill the current _jsonRpcClient

        // since disconnecting is async and we want to ensure instant change over
        // we will keep temp reference to current rpc client to call disconnect
        // on before awaiting the disconnection future

        final temp = _rpcClient;

        // setting to null should force the creation of a new json rpc client
        // on the next request sent through this electrumx instance
        _rpcClient = null;
        _electrumAdapterChannel = null;
        _electrumAdapterClient = null;

        await temp?.disconnect(
          reason: "Tor status changed to \"${event.status}\"",
        );
      },
    );
  }

  factory ElectrumXClient.from({
    required ElectrumXNode node,
    required Prefs prefs,
    required List<ElectrumXNode> failovers,
    required Coin coin,
    TorService? torService,
    EventBus? globalEventBusForTesting,
  }) {
    return ElectrumXClient(
      host: node.address,
      port: node.port,
      useSSL: node.useSSL,
      prefs: prefs,
      torService: torService,
      failovers: failovers,
      globalEventBusForTesting: globalEventBusForTesting,
      coin: coin,
    );
  }

  Future<bool> _allow() async {
    if (_prefs.wifiOnly) {
      return (await Connectivity().checkConnectivity()) ==
          ConnectivityResult.wifi;
    }
    return true;
  }

  void _checkRpcClient() {
    // If we're supposed to use Tor...
    if (_prefs.useTor) {
      // But Tor isn't running...
      if (_torService.status != TorConnectionStatus.connected) {
        // And the killswitch isn't set...
        if (!_prefs.torKillSwitch) {
          // Then we'll just proceed and connect to ElectrumX through clearnet at the bottom of this function.
          Logging.instance.log(
            "Tor preference set but Tor is not enabled, killswitch not set, connecting to ElectrumX through clearnet",
            level: LogLevel.Warning,
          );
        } else {
          // ... But if the killswitch is set, then we throw an exception.
          throw Exception(
              "Tor preference and killswitch set but Tor is not enabled, not connecting to ElectrumX");
          // TODO [prio=low]: Try to start Tor.
        }
      } else {
        // Get the proxy info from the TorService.
        final proxyInfo = _torService.getProxyInfo();

        if (currentFailoverIndex == -1) {
          _rpcClient ??= JsonRPC(
            host: host,
            port: port,
            useSSL: useSSL,
            connectionTimeout: connectionTimeoutForSpecialCaseJsonRPCClients,
            proxyInfo: proxyInfo,
          );
        } else {
          _rpcClient ??= JsonRPC(
            host: failovers![currentFailoverIndex].address,
            port: failovers![currentFailoverIndex].port,
            useSSL: failovers![currentFailoverIndex].useSSL,
            connectionTimeout: connectionTimeoutForSpecialCaseJsonRPCClients,
            proxyInfo: proxyInfo,
          );
        }

        if (_rpcClient!.proxyInfo != proxyInfo) {
          _rpcClient!.proxyInfo = proxyInfo;
          _rpcClient!.disconnect(
            reason: "Tor proxyInfo does not match current info",
          );
        }

        return;
      }
    }
  }

  Future<void> checkElectrumAdapter() async {
    ({InternetAddress host, int port})? proxyInfo;

    // If we're supposed to use Tor...
    if (_prefs.useTor) {
      // But Tor isn't running...
      if (_torService.status != TorConnectionStatus.connected) {
        // And the killswitch isn't set...
        if (!_prefs.torKillSwitch) {
          // Then we'll just proceed and connect to ElectrumX through clearnet at the bottom of this function.
          Logging.instance.log(
            "Tor preference set but Tor is not enabled, killswitch not set, connecting to Electrum adapter through clearnet",
            level: LogLevel.Warning,
          );
        } else {
          // ... But if the killswitch is set, then we throw an exception.
          throw Exception(
              "Tor preference and killswitch set but Tor is not enabled, not connecting to Electrum adapter");
          // TODO [prio=low]: Try to start Tor.
        }
      } else {
        // Get the proxy info from the TorService.
        proxyInfo = _torService.getProxyInfo();
      }
    }

    // TODO [prio=med]: Add proxyInfo to StreamChannel (or add to wrapper).
    // if (_electrumAdapter!.proxyInfo != proxyInfo) {
    //   _electrumAdapter!.proxyInfo = proxyInfo;
    //   _electrumAdapter!.disconnect(
    //     reason: "Tor proxyInfo does not match current info",
    //   );
    // }

    // If the current ElectrumAdapterClient is closed, create a new one.
    if (_electrumAdapterClient != null &&
        _electrumAdapterClient!.peer.isClosed) {
      _electrumAdapterChannel = null;
      _electrumAdapterClient = null;
    }

    if (currentFailoverIndex == -1) {
      _electrumAdapterChannel ??= await electrum_adapter.connect(
        host,
        port: port,
        connectionTimeout: connectionTimeoutForSpecialCaseJsonRPCClients,
        aliveTimerDuration: connectionTimeoutForSpecialCaseJsonRPCClients,
        acceptUnverified: true,
        useSSL: useSSL,
        proxyInfo: proxyInfo,
      );
      if (_coin == Coin.firo || _coin == Coin.firoTestNet) {
        _electrumAdapterClient ??= FiroElectrumClient(
          _electrumAdapterChannel!,
          host,
          port,
          useSSL,
          proxyInfo,
        );
      } else {
        _electrumAdapterClient ??= ElectrumClient(
          _electrumAdapterChannel!,
          host,
          port,
          useSSL,
          proxyInfo,
        );
      }
    } else {
      _electrumAdapterChannel ??= await electrum_adapter.connect(
        failovers![currentFailoverIndex].address,
        port: failovers![currentFailoverIndex].port,
        connectionTimeout: connectionTimeoutForSpecialCaseJsonRPCClients,
        aliveTimerDuration: connectionTimeoutForSpecialCaseJsonRPCClients,
        acceptUnverified: true,
        useSSL: failovers![currentFailoverIndex].useSSL,
        proxyInfo: proxyInfo,
      );
      if (_coin == Coin.firo || _coin == Coin.firoTestNet) {
        _electrumAdapterClient ??= FiroElectrumClient(
          _electrumAdapterChannel!,
          failovers![currentFailoverIndex].address,
          failovers![currentFailoverIndex].port,
          failovers![currentFailoverIndex].useSSL,
          proxyInfo,
        );
      } else {
        _electrumAdapterClient ??= ElectrumClient(
          _electrumAdapterChannel!,
          failovers![currentFailoverIndex].address,
          failovers![currentFailoverIndex].port,
          failovers![currentFailoverIndex].useSSL,
          proxyInfo,
        );
      }
    }

    return;
  }

  /// Send raw rpc command
  Future<dynamic> request({
    required String command,
    List<dynamic> args = const [],
    String? requestID,
    int retries = 2,
    Duration requestTimeout = const Duration(seconds: 60),
  }) async {
    if (!(await _allow())) {
      throw WifiOnlyException();
    }

    if (_requireMutex) {
      await _torConnectingLock
          .protect(() async => await checkElectrumAdapter());
    } else {
      await checkElectrumAdapter();
    }

    try {
      final response = await _electrumAdapterClient!.request(
        command,
        args,
      );

      if (response is Map &&
          response.keys.contains("error") &&
          response["error"] != null) {
        if (response["error"]
            .toString()
            .contains("No such mempool or blockchain transaction")) {
          throw NoSuchTransactionException(
            "No such mempool or blockchain transaction",
            args.first.toString(),
          );
        }

        throw Exception(
          "JSONRPC response\n"
          "     command: $command\n"
          "     error: ${response["error"]}\n"
          "     args: $args\n",
        );
      }

      currentFailoverIndex = -1;
      return response;
    } on WifiOnlyException {
      rethrow;
    } on SocketException {
      // likely timed out so then retry
      if (retries > 0) {
        return request(
          command: command,
          args: args,
          requestTimeout: requestTimeout,
          requestID: requestID,
          retries: retries - 1,
        );
      } else {
        rethrow;
      }
    } catch (e) {
      if (failovers != null && currentFailoverIndex < failovers!.length - 1) {
        currentFailoverIndex++;
        return request(
          command: command,
          args: args,
          requestTimeout: requestTimeout,
          requestID: requestID,
        );
      } else {
        currentFailoverIndex = -1;
        rethrow;
      }
    }
  }

  /// send a batch request with [command] where [args] is a
  /// map of <request id string : arguments list>
  ///
  /// returns a list of json response objects if no errors were found
  Future<List<dynamic>> batchRequest({
    required String command,
    required Map<String, List<dynamic>> args,
    Duration requestTimeout = const Duration(seconds: 60),
    int retries = 2,
  }) async {
    if (!(await _allow())) {
      throw WifiOnlyException();
    }

    if (_requireMutex) {
      await _torConnectingLock
          .protect(() async => await checkElectrumAdapter());
    } else {
      await checkElectrumAdapter();
    }

    try {
      var futures = <Future<dynamic>>[];
      List? response;
      _electrumAdapterClient!.peer.withBatch(() {
        for (final entry in args.entries) {
          futures.add(_electrumAdapterClient!.request(command, entry.value));
        }
      });
      response = await Future.wait(futures);

      // check for errors, format and throw if there are any
      final List<String> errors = [];
      for (int i = 0; i < response.length; i++) {
        var result = response[i];

        if (result == null || (result is List && result.isEmpty)) {
          continue;
          // TODO [prio=extreme]: Figure out if this is actually an issue.
        }
        result = result[0]; // Unwrap the list.
        if ((result is Map && result.keys.contains("error")) ||
            result == null) {
          errors.add(result.toString());
        }
      }
      if (errors.isNotEmpty) {
        String error = "[\n";
        for (int i = 0; i < errors.length; i++) {
          error += "${errors[i]}\n";
        }
        error += "]";
        throw Exception("JSONRPC response error: $error");
      }

      currentFailoverIndex = -1;
      return response;
    } on WifiOnlyException {
      rethrow;
    } on SocketException {
      // likely timed out so then retry
      if (retries > 0) {
        return batchRequest(
          command: command,
          args: args,
          requestTimeout: requestTimeout,
          retries: retries - 1,
        );
      } else {
        rethrow;
      }
    } catch (e) {
      if (failovers != null && currentFailoverIndex < failovers!.length - 1) {
        currentFailoverIndex++;
        return batchRequest(
          command: command,
          args: args,
          requestTimeout: requestTimeout,
        );
      } else {
        currentFailoverIndex = -1;
        rethrow;
      }
    }
  }

  /// Ping the server to ensure it is responding
  ///
  /// Returns true if ping succeeded
  Future<bool> ping({String? requestID, int retryCount = 1}) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'server.ping',
        requestTimeout: const Duration(seconds: 2),
        retries: retryCount,
      ).timeout(const Duration(seconds: 2)) as Map<String, dynamic>;
      return response.isNotEmpty; // TODO [prio=extreme]: Fix this.
    } catch (e) {
      rethrow;
    }
  }

  /// Get most recent block header.
  ///
  /// Returns a map with keys 'height' and 'hex' corresponding to the block height
  /// and the binary header as a hexadecimal string.
  /// Ex:
  /// {
  ///   "height": 520481,
  ///   "hex": "00000020890208a0ae3a3892aa047c5468725846577cfcd9b512b50000000000000000005dc2b02f2d297a9064ee103036c14d678f9afc7e3d9409cf53fd58b82e938e8ecbeca05a2d2103188ce804c4"
  /// }
  Future<Map<String, dynamic>> getBlockHeadTip({String? requestID}) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'blockchain.headers.subscribe',
      );
      if (response == null) {
        Logging.instance.log(
          "getBlockHeadTip returned null response",
          level: LogLevel.Error,
        );
        throw 'getBlockHeadTip returned null response';
      }
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      rethrow;
    }
  }

  /// Get server info
  ///
  /// Returns a map with server information
  /// Ex:
  /// {
  /// "genesis_hash": "000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943",
  /// "hosts": {"14.3.140.101": {"tcp_port": 51001, "ssl_port": 51002}},
  /// "protocol_max": "1.0",
  /// "protocol_min": "1.0",
  /// "pruning": null,
  /// "server_version": "ElectrumX 1.0.17",
  /// "hash_function": "sha256"
  /// }
  Future<Map<String, dynamic>> getServerFeatures({String? requestID}) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'server.features',
      );
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      rethrow;
    }
  }

  /// Broadcast a transaction to the network.
  ///
  /// The transaction hash as a hexadecimal string.
  Future<String> broadcastTransaction({
    required String rawTx,
    String? requestID,
  }) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'blockchain.transaction.broadcast',
        args: [
          rawTx,
        ],
      );
      return response as String;
    } catch (e) {
      rethrow;
    }
  }

  /// Return the confirmed and unconfirmed balances for the scripthash of a given scripthash
  ///
  /// Returns a map with keys confirmed and unconfirmed. The value of each is
  /// the appropriate balance in minimum coin units (satoshis).
  /// Ex:
  /// {
  ///   "confirmed": 103873966,
  ///   "unconfirmed": 23684400
  /// }
  Future<Map<String, dynamic>> getBalance({
    required String scripthash,
    String? requestID,
  }) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'blockchain.scripthash.get_balance',
        args: [
          scripthash,
        ],
      );
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      rethrow;
    }
  }

  /// Return the confirmed and unconfirmed history for the given scripthash.
  ///
  /// Returns a list of maps that contain the tx_hash and height of the tx.
  /// Ex:
  /// [
  ///   {
  ///     "height": 200004,
  ///     "tx_hash": "acc3758bd2a26f869fcc67d48ff30b96464d476bca82c1cd6656e7d506816412"
  ///   },
  ///   {
  ///     "height": 215008,
  ///     "tx_hash": "f3e1bf48975b8d6060a9de8884296abb80be618dc00ae3cb2f6cee3085e09403"
  ///   }
  /// ]
  Future<List<Map<String, dynamic>>> getHistory({
    required String scripthash,
    String? requestID,
  }) async {
    try {
      int retryCount = 3;
      dynamic result;

      while (retryCount > 0 && result is! List) {
        final response = await request(
          requestID: requestID,
          command: 'blockchain.scripthash.get_history',
          requestTimeout: const Duration(minutes: 5),
          args: [
            scripthash,
          ],
        );
        result = response;
        retryCount--;
      }

      return List<Map<String, dynamic>>.from(result as List);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<int, List<Map<String, dynamic>>>> getBatchHistory(
      {required Map<String, List<dynamic>> args}) async {
    try {
      final response = await batchRequest(
        command: 'blockchain.scripthash.get_history',
        args: args,
      );
      final Map<int, List<Map<String, dynamic>>> result = {};
      for (int i = 0; i < response.length; i++) {
        result[i] = List<Map<String, dynamic>>.from(response[i] as List);
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Return an ordered list of UTXOs sent to a script hash of the given scripthash.
  ///
  /// Returns a list of maps.
  /// Ex:
  /// [
  ///   {
  ///     "tx_pos": 0,
  ///     "value": 45318048,
  ///     "tx_hash": "9f2c45a12db0144909b5db269415f7319179105982ac70ed80d76ea79d923ebf",
  ///     "height": 437146
  ///   },
  ///   {
  ///     "tx_pos": 0,
  ///     "value": 919195,
  ///     "tx_hash": "3d2290c93436a3e964cfc2f0950174d8847b1fbe3946432c4784e168da0f019f",
  ///     "height": 441696
  ///   }
  /// ]
  Future<List<Map<String, dynamic>>> getUTXOs({
    required String scripthash,
    String? requestID,
  }) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'blockchain.scripthash.listunspent',
        args: [
          scripthash,
        ],
      );
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<int, List<Map<String, dynamic>>>> getBatchUTXOs(
      {required Map<String, List<dynamic>> args}) async {
    try {
      final response = await batchRequest(
        command: 'blockchain.scripthash.listunspent',
        args: args,
      );
      final Map<int, List<Map<String, dynamic>>> result = {};
      for (int i = 0; i < response.length; i++) {
        if ((response[i] as List).isNotEmpty) {
          try {
            // result[i] = response[i] as List<Map<String, dynamic>>;
            result[i] = List<Map<String, dynamic>>.from(response[i] as List);
          } catch (e) {
            print(response[i]);
            Logging.instance.log(
              "getBatchUTXOs failed to parse response",
              level: LogLevel.Error,
            );
          }
        }
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Returns a raw transaction given the tx_hash.
  ///
  /// Returns a list of maps.
  /// Ex when verbose=false:
  /// "01000000015bb9142c960a838329694d3fe9ba08c2a6421c5158d8f7044cb7c48006c1b48"
  /// "4000000006a4730440220229ea5359a63c2b83a713fcc20d8c41b20d48fe639a639d2a824"
  /// "6a137f29d0fc02201de12de9c056912a4e581a62d12fb5f43ee6c08ed0238c32a1ee76921"
  /// "3ca8b8b412103bcf9a004f1f7a9a8d8acce7b51c983233d107329ff7c4fb53e44c855dbe1"
  /// "f6a4feffffff02c6b68200000000001976a9141041fb024bd7a1338ef1959026bbba86006"
  /// "4fe5f88ac50a8cf00000000001976a91445dac110239a7a3814535c15858b939211f85298"
  /// "88ac61ee0700"
  ///
  ///
  /// Ex when verbose=true:
  /// {
  ///   "blockhash": "0000000000000000015a4f37ece911e5e3549f988e855548ce7494a0a08b2ad6",
  ///   "blocktime": 1520074861,
  ///   "confirmations": 679,
  ///   "hash": "36a3692a41a8ac60b73f7f41ee23f5c917413e5b2fad9e44b34865bd0d601a3d",
  ///   "hex": "01000000015bb9142c960a838329694d3fe9ba08c2a6421c5158d8f7044cb7c48006c1b484000000006a4730440220229ea5359a63c2b83a713fcc20d8c41b20d48fe639a639d2a8246a137f29d0fc02201de12de9c056912a4e581a62d12fb5f43ee6c08ed0238c32a1ee769213ca8b8b412103bcf9a004f1f7a9a8d8acce7b51c983233d107329ff7c4fb53e44c855dbe1f6a4feffffff02c6b68200000000001976a9141041fb024bd7a1338ef1959026bbba860064fe5f88ac50a8cf00000000001976a91445dac110239a7a3814535c15858b939211f8529888ac61ee0700",
  ///   "locktime": 519777,
  ///   "size": 225,
  ///   "time": 1520074861,
  ///   "txid": "36a3692a41a8ac60b73f7f41ee23f5c917413e5b2fad9e44b34865bd0d601a3d",
  ///   "version": 1,
  ///   "vin": [ {
  ///     "scriptSig": {
  ///       "asm": "30440220229ea5359a63c2b83a713fcc20d8c41b20d48fe639a639d2a8246a137f29d0fc02201de12de9c056912a4e581a62d12fb5f43ee6c08ed0238c32a1ee769213ca8b8b[ALL|FORKID] 03bcf9a004f1f7a9a8d8acce7b51c983233d107329ff7c4fb53e44c855dbe1f6a4",
  ///       "hex": "4730440220229ea5359a63c2b83a713fcc20d8c41b20d48fe639a639d2a8246a137f29d0fc02201de12de9c056912a4e581a62d12fb5f43ee6c08ed0238c32a1ee769213ca8b8b412103bcf9a004f1f7a9a8d8acce7b51c983233d107329ff7c4fb53e44c855dbe1f6a4"
  ///     },
  ///     "sequence": 4294967294,
  ///     "txid": "84b4c10680c4b74c04f7d858511c42a6c208bae93f4d692983830a962c14b95b",
  ///     "vout": 0}],
  ///   "vout": [ { "n": 0,
  ///              "scriptPubKey": { "addresses": [ "12UxrUZ6tyTLoR1rT1N4nuCgS9DDURTJgP"],
  ///                                "asm": "OP_DUP OP_HASH160 1041fb024bd7a1338ef1959026bbba860064fe5f OP_EQUALVERIFY OP_CHECKSIG",
  ///                                "hex": "76a9141041fb024bd7a1338ef1959026bbba860064fe5f88ac",
  ///                                "reqSigs": 1,
  ///                                "type": "pubkeyhash"},
  ///              "value": 0.0856647},
  ///            { "n": 1,
  ///              "scriptPubKey": { "addresses": [ "17NMgYPrguizvpJmB1Sz62ZHeeFydBYbZJ"],
  ///                                "asm": "OP_DUP OP_HASH160 45dac110239a7a3814535c15858b939211f85298 OP_EQUALVERIFY OP_CHECKSIG",
  ///                                "hex": "76a91445dac110239a7a3814535c15858b939211f8529888ac",
  ///                                "reqSigs": 1,
  ///                                "type": "pubkeyhash"},
  ///              "value": 0.1360904}]}
  Future<Map<String, dynamic>> getTransaction({
    required String txHash,
    bool verbose = true,
    String? requestID,
  }) async {
    Logging.instance.log("attempting to fetch blockchain.transaction.get...",
        level: LogLevel.Info);
    await checkElectrumAdapter();
    dynamic response = await _electrumAdapterClient!.getTransaction(txHash);
    Logging.instance.log("Fetching blockchain.transaction.get finished",
        level: LogLevel.Info);

    if (!verbose) {
      return {"rawtx": response as String};
    }

    return Map<String, dynamic>.from(response as Map);
  }

  /// Returns the whole Lelantus anonymity set for denomination in the groupId.
  ///
  /// ex:
  ///  {
  ///     "blockHash": "37effb57352693f4efcb1710bf68e3a0d79ff6b8f1605529de3e0706d9ca21da",
  ///     "setHash": "aae1a64f19f5ccce1c242dfe331d8db2883a9508d998efa3def8a64844170fe4",
  ///     "coins": [
  ///               [dynamic list of length 4],
  ///               [dynamic list of length 4],
  ///               ....
  ///               [dynamic list of length 4],
  ///               [dynamic list of length 4],
  ///         ]
  ///   }
  Future<Map<String, dynamic>> getLelantusAnonymitySet({
    String groupId = "1",
    String blockhash = "",
    String? requestID,
  }) async {
    Logging.instance.log("attempting to fetch lelantus.getanonymityset...",
        level: LogLevel.Info);
    await checkElectrumAdapter();
    Map<String, dynamic> response =
        await (_electrumAdapterClient as FiroElectrumClient)!
            .getLelantusAnonymitySet(groupId: groupId, blockHash: blockhash);
    Logging.instance.log("Fetching lelantus.getanonymityset finished",
        level: LogLevel.Info);
    return response;
  }

  //TODO add example to docs
  ///
  ///
  /// Returns the block height and groupId of a Lelantus pubcoin.
  Future<dynamic> getLelantusMintData({
    dynamic mints,
    String? requestID,
  }) async {
    Logging.instance.log("attempting to fetch lelantus.getmintmetadata...",
        level: LogLevel.Info);
    await checkElectrumAdapter();
    dynamic response = await (_electrumAdapterClient as FiroElectrumClient)!
        .getLelantusMintData(mints: mints);
    Logging.instance.log("Fetching lelantus.getmintmetadata finished",
        level: LogLevel.Info);
    return response;
  }

  //TODO add example to docs
  /// Returns the whole set of the used Lelantus coin serials.
  Future<Map<String, dynamic>> getLelantusUsedCoinSerials({
    String? requestID,
    required int startNumber,
  }) async {
    Logging.instance.log("attempting to fetch lelantus.getusedcoinserials...",
        level: LogLevel.Info);
    await checkElectrumAdapter();

    int retryCount = 3;
    dynamic response;

    while (retryCount > 0 && response is! List) {
      response = await (_electrumAdapterClient as FiroElectrumClient)!
          .getLelantusUsedCoinSerials(startNumber: startNumber);
      // TODO add 2 minute timeout.
      Logging.instance.log("Fetching lelantus.getusedcoinserials finished",
          level: LogLevel.Info);

      retryCount--;
    }

    return Map<String, dynamic>.from(response as Map);
  }

  /// Returns the latest Lelantus set id
  ///
  /// ex: 1
  Future<int> getLelantusLatestCoinId({String? requestID}) async {
    Logging.instance.log("attempting to fetch lelantus.getlatestcoinid...",
        level: LogLevel.Info);
    await checkElectrumAdapter();
    int response =
        await (_electrumAdapterClient as FiroElectrumClient).getLatestCoinId();
    Logging.instance.log("Fetching lelantus.getlatestcoinid finished",
        level: LogLevel.Info);
    return response;
  }

  // ============== Spark ======================================================

  // New Spark ElectrumX methods:
  // > Functions provided by ElectrumX servers
  // >   // >

  /// Returns the whole Spark anonymity set for denomination in the groupId.
  ///
  /// Takes [coinGroupId] and [startBlockHash], if the last is empty it returns full set,
  /// otherwise returns mint after that block, we need to call this to keep our
  /// anonymity set data up to date.
  ///
  /// Returns blockHash (last block hash),
  /// setHash (hash of current set)
  /// and coins (the list of pairs serialized coin and tx hash)
  Future<Map<String, dynamic>> getSparkAnonymitySet({
    String coinGroupId = "1",
    String startBlockHash = "",
    String? requestID,
  }) async {
    try {
      Logging.instance.log("attempting to fetch spark.getsparkanonymityset...",
          level: LogLevel.Info);
      await checkElectrumAdapter();
      Map<String, dynamic> response =
          await (_electrumAdapterClient as FiroElectrumClient)
              .getSparkAnonymitySet(
                  coinGroupId: coinGroupId, startBlockHash: startBlockHash);
      Logging.instance.log("Fetching spark.getsparkanonymityset finished",
          level: LogLevel.Info);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Takes [startNumber], if it is 0, we get the full set,
  /// otherwise the used tags after that number
  Future<Set<String>> getSparkUsedCoinsTags({
    String? requestID,
    required int startNumber,
  }) async {
    try {
      // Use electrum_adapter package's getSparkUsedCoinsTags method.
      Logging.instance.log("attempting to fetch spark.getusedcoinstags...",
          level: LogLevel.Info);
      await checkElectrumAdapter();
      Map<String, dynamic> response =
          await (_electrumAdapterClient as FiroElectrumClient)
              .getUsedCoinsTags(startNumber: startNumber);
      // TODO: Add 2 minute timeout.
      Logging.instance.log("Fetching spark.getusedcoinstags finished",
          level: LogLevel.Info);
      final map = Map<String, dynamic>.from(response);
      final set = Set<String>.from(map["tags"] as List);
      return await compute(_ffiHashTagsComputeWrapper, set);
    } catch (e) {
      Logging.instance.log(e, level: LogLevel.Error);
      rethrow;
    }
  }

  /// Takes a list of [sparkCoinHashes] and returns the set id and block height
  /// for each coin
  ///
  /// arg:
  /// {
  ///   "coinHashes": [
  ///       "b476ed2b374bb081ea51d111f68f0136252521214e213d119b8dc67b92f5a390",
  ///       "b476ed2b374bb081ea51d111f68f0136252521214e213d119b8dc67b92f5a390",
  ///   ]
  /// }
  Future<List<Map<String, dynamic>>> getSparkMintMetaData({
    String? requestID,
    required List<String> sparkCoinHashes,
  }) async {
    try {
      Logging.instance.log("attempting to fetch spark.getsparkmintmetadata...",
          level: LogLevel.Info);
      await checkElectrumAdapter();
      List<dynamic> response =
          await (_electrumAdapterClient as FiroElectrumClient)
              .getSparkMintMetaData(sparkCoinHashes: sparkCoinHashes);
      Logging.instance.log("Fetching spark.getsparkmintmetadata finished",
          level: LogLevel.Info);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Logging.instance.log(e, level: LogLevel.Error);
      rethrow;
    }
  }

  /// Returns the latest Spark set id
  ///
  /// ex: 1
  Future<int> getSparkLatestCoinId({
    String? requestID,
  }) async {
    try {
      Logging.instance.log("attempting to fetch spark.getsparklatestcoinid...",
          level: LogLevel.Info);
      await checkElectrumAdapter();
      int response = await (_electrumAdapterClient as FiroElectrumClient)
          .getSparkLatestCoinId();
      Logging.instance.log("Fetching spark.getsparklatestcoinid finished",
          level: LogLevel.Info);
      return response;
    } catch (e) {
      Logging.instance.log(e, level: LogLevel.Error);
      rethrow;
    }
  }

  // ===========================================================================

  /// Get the current fee rate.
  ///
  /// Returns a map with the kay "rate" that corresponds to the free rate in satoshis
  /// Ex:
  /// {
  ///   "rate": 1000,
  /// }
  Future<Map<String, dynamic>> getFeeRate({String? requestID}) async {
    await checkElectrumAdapter();
    return await _electrumAdapterClient!.getFeeRate();
  }

  /// Return the estimated transaction fee per kilobyte for a transaction to be confirmed within a certain number of [blocks].
  ///
  /// Returns a Decimal fee rate
  /// Ex:
  /// 0.00001000
  Future<Decimal> estimateFee({String? requestID, required int blocks}) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'blockchain.estimatefee',
        args: [
          blocks,
        ],
      );
      try {
        return Decimal.parse(response.toString());
      } catch (e, s) {
        final String msg = "Error parsing fee rate.  Response: $response"
            "\nResult: ${response}\nError: $e\nStack trace: $s";
        Logging.instance.log(msg, level: LogLevel.Fatal);
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Return the minimum fee a low-priority transaction must pay in order to be accepted to the daemon’s memory pool.
  ///
  /// Returns a Decimal fee rate
  /// Ex:
  /// 0.00001000
  Future<Decimal> relayFee({String? requestID}) async {
    try {
      final response = await request(
        requestID: requestID,
        command: 'blockchain.relayfee',
      );
      return Decimal.parse(response.toString());
    } catch (e) {
      rethrow;
    }
  }
}

Set<String> _ffiHashTagsComputeWrapper(Set<String> base64Tags) {
  return LibSpark.hashTags(base64Tags: base64Tags);
}
