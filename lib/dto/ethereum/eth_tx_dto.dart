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

import '../../utilities/amount/amount.dart';
import '../../wallets/crypto_currency/coins/ethereum.dart';
import '../../wallets/crypto_currency/crypto_currency.dart';

class EthTxDTO {
  EthTxDTO({
    required this.hash,
    required this.blockHash,
    required this.blockNumber,
    required this.transactionIndex,
    required this.timestamp,
    required this.from,
    required this.to,
    required this.value,
    required this.gas,
    required this.gasPrice,
    required this.maxFeePerGas,
    required this.maxPriorityFeePerGas,
    required this.isError,
    required this.hasToken,
    required this.gasCost,
    required this.gasUsed,
  });

  factory EthTxDTO.fromMap(Map<String, dynamic> map) => EthTxDTO(
        hash: map['hash'] as String,
        blockHash: map['blockHash'] as String,
        blockNumber: map['blockNumber'] as int,
        transactionIndex: map['transactionIndex'] as int,
        timestamp: map['timestamp'] as int,
        from: map['from'] as String,
        to: map['to'] as String,
        value: _amountFromJsonNum(map['value'])!,
        gas: _amountFromJsonNum(map['gas'])!,
        gasPrice: _amountFromJsonNum(map['gasPrice'])!,
        maxFeePerGas: _amountFromJsonNum(map['maxFeePerGas']),
        maxPriorityFeePerGas: _amountFromJsonNum(map['maxPriorityFeePerGas']),
        isError: map['isError'] as bool? ?? false,
        hasToken: map['hasToken'] as bool? ?? false,
        gasCost: _amountFromJsonNum(map['gasCost'])!,
        gasUsed: _amountFromJsonNum(map['gasUsed'])!,
      );

  final String hash;
  final String blockHash;
  final int blockNumber;
  final int transactionIndex;
  final int timestamp;
  final String from;
  final String to;
  final Amount value;
  final Amount gas;
  final Amount gasPrice;
  final Amount? maxFeePerGas;
  final Amount? maxPriorityFeePerGas;
  final bool isError;
  final bool hasToken;
  final Amount gasCost;
  final Amount gasUsed;

  static Amount? _amountFromJsonNum(dynamic json) {
    if (json == null) {
      return null;
    }
    return Amount(
      rawValue: BigInt.parse(json.toString()),
      fractionDigits: Ethereum(CryptoCurrencyNetwork.main).fractionDigits,
    );
  }

  EthTxDTO copyWith({
    String? hash,
    String? blockHash,
    int? blockNumber,
    int? transactionIndex,
    int? timestamp,
    String? from,
    String? to,
    Amount? value,
    Amount? gas,
    Amount? gasPrice,
    Amount? maxFeePerGas,
    Amount? maxPriorityFeePerGas,
    bool? isError,
    bool? hasToken,
    String? compressedTx,
    Amount? gasCost,
    Amount? gasUsed,
  }) =>
      EthTxDTO(
        hash: hash ?? this.hash,
        blockHash: blockHash ?? this.blockHash,
        blockNumber: blockNumber ?? this.blockNumber,
        transactionIndex: transactionIndex ?? this.transactionIndex,
        timestamp: timestamp ?? this.timestamp,
        from: from ?? this.from,
        to: to ?? this.to,
        value: value ?? this.value,
        gas: gas ?? this.gas,
        gasPrice: gasPrice ?? this.gasPrice,
        maxFeePerGas: maxFeePerGas ?? this.maxFeePerGas,
        maxPriorityFeePerGas: maxPriorityFeePerGas ?? this.maxPriorityFeePerGas,
        isError: isError ?? this.isError,
        hasToken: hasToken ?? this.hasToken,
        gasCost: gasCost ?? this.gasCost,
        gasUsed: gasUsed ?? this.gasUsed,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['hash'] = hash;
    map['blockHash'] = blockHash;
    map['blockNumber'] = blockNumber;
    map['transactionIndex'] = transactionIndex;
    map['timestamp'] = timestamp;
    map['from'] = from;
    map['to'] = to;
    map['value'] = value.toString();
    map['gas'] = gas.toString();
    map['gasPrice'] = gasPrice.toString();
    map['maxFeePerGas'] = maxFeePerGas.toString();
    map['maxPriorityFeePerGas'] = maxPriorityFeePerGas.toString();
    map['isError'] = isError;
    map['hasToken'] = hasToken;
    map['gasCost'] = gasCost.toString();
    map['gasUsed'] = gasUsed.toString();
    return map;
  }

  @override
  String toString() => jsonEncode(toMap());
}
