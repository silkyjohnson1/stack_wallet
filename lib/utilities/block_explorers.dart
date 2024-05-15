/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/models/isar/models/block_explorer.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';

// Returns internal Isar ID for the inserted object/record
Future<int> setBlockExplorerForCoin({
  required CryptoCurrency coin,
  required Uri url,
}) async {
  return await MainDB.instance.putTransactionBlockExplorer(
    TransactionBlockExplorer(
      ticker: coin.ticker,
      url: url.toString(),
    ),
  );
}

// Returns the block explorer URL for the given coin and txid
Uri getBlockExplorerTransactionUrlFor({
  required CryptoCurrency coin,
  required String txid,
}) {
  String? url =
      MainDB.instance.getTransactionBlockExplorer(cryptoCurrency: coin)?.url;
  if (url == null) {
    return coin.defaultBlockExplorer(txid);
  } else {
    url = url.replaceAll("%5BTXID%5D", txid);
    return Uri.parse(url);
  }
}
