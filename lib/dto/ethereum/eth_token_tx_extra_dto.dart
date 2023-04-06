import 'dart:convert';

import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

class EthTokenTxExtraDTO {
  EthTokenTxExtraDTO({
    required this.blockHash,
    required this.blockNumber,
    required this.from,
    required this.gas,
    required this.gasCost,
    required this.gasPrice,
    required this.gasUsed,
    required this.hash,
    required this.input,
    required this.nonce,
    required this.timestamp,
    required this.to,
    required this.transactionIndex,
    required this.value,
  });

  factory EthTokenTxExtraDTO.fromMap(Map<String, dynamic> map) =>
      EthTokenTxExtraDTO(
        hash: map['hash'] as String,
        blockHash: map['blockHash'] as String,
        blockNumber: map['blockNumber'] as int,
        transactionIndex: map['transactionIndex'] as int,
        timestamp: map['timestamp'] as int,
        from: map['from'] as String,
        to: map['to'] as String,
        value: Amount(
          rawValue: BigInt.parse(map['value'] as String),
          fractionDigits: Coin.ethereum.decimals,
        ),
        gas: _amountFromJsonNum(map['gas']),
        gasPrice: _amountFromJsonNum(map['gasPrice']),
        nonce: map['nonce'] as int,
        input: map['input'] as String,
        gasCost: _amountFromJsonNum(map['gasCost']),
        gasUsed: _amountFromJsonNum(map['gasUsed']),
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
  final String input;
  final int nonce;
  final Amount gasCost;
  final Amount gasUsed;

  static Amount _amountFromJsonNum(dynamic json) {
    return Amount(
      rawValue: BigInt.from(json as num),
      fractionDigits: Coin.ethereum.decimals,
    );
  }

  EthTokenTxExtraDTO copyWith({
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
    int? nonce,
    String? input,
    Amount? gasCost,
    Amount? gasUsed,
  }) =>
      EthTokenTxExtraDTO(
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
        nonce: nonce ?? this.nonce,
        input: input ?? this.input,
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
    map['value'] = value;
    map['gas'] = gas;
    map['gasPrice'] = gasPrice;
    map['input'] = input;
    map['nonce'] = nonce;
    map['gasCost'] = gasCost;
    map['gasUsed'] = gasUsed;
    return map;
  }

  @override
  String toString() => jsonEncode(toMap());
}
