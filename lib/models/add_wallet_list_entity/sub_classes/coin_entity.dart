/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import '../add_wallet_list_entity.dart';
import '../../../wallets/crypto_currency/crypto_currency.dart';

class CoinEntity extends AddWalletListEntity {
  CoinEntity(this._coin);

  final CryptoCurrency _coin;

  @override
  CryptoCurrency get cryptoCurrency => _coin;

  @override
  String get name => cryptoCurrency.prettyName;

  @override
  String get ticker => cryptoCurrency.ticker;

  @override
  List<Object?> get props => [cryptoCurrency.identifier, name, ticker];
}
