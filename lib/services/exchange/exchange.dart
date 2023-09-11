/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:decimal/decimal.dart';
import 'package:stackwallet/models/exchange/response_objects/estimate.dart';
import 'package:stackwallet/models/exchange/response_objects/range.dart';
import 'package:stackwallet/models/exchange/response_objects/trade.dart';
import 'package:stackwallet/models/isar/exchange_cache/currency.dart';
import 'package:stackwallet/models/isar/exchange_cache/pair.dart';
import 'package:stackwallet/services/exchange/change_now/change_now_exchange.dart';
import 'package:stackwallet/services/exchange/exchange_response.dart';
import 'package:stackwallet/services/exchange/majestic_bank/majestic_bank_exchange.dart';
import 'package:stackwallet/services/exchange/simpleswap/simpleswap_exchange.dart';
import 'package:stackwallet/services/exchange/trocador/trocador_exchange.dart';

abstract class Exchange {
  static Exchange get defaultExchange => ChangeNowExchange.instance;

  static Exchange fromName(String name) {
    switch (name) {
      case ChangeNowExchange.exchangeName:
        return ChangeNowExchange.instance;
      case SimpleSwapExchange.exchangeName:
        return SimpleSwapExchange.instance;
      case MajesticBankExchange.exchangeName:
        return MajesticBankExchange.instance;
      case TrocadorExchange.exchangeName:
        return TrocadorExchange.instance;
      default:
        final split = name.split(" ");
        if (split.length >= 2) {
          // silly way to check for 'Trocador ($providerName)'
          return fromName(split.first);
        }
        throw ArgumentError("Unknown exchange name");
    }
  }

  String get name;

  Future<ExchangeResponse<List<Currency>>> getAllCurrencies(bool fixedRate);

  Future<ExchangeResponse<List<Currency>>> getPairedCurrencies(
    String forCurrency,
    bool fixedRate,
  );

  Future<ExchangeResponse<List<Pair>>> getPairsFor(
    String currency,
    bool fixedRate,
  );

  Future<ExchangeResponse<List<Pair>>> getAllPairs(bool fixedRate);

  Future<ExchangeResponse<Trade>> getTrade(String tradeId);
  Future<ExchangeResponse<Trade>> updateTrade(Trade trade);

  Future<ExchangeResponse<List<Trade>>> getTrades();

  Future<ExchangeResponse<Range>> getRange(
    String from,
    String to,
    bool fixedRate,
  );

  Future<ExchangeResponse<List<Estimate>>> getEstimates(
    String from,
    String to,
    Decimal amount,
    bool fixedRate,
    bool reversed,
  );

  Future<ExchangeResponse<Trade>> createTrade({
    required String from,
    required String to,
    required bool fixedRate,
    required Decimal amount,
    required String addressTo,
    String? extraId,
    required String addressRefund,
    required String refundExtraId,
    Estimate? estimate,
    required bool reversed,
  });

  /// List of exchanges which support Tor.
  ///
  /// Add to this list when adding a new exchange which supports Tor.
  static List<Exchange> get exchangesWithTorSupport => [
        MajesticBankExchange.instance,
        TrocadorExchange.instance,
      ];

  /// List of exchange names which support Tor.
  ///
  /// Convenience method for when you just want to check for a String
  /// .exchangeName instead of Exchange instances. Shouldn't need to be updated
  /// as long as the above List is updated.
  static List<String> get exchangeNamesWithTorSupport =>
      exchangesWithTorSupport.map((exchange) => exchange.name).toList();
  // Instead of using this, you can do like:
  // currencies
  //     .removeWhere((element) => !Exchange.exchangesWithTorSupport.any(
  //             (e) => e.name == element.exchangeName,
  //         ));
}
