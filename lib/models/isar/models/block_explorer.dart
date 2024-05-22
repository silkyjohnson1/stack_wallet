/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:isar/isar.dart';
import 'package:stackwallet/app_config.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';

part 'block_explorer.g.dart';

@collection
class TransactionBlockExplorer {
  TransactionBlockExplorer({
    required this.ticker,
    required this.url,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late final String ticker;

  late final String url;

  @ignore
  CryptoCurrency? get coin {
    try {
      return AppConfig.getCryptoCurrencyForTicker(ticker);
    } catch (_) {
      return null;
    }
  }

  Uri? getUrlFor({required String txid}) => Uri.tryParse(
        url.replaceFirst(
          "%5BTXID%5D",
          txid,
        ),
      );
}
