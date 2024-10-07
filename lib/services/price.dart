/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

import '../app_config.dart';
import '../db/hive/db.dart';
import '../networking/http.dart';
import '../utilities/logger.dart';
import '../utilities/prefs.dart';
import '../wallets/crypto_currency/crypto_currency.dart';
import 'tor_service.dart';

class PriceAPI {
  // coingecko coin ids
  static const Map<Type, String> _coinToIdMap = {
    Bitcoin: "bitcoin",
    BitcoinFrost: "bitcoin",
    Litecoin: "litecoin",
    Bitcoincash: "bitcoin-cash",
    Dash: "dash",
    Dogecoin: "dogecoin",
    Epiccash: "epic-cash",
    Ecash: "ecash",
    Ethereum: "ethereum",
    Firo: "zcoin",
    Monero: "monero",
    Particl: "particl",
    Peercoin: "peercoin",
    Solana: "solana",
    Stellar: "stellar",
    Tezos: "tezos",
    Wownero: "wownero",
    Namecoin: "namecoin",
    Nano: "nano",
    Banano: "banano",
    Fact0rn: "fact0rn",
  };

  static const refreshInterval = 60;

  // initialize to older than current time minus at least refreshInterval
  static DateTime _lastCalled =
      DateTime.now().subtract(const Duration(seconds: refreshInterval + 10));

  static String _lastUsedBaseCurrency = "";

  static const Duration refreshIntervalDuration =
      Duration(seconds: refreshInterval);

  final HTTP client;

  PriceAPI(this.client);

  @visibleForTesting
  void resetLastCalledToForceNextCallToUpdateCache() {
    _lastCalled = DateTime(1970);
  }

  Future<void> _updateCachedPrices(
    Map<CryptoCurrency, Tuple2<Decimal, double>> data,
  ) async {
    final Map<String, dynamic> map = {};

    for (final coin in AppConfig.coins) {
      final entry = data[coin];
      if (entry == null) {
        map[coin.prettyName] = ["0", 0.0];
      } else {
        map[coin.prettyName] = [entry.item1.toString(), entry.item2];
      }
    }

    await DB.instance
        .put<dynamic>(boxName: DB.boxNamePriceCache, key: 'cache', value: map);
  }

  Map<CryptoCurrency, Tuple2<Decimal, double>> get _cachedPrices {
    final map =
        DB.instance.get<dynamic>(boxName: DB.boxNamePriceCache, key: 'cache')
                as Map? ??
            {};
    // init with 0
    final result = {
      for (final coin in AppConfig.coins) coin: Tuple2(Decimal.zero, 0.0),
    };

    for (final entry in map.entries) {
      result[AppConfig.getCryptoCurrencyByPrettyName(
        entry.key as String,
      )] = Tuple2(
        Decimal.parse(entry.value[0] as String),
        entry.value[1] as double,
      );
    }

    return result;
  }

  String get _coinIds => AppConfig.coins
      .where((e) => e.network == CryptoCurrencyNetwork.main)
      .map((e) => _coinToIdMap[e.runtimeType])
      .where((e) => e != null)
      .join(",");

