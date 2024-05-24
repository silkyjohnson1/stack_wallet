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
import '../../isar/models/ethereum/eth_contract.dart';
import '../../../wallets/crypto_currency/coins/ethereum.dart';
import '../../../wallets/crypto_currency/crypto_currency.dart';

class EthTokenEntity extends AddWalletListEntity {
  EthTokenEntity(this.token);

  final EthContract token;

  // TODO: check other networks in future and handle differently?
  @override
  CryptoCurrency get cryptoCurrency => Ethereum(CryptoCurrencyNetwork.main);

  @override
  String get name => token.name;

  @override
  String get ticker => token.symbol;

  @override
  List<Object?> get props =>
      [cryptoCurrency.identifier, name, ticker, token.address];
}
