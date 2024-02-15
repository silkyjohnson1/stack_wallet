/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:convert';
import 'dart:math';

import 'package:electrum_adapter/electrum_adapter.dart' as electrum_adapter;
import 'package:electrum_adapter/electrum_adapter.dart';
import 'package:electrum_adapter/methods/specific/firo.dart';
import 'package:stackwallet/db/hive/db.dart';
import 'package:stackwallet/electrumx_rpc/electrumx_client.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:string_validator/string_validator.dart';

class CachedElectrumXClient {
  final ElectrumXClient electrumXClient;
  final ElectrumClient electrumAdapterClient;

  static const minCacheConfirms = 30;

  const CachedElectrumXClient({
    required this.electrumXClient,
    required this.electrumAdapterClient,
  });

  factory CachedElectrumXClient.from({
    required ElectrumXClient electrumXClient,
    required ElectrumClient electrumAdapterClient,
  }) =>
      CachedElectrumXClient(
          electrumXClient: electrumXClient,
          electrumAdapterClient: electrumAdapterClient);

  Future<Map<String, dynamic>> getAnonymitySet({
    required String groupId,
    String blockhash = "",
    required Coin coin,
  }) async {
    try {
      final box = await DB.instance.getAnonymitySetCacheBox(coin: coin);
      final cachedSet = box.get(groupId) as Map?;

      Map<String, dynamic> set;

      // null check to see if there is a cached set
      if (cachedSet == null) {
        set = {
          "setId": groupId,
          "blockHash": blockhash,
          "setHash": "",
          "coins": <dynamic>[],
        };
      } else {
        set = Map<String, dynamic>.from(cachedSet);
      }

      final newSet = await (electrumAdapterClient as FiroElectrumClient)
          .getLelantusAnonymitySet(
        groupId: groupId,
        blockHash: set["blockHash"] as String,
      );

      // update set with new data
      if (newSet["setHash"] != "" && set["setHash"] != newSet["setHash"]) {
        set["setHash"] = !isHexadecimal(newSet["setHash"] as String)
            ? base64ToHex(newSet["setHash"] as String)
            : newSet["setHash"];
        set["blockHash"] = !isHexadecimal(newSet["blockHash"] as String)
            ? base64ToReverseHex(newSet["blockHash"] as String)
            : newSet["blockHash"];
        for (int i = (newSet["coins"] as List).length - 1; i >= 0; i--) {
          dynamic newCoin = newSet["coins"][i];
          List<dynamic> translatedCoin = [];
          translatedCoin.add(!isHexadecimal(newCoin[0] as String)
              ? base64ToHex(newCoin[0] as String)
              : newCoin[0]);
          translatedCoin.add(!isHexadecimal(newCoin[1] as String)
              ? base64ToReverseHex(newCoin[1] as String)
              : newCoin[1]);
          try {
            translatedCoin.add(!isHexadecimal(newCoin[2] as String)
                ? base64ToHex(newCoin[2] as String)
                : newCoin[2]);
          } catch (e) {
            translatedCoin.add(newCoin[2]);
          }
          translatedCoin.add(!isHexadecimal(newCoin[3] as String)
              ? base64ToReverseHex(newCoin[3] as String)
              : newCoin[3]);
          set["coins"].insert(0, translatedCoin);
        }
        // save set to db
        await box.put(groupId, set);
        Logging.instance.log(
          "Updated current anonymity set for ${coin.name} with group ID $groupId",
          level: LogLevel.Info,
        );
      }

      return set;
    } catch (e, s) {
      Logging.instance.log(
          "Failed to process CachedElectrumX.getAnonymitySet(): $e\n$s",
          level: LogLevel.Error);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSparkAnonymitySet({
    required String groupId,
    String blockhash = "",
    required Coin coin,
  }) async {
    try {
      final box = await DB.instance.getSparkAnonymitySetCacheBox(coin: coin);
      final cachedSet = box.get(groupId) as Map?;

      Map<String, dynamic> set;

      // null check to see if there is a cached set
      if (cachedSet == null) {
        set = {
          "coinGroupID": int.parse(groupId),
          "blockHash": blockhash,
          "setHash": "",
          "coins": <dynamic>[],
        };
      } else {
        set = Map<String, dynamic>.from(cachedSet);
      }

      final newSet = await (electrumAdapterClient as FiroElectrumClient)
          .getSparkAnonymitySet(
        coinGroupId: groupId,
        startBlockHash: set["blockHash"] as String,
      );

      // update set with new data
      if (newSet["setHash"] != "" && set["setHash"] != newSet["setHash"]) {
        set["setHash"] = newSet["setHash"];
        set["blockHash"] = newSet["blockHash"];
        for (int i = (newSet["coins"] as List).length - 1; i >= 0; i--) {
          // TODO verify this is correct (or append?)
          if ((set["coins"] as List)
              .where((e) => e[0] == newSet["coins"][i][0])
              .isEmpty) {
            set["coins"].insert(0, newSet["coins"][i]);
          }
        }
        // save set to db
        await box.put(groupId, set);
        Logging.instance.log(
          "Updated current anonymity set for ${coin.name} with group ID $groupId",
          level: LogLevel.Info,
        );
      }

      return set;
    } catch (e, s) {
      Logging.instance.log(
          "Failed to process CachedElectrumX.getSparkAnonymitySet(): $e\n$s",
          level: LogLevel.Error);
      rethrow;
    }
  }

  String base64ToHex(String source) =>
      base64Decode(LineSplitter.split(source).join())
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join();

  String base64ToReverseHex(String source) =>
      base64Decode(LineSplitter.split(source).join())
          .reversed
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join();

  /// Call electrumx getTransaction on a per coin basis, storing the result in local db if not already there.
  ///
  /// ElectrumX api only called if the tx does not exist in local db
  Future<Map<String, dynamic>> getTransaction({
    required String txHash,
    required Coin coin,
    bool verbose = true,
  }) async {
    try {
      final box = await DB.instance.getTxCacheBox(coin: coin);

      final cachedTx = box.get(txHash) as Map?;
      if (cachedTx == null) {
        final Map<String, dynamic> result =
            await electrumAdapterClient.getTransaction(txHash);

        result.remove("hex");
        result.remove("lelantusData");
        result.remove("sparkData");

        if (result["confirmations"] != null &&
            result["confirmations"] as int > minCacheConfirms) {
          await box.put(txHash, result);
        }

        // Logging.instance.log("using fetched result", level: LogLevel.Info);
        return result;
      } else {
        // Logging.instance.log("using cached result", level: LogLevel.Info);
        return Map<String, dynamic>.from(cachedTx);
      }
    } catch (e, s) {
      Logging.instance.log(
          "Failed to process CachedElectrumX.getTransaction(): $e\n$s",
          level: LogLevel.Error);
      rethrow;
    }
  }

  Future<List<String>> getUsedCoinSerials({
    required Coin coin,
    int startNumber = 0,
  }) async {
    try {
      final box = await DB.instance.getUsedSerialsCacheBox(coin: coin);

      final _list = box.get("serials") as List?;

      Set<String> cachedSerials =
          _list == null ? {} : List<String>.from(_list).toSet();

      startNumber = max(
        max(0, startNumber),
        cachedSerials.length - 100, // 100 being some arbitrary buffer
      );

      final serials = await (electrumAdapterClient as FiroElectrumClient)
          .getLelantusUsedCoinSerials(
        startNumber: startNumber,
      );

      final newSerials = List<String>.from(serials["serials"] as List)
          .map((e) => !isHexadecimal(e) ? base64ToHex(e) : e)
          .toSet();

      // ensure we are getting some overlap so we know we are not missing any
      if (cachedSerials.isNotEmpty && newSerials.isNotEmpty) {
        assert(cachedSerials.intersection(newSerials).isNotEmpty);
      }

      cachedSerials.addAll(newSerials);

      final resultingList = cachedSerials.toList();

      await box.put(
        "serials",
        resultingList,
      );

      return resultingList;
    } catch (e, s) {
      Logging.instance.log(
        "Failed to process CachedElectrumX.getUsedCoinSerials(): $e\n$s",
        level: LogLevel.Error,
      );
      rethrow;
    }
  }

  Future<Set<String>> getSparkUsedCoinsTags({
    required Coin coin,
  }) async {
    try {
      final box = await DB.instance.getSparkUsedCoinsTagsCacheBox(coin: coin);

      final _list = box.get("tags") as List?;

      Set<String> cachedTags =
          _list == null ? {} : List<String>.from(_list).toSet();

      final startNumber = max(
        0,
        cachedTags.length - 100, // 100 being some arbitrary buffer
      );

      final tags =
          await (electrumAdapterClient as FiroElectrumClient).getUsedCoinsTags(
        startNumber: startNumber,
      );

      // final newSerials = List<String>.from(serials["serials"] as List)
      //     .map((e) => !isHexadecimal(e) ? base64ToHex(e) : e)
      //     .toSet();

      // Convert the Map<String, dynamic> tags to a Set<Object?>.
      final newTags = (tags["tags"] as List).toSet();

      // ensure we are getting some overlap so we know we are not missing any
      if (cachedTags.isNotEmpty && tags.isNotEmpty) {
        assert(cachedTags.intersection(newTags).isNotEmpty);
      }

      // Make newTags an Iterable<String>.
      final Iterable<String> iterableTags = newTags.map((e) => e.toString());

      cachedTags.addAll(iterableTags);

      await box.put(
        "tags",
        cachedTags.toList(),
      );

      return cachedTags;
    } catch (e, s) {
      Logging.instance.log(
        "Failed to process CachedElectrumX.getSparkUsedCoinsTags(): $e\n$s",
        level: LogLevel.Error,
      );
      rethrow;
    }
  }

  /// Clear all cached transactions for the specified coin
  Future<void> clearSharedTransactionCache({required Coin coin}) async {
    await DB.instance.clearSharedTransactionCache(coin: coin);
    await DB.instance.closeAnonymitySetCacheBox(coin: coin);
  }
}
