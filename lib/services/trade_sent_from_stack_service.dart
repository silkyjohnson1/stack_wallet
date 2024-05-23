/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import '../db/hive/db.dart';
import '../models/trade_wallet_lookup.dart';

class TradeSentFromStackService extends ChangeNotifier {
  List<TradeWalletLookup> get all =>
      DB.instance.values<TradeWalletLookup>(boxName: DB.boxNameTradeLookup);

  String? getTradeIdForTxid(String txid) {
    final matches = all.where((e) => e.txid == txid);

    if (matches.length == 1) {
      return matches.first.tradeId;
    }
    return null;
  }

  String? getTxidForTradeId(String tradeId) {
    final matches = all.where((e) => e.tradeId == tradeId);

    if (matches.length == 1) {
      return matches.first.txid;
    }
    return null;
  }

  List<String>? getWalletIdsForTradeId(String tradeId) {
    final matches = all.where((e) => e.tradeId == tradeId);

    if (matches.length == 1) {
      return matches.first.walletIds;
    }
    return null;
  }

  List<String>? getWalletIdForTxid(String txid) {
    final matches = all.where((e) => e.txid == txid);

    if (matches.length == 1) {
      return matches.first.walletIds;
    }
    return null;
  }

  Future<void> save({
    required TradeWalletLookup tradeWalletLookup,
  }) async {
    await DB.instance.put(
        boxName: DB.boxNameTradeLookup,
        key: tradeWalletLookup.uuid,
        value: tradeWalletLookup);
    notifyListeners();
  }

  Future<void> delete({
    required TradeWalletLookup tradeWalletLookup,
  }) async {
    await DB.instance.delete<TradeWalletLookup>(
        key: tradeWalletLookup.uuid, boxName: DB.boxNameTradeLookup);
  }
}