  Future<Map<CryptoCurrency, Tuple2<Decimal, double>>> getPricesAnd24hChange({
    required String baseCurrency,
  }) async {
    final now = DateTime.now();
    if (_lastUsedBaseCurrency != baseCurrency ||
        now.difference(_lastCalled) > refreshIntervalDuration) {
      _lastCalled = now;
      _lastUsedBaseCurrency = baseCurrency;
    } else {
      return _cachedPrices;
    }

    final externalCalls = Prefs.instance.externalCalls;
    if ((!Logger.isTestEnv && !externalCalls) ||
        !(await Prefs.instance.isExternalCallsSet())) {
      Logging.instance.log(
        "User does not want to use external calls",
        level: LogLevel.Info,
      );
      return _cachedPrices;
    }
    final Map<CryptoCurrency, Tuple2<Decimal, double>> result = {};
    try {
      final uri = Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency"
        "=${baseCurrency.toLowerCase()}&ids=$_coinIds&order=market_cap_desc"
        "&per_page=50&page=1&sparkline=false",
      );

      final coinGeckoResponse = await client.get(
        url: uri,
        headers: {'Content-Type': 'application/json'},
        proxyInfo: Prefs.instance.useTor
            ? TorService.sharedInstance.getProxyInfo()
            : null,
      );

      final coinGeckoData = jsonDecode(coinGeckoResponse.body) as List<dynamic>;

      for (final map in coinGeckoData) {
        final String coinName = map["name"] as String;
        final coin = AppConfig.getCryptoCurrencyByPrettyName(coinName);

        final price = Decimal.parse(map["current_price"].toString());
        final change24h = map["price_change_percentage_24h"] != null
            ? double.parse(map["price_change_percentage_24h"].toString())
            : 0.0;

        result[coin] = Tuple2(price, change24h);
      }

      // update cache
      await _updateCachedPrices(result);

      return _cachedPrices;
    } catch (e, s) {
      Logging.instance.log(
        "getPricesAnd24hChange($baseCurrency): $e\n$s",
        level: LogLevel.Error,
      );
      // return previous cached values
      return _cachedPrices;
    }
  }

  static Future<List<String>?> availableBaseCurrencies() async {
    final externalCalls = Prefs.instance.externalCalls;
    final HTTP client = HTTP();

    if ((!Logger.isTestEnv && !externalCalls) ||
        !(await Prefs.instance.isExternalCallsSet())) {
      Logging.instance.log(
        "User does not want to use external calls",
        level: LogLevel.Info,
      );
      return null;
    }
    const uriString =
        "https://api.coingecko.com/api/v3/simple/supported_vs_currencies";
    try {
      final uri = Uri.parse(uriString);
      final response = await client.get(
        url: uri,
        headers: {'Content-Type': 'application/json'},
        proxyInfo: Prefs.instance.useTor
            ? TorService.sharedInstance.getProxyInfo()
            : null,
      );

      final json = jsonDecode(response.body) as List<dynamic>;
      return List<String>.from(json);
    } catch (e, s) {
      Logging.instance.log(
        "availableBaseCurrencies() using $uriString: $e\n$s",
        level: LogLevel.Error,
      );
      return null;
    }
  }

  Future<Map<String, Tuple2<Decimal, double>>>
      getPricesAnd24hChangeForEthTokens({
    required Set<String> contractAddresses,
    required String baseCurrency,
  }) async {
    final Map<String, Tuple2<Decimal, double>> tokenPrices = {};

    if (AppConfig.coins.whereType<Ethereum>().isEmpty ||
        contractAddresses.isEmpty) return tokenPrices;

    final externalCalls = Prefs.instance.externalCalls;
    if ((!Logger.isTestEnv && !externalCalls) ||
        !(await Prefs.instance.isExternalCallsSet())) {
      Logging.instance.log(
        "User does not want to use external calls",
        level: LogLevel.Info,
      );
      return tokenPrices;
    }

    try {
      //   for (final contractAddress in contractAddresses) {
      //     final uri = Uri.parse(
      //         "https://api.coingecko.com/api/v3/simple/token_price/ethereum"
      //         "?vs_currencies=${baseCurrency.toLowerCase()}&contract_addresses"
      //         "=$contractAddress&include_24hr_change=true");
      //
      //     final coinGeckoResponse = await client.get(
      //       url: uri,
      //       headers: {'Content-Type': 'application/json'},
      //       proxyInfo: Prefs.instance.useTor
      //           ? TorService.sharedInstance.getProxyInfo()
      //           : null,
      //     );
      //
      //     try {
      //       final coinGeckoData = jsonDecode(coinGeckoResponse.body) as Map;
      //
      //       final map = coinGeckoData[contractAddress] as Map;
      //
      //       final price =
      //           Decimal.parse(map[baseCurrency.toLowerCase()].toString());
      //       final change24h = double.parse(
      //           map["${baseCurrency.toLowerCase()}_24h_change"].toString());
      //
      //       tokenPrices[contractAddress] = Tuple2(price, change24h);
      //     } catch (e, s) {
      //       // only log the error as we don't want to interrupt the rest of the loop
      //       Logging.instance.log(
      //         "getPricesAnd24hChangeForEthTokens($baseCurrency,$contractAddress): $e\n$s\nRESPONSE: ${coinGeckoResponse.body}",
      //         level: LogLevel.Warning,
      //       );
      //     }
      //   }

      return tokenPrices;
    } catch (e, s) {
      Logging.instance.log(
        "getPricesAnd24hChangeForEthTokens($baseCurrency,$contractAddresses): $e\n$s",
        level: LogLevel.Error,
      );
      // return previous cached values
      return tokenPrices;
    }
  }
}
