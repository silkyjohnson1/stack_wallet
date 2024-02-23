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

import 'package:bitcoindart/bitcoindart.dart';
import 'package:crypto/crypto.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/bitcoin.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';

import 'package:stackwallet/wallets/crypto_currency/coins/banano.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/bitcoincash.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/dogecoin.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/ecash.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/epiccash.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/ethereum.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/firo.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/litecoin.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/monero.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/namecoin.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/nano.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/particl.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/stellar.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/tezos.dart';
import 'package:stackwallet/wallets/crypto_currency/coins/wownero.dart';

class AddressUtils {
  static String condenseAddress(String address) {
    return '${address.substring(0, 5)}...${address.substring(address.length - 5)}';
  }

  /// attempts to convert a string to a valid scripthash
  ///
  /// Returns the scripthash or throws an exception on invalid firo address
  static String convertToScriptHash(
    String address,
    NetworkType network, [
    String overridePrefix = "",
  ]) {
    try {
      final output =
          Address.addressToOutputScript(address, network, overridePrefix);
      final hash = sha256.convert(output.toList(growable: false)).toString();

      final chars = hash.split("");
      final reversedPairs = <String>[];
      // TODO find a better/faster way to do this?
      var i = chars.length - 1;
      while (i > 0) {
        reversedPairs.add(chars[i - 1]);
        reversedPairs.add(chars[i]);
        i -= 2;
      }
      return reversedPairs.join("");
    } catch (e) {
      rethrow;
    }
  }

