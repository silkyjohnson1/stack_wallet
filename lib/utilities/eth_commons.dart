/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:decimal/decimal.dart';
import "package:hex/hex.dart";
import 'package:stackwallet/wallets/crypto_currency/coins/ethereum.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';

class GasTracker {
  final Decimal average;
  final Decimal fast;
  final Decimal slow;

  final int numberOfBlocksFast;
  final int numberOfBlocksAverage;
  final int numberOfBlocksSlow;

  final String lastBlock;

  const GasTracker({
    required this.average,
    required this.fast,
    required this.slow,
    required this.numberOfBlocksFast,
    required this.numberOfBlocksAverage,
    required this.numberOfBlocksSlow,
    required this.lastBlock,
  });

  factory GasTracker.fromJson(Map<String, dynamic> json) {
    final targetTime =
        Ethereum(CryptoCurrencyNetwork.main).targetBlockTimeSeconds;
    return GasTracker(
      fast: Decimal.parse(json["FastGasPrice"].toString()),
      average: Decimal.parse(json["ProposeGasPrice"].toString()),
      slow: Decimal.parse(json["SafeGasPrice"].toString()),
      // TODO fix hardcoded
      numberOfBlocksFast: 30 ~/ targetTime,
      numberOfBlocksAverage: 180 ~/ targetTime,
      numberOfBlocksSlow: 240 ~/ targetTime,
      lastBlock: json["LastBlock"] as String,
    );
  }
}

const hdPathEthereum = "m/44'/60'/0'/0";

// equal to "0x${keccak256("Transfer(address,address,uint256)".toUint8ListFromUtf8).toHex}";
const kTransferEventSignature =
    "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef";

String getPrivateKey(String mnemonic, String mnemonicPassphrase) {
  final isValidMnemonic = bip39.validateMnemonic(mnemonic);
  if (!isValidMnemonic) {
    throw 'Invalid mnemonic';
  }

  final seed = bip39.mnemonicToSeed(mnemonic, passphrase: mnemonicPassphrase);
  final root = bip32.BIP32.fromSeed(seed);
  const index = 0;
  final addressAtIndex = root.derivePath("$hdPathEthereum/$index");

  return HEX.encode(addressAtIndex.privateKey as List<int>);
}
