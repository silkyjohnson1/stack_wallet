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

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../db/isar/main_db.dart';
import '../models/isar/models/isar_models.dart';
import '../networking/http.dart';
import 'price.dart';
import '../app_config.dart';
import '../wallets/crypto_currency/crypto_currency.dart';
import 'package:tuple/tuple.dart';

class PriceService extends ChangeNotifier {
  late final String baseTicker;
  Future<Set<String>> get tokenContractAddressesToCheck async =>
      (await MainDB.instance.getEthContracts().addressProperty().findAll())
          .toSet();
  final Duration updateInterval = const Duration(seconds: 60);

  Timer? _timer;
  final Map<CryptoCurrency, Tuple2<Decimal, double>> _cachedPrices = {
    for (final coin in AppConfig.coins) coin: Tuple2(Decimal.zero, 0.0),
  };

  final Map<String, Tuple2<Decimal, double>> _cachedTokenPrices = {};

  final _priceAPI = PriceAPI(HTTP());

  Tuple2<Decimal, double> getPrice(CryptoCurrency coin) => _cachedPrices[coin]!;

  Tuple2<Decimal, double> getTokenPrice(String contractAddress) =>
      _cachedTokenPrices[contractAddress.toLowerCase()] ??
      Tuple2(Decimal.zero, 0);

  PriceService(this.baseTicker);

  Future<void> updatePrice() async {
    final priceMap =
        await _priceAPI.getPricesAnd24hChange(baseCurrency: baseTicker);

    bool shouldNotify = false;
    for (final map in priceMap.entries) {
      if (_cachedPrices[map.key] != map.value) {
        _cachedPrices[map.key] = map.value;
        shouldNotify = true;
      }
    }

    final _tokenContractAddressesToCheck = await tokenContractAddressesToCheck;

    if (_tokenContractAddressesToCheck.isNotEmpty) {
      final tokenPriceMap = await _priceAPI.getPricesAnd24hChangeForEthTokens(
        contractAddresses: _tokenContractAddressesToCheck,
        baseCurrency: baseTicker,
      );

      for (final map in tokenPriceMap.entries) {
        if (_cachedTokenPrices[map.key] != map.value) {
          _cachedTokenPrices[map.key] = map.value;
          shouldNotify = true;
        }
      }
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void start(bool rightAway) {
    if (rightAway) {
      updatePrice();
    }
    _timer?.cancel();
    _timer = Timer.periodic(updateInterval, (_) {
      updatePrice();
    });
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }
}