  static bool validateAddress(String address, Coin coin) {
    //This calls the validate address for each crypto coin, validateAddress is
    //only used in 2 places, so I just replaced the old functionality here
    switch (coin) {
      case Coin.bitcoin:
        return Bitcoin(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.litecoin:
        return Litecoin(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.bitcoincash:
        return Bitcoincash(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.dogecoin:
        return Dogecoin(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.epicCash:
        return Epiccash(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.ethereum:
        return Ethereum(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.firo:
        return Firo(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.eCash:
        return Ecash(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.monero:
        return Monero(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.wownero:
        return Wownero(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.namecoin:
        return Namecoin(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.particl:
        return Particl(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.stellar:
        return Stellar(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.nano:
        return Nano(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.banano:
        return Banano(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.tezos:
        return Tezos(CryptoCurrencyNetwork.main).validateAddress(address);
      case Coin.bitcoinTestNet:
        return Bitcoin(CryptoCurrencyNetwork.test).validateAddress(address);
      case Coin.litecoinTestNet:
        return Litecoin(CryptoCurrencyNetwork.test).validateAddress(address);
      case Coin.bitcoincashTestnet:
        return Bitcoincash(CryptoCurrencyNetwork.test).validateAddress(address);
      case Coin.firoTestNet:
        return Firo(CryptoCurrencyNetwork.test).validateAddress(address);
      case Coin.dogecoinTestNet:
        return Dogecoin(CryptoCurrencyNetwork.test).validateAddress(address);
      case Coin.stellarTestnet:
        return Stellar(CryptoCurrencyNetwork.test).validateAddress(address);
    }
    // throw Exception("moved");
    // switch (coin) {
    //   case Coin.bitcoin:
    //     return Address.validateAddress(address, bitcoin);
    //   case Coin.litecoin:
    //     return Address.validateAddress(address, litecoin);
    //   case Coin.bitcoincash:
    //     try {
    //       // 0 for bitcoincash: address scheme, 1 for legacy address
    //       final format = bitbox.Address.detectFormat(address);
    //
    //       if (coin == Coin.bitcoincashTestnet) {
    //         return true;
    //       }
    //
    //       if (format == bitbox.Address.formatCashAddr) {
    //         String addr = address;
    //         if (addr.contains(":")) {
    //           addr = addr.split(":").last;
    //         }
    //
    //         return addr.startsWith("q");
    //       } else {
    //         return address.startsWith("1");
    //       }
    //     } catch (e) {
    //       return false;
    //     }
    //   case Coin.dogecoin:
    //     return Address.validateAddress(address, dogecoin);
    //   case Coin.epicCash:
    //     return validateSendAddress(address) == "1";
    //   case Coin.ethereum:
    //     return true; //TODO - validate ETH address
    //   case Coin.firo:
    //     return Address.validateAddress(address, firoNetwork);
    //   case Coin.eCash:
    //     return Address.validateAddress(address, eCashNetwork);
    //   case Coin.monero:
    //     return RegExp("[a-zA-Z0-9]{95}").hasMatch(address) ||
    //         RegExp("[a-zA-Z0-9]{106}").hasMatch(address);
    //   case Coin.wownero:
    //     return RegExp("[a-zA-Z0-9]{95}").hasMatch(address) ||
    //         RegExp("[a-zA-Z0-9]{106}").hasMatch(address);
    //   case Coin.namecoin:
    //     return Address.validateAddress(address, namecoin, namecoin.bech32!);
    //   case Coin.particl:
    //     return Address.validateAddress(address, particl);
    //   case Coin.stellar:
    //     return RegExp(r"^[G][A-Z0-9]{55}$").hasMatch(address);
    //   case Coin.nano:
    //     return NanoAccounts.isValid(NanoAccountType.NANO, address);
    //   case Coin.banano:
    //     return NanoAccounts.isValid(NanoAccountType.BANANO, address);
    //   case Coin.tezos:
    //     return RegExp(r"^tz[1-9A-HJ-NP-Za-km-z]{34}$").hasMatch(address);
    //   case Coin.bitcoinTestNet:
    //     return Address.validateAddress(address, testnet);
    //   case Coin.litecoinTestNet:
    //     return Address.validateAddress(address, litecointestnet);
    //   case Coin.bitcoincashTestnet:
    //     try {
    //       // 0 for bitcoincash: address scheme, 1 for legacy address
    //       final format = bitbox.Address.detectFormat(address);
    //
    //       if (coin == Coin.bitcoincashTestnet) {
    //         return true;
    //       }
    //
    //       if (format == bitbox.Address.formatCashAddr) {
    //         String addr = address;
    //         if (addr.contains(":")) {
    //           addr = addr.split(":").last;
    //         }
    //
    //         return addr.startsWith("q");
    //       } else {
    //         return address.startsWith("1");
    //       }
    //     } catch (e) {
    //       return false;
    //     }
    //   case Coin.firoTestNet:
    //     return Address.validateAddress(address, firoTestNetwork);
    //   case Coin.dogecoinTestNet:
    //     return Address.validateAddress(address, dogecointestnet);
    //   case Coin.stellarTestnet:
    //     return RegExp(r"^[G][A-Z0-9]{55}$").hasMatch(address);
    // }
  }

  /// parse an address uri
  /// returns an empty map if the input string does not begin with "firo:"
  static Map<String, String> parseUri(String uri) {
    Map<String, String> result = {};
    try {
      final u = Uri.parse(uri);
      if (u.hasScheme) {
        result["scheme"] = u.scheme.toLowerCase();
        result["address"] = u.path;
        result.addAll(u.queryParameters);
      }
    } catch (e) {
      Logging.instance
          .log("Exception caught in parseUri($uri): $e", level: LogLevel.Error);
    }
    return result;
  }

  /// builds a uri string with the given address and query parameters if any
  static String buildUriString(
    Coin coin,
    String address,
    Map<String, String> params,
  ) {
    // TODO: other sanitation as well ?
    String sanitizedAddress = address;
    if (coin == Coin.bitcoincash ||
        coin == Coin.bitcoincashTestnet ||
        coin == Coin.eCash) {
      final prefix = "${coin.uriScheme}:";
      if (address.startsWith(prefix)) {
        sanitizedAddress = address.replaceFirst(prefix, "");
      }
    }
    String uriString = "${coin.uriScheme}:$sanitizedAddress";
    if (params.isNotEmpty) {
      uriString += Uri(queryParameters: params).toString();
    }
    return uriString;
  }

  /// returns empty if bad data
  static Map<String, dynamic> decodeQRSeedData(String data) {
    Map<String, dynamic> result = {};
    try {
      result = Map<String, dynamic>.from(jsonDecode(data) as Map);
    } catch (e) {
      Logging.instance.log("Exception caught in parseQRSeedData($data): $e",
          level: LogLevel.Error);
    }
    return result;
  }

  /// encode mnemonic words to qrcode formatted string
  static String encodeQRSeedData(List<String> words) {
    return jsonEncode({"mnemonic": words});
  }
}
