import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:stackwallet/exceptions/exchange/exchange_exception.dart';
import 'package:stackwallet/models/exchange/response_objects/estimate.dart';
import 'package:stackwallet/models/exchange/response_objects/range.dart';
import 'package:stackwallet/models/exchange/response_objects/trade.dart';
import 'package:stackwallet/models/isar/exchange_cache/currency.dart';
import 'package:stackwallet/models/isar/exchange_cache/pair.dart';
import 'package:stackwallet/services/exchange/exchange.dart';
import 'package:stackwallet/services/exchange/exchange_response.dart';
import 'package:stackwallet/services/exchange/trocador/response_objects/trocador_coin.dart';
import 'package:stackwallet/services/exchange/trocador/response_objects/trocador_quote.dart';
import 'package:stackwallet/services/exchange/trocador/trocador_api.dart';
import 'package:uuid/uuid.dart';

class TrocadorExchange extends Exchange {
  TrocadorExchange._();

  static TrocadorExchange? _instance;
  static TrocadorExchange get instance => _instance ??= TrocadorExchange._();

  static const exchangeName = "Trocador";

  static const onlySupportedNetwork = "Mainnet";

  @override
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
  }) async {
    final response = reversed
        ? await TrocadorAPI.createNewPaymentRateTrade(
            isOnion: false,
            rateId: estimate?.rateId,
            fromTicker: from.toLowerCase(),
            fromNetwork: onlySupportedNetwork,
            toTicker: to.toLowerCase(),
            toNetwork: onlySupportedNetwork,
            toAmount: amount.toString(),
            receivingAddress: addressTo,
            receivingMemo: null,
            refundAddress: addressRefund,
            refundMemo: null,
            exchangeProvider: estimate!.exchangeProvider!,
            isFixedRate: fixedRate,
          )
        : await TrocadorAPI.createNewStandardRateTrade(
            isOnion: false,
            rateId: estimate?.rateId,
            fromTicker: from.toLowerCase(),
            fromNetwork: onlySupportedNetwork,
            toTicker: to.toLowerCase(),
            toNetwork: onlySupportedNetwork,
            fromAmount: amount.toString(),
            receivingAddress: addressTo,
            receivingMemo: null,
            refundAddress: addressRefund,
            refundMemo: null,
            exchangeProvider: estimate!.exchangeProvider!,
            isFixedRate: fixedRate,
          );

    if (response.value == null) {
      return ExchangeResponse(exception: response.exception);
    }

    final trade = response.value!;

    return ExchangeResponse(
      value: Trade(
        uuid: const Uuid().v1(),
        tradeId: trade.tradeId,
        rateType: fixedRate ? "fixed" : "floating",
        direction: reversed ? "reversed" : "direct",
        timestamp: trade.date,
        updatedAt: trade.date,
        payInCurrency: trade.coinFrom,
        payInAmount: trade.amountFrom.toString(),
        payInAddress: trade.addressProvider,
        payInNetwork: trade.networkFrom,
        payInExtraId: trade.addressProviderMemo,
        payInTxid: "",
        payOutCurrency: trade.coinTo,
        payOutAmount: trade.amountTo.toString(),
        payOutAddress: trade.addressUser,
        payOutNetwork: trade.networkTo,
        payOutExtraId: trade.addressUserMemo,
        payOutTxid: "",
        refundAddress: trade.refundAddress,
        refundExtraId: trade.refundAddressMemo,
        status: trade.status,
        exchangeName: "$exchangeName (${trade.provider})",
      ),
    );
  }

  List<TrocadorCoin>? _cachedCurrencies;

  @override
  Future<ExchangeResponse<List<Currency>>> getAllCurrencies(
      bool fixedRate) async {
    _cachedCurrencies ??= (await TrocadorAPI.getCoins(isOnion: false)).value;

    _cachedCurrencies?.removeWhere((e) => e.network != onlySupportedNetwork);

    final value = _cachedCurrencies
        ?.map(
          (e) => Currency(
            exchangeName: exchangeName,
            ticker: e.ticker,
            name: e.name,
            network: e.network,
            image: e.image,
            isFiat: false,
            rateType: SupportedRateType.both,
            isStackCoin: Currency.checkIsStackCoin(e.ticker),
            tokenContract: null,
            isAvailable: true,
          ),
        )
        .toList();

    if (value == null) {
      return ExchangeResponse(
        exception: ExchangeException(
          "Failed to fetch trocador coins",
          ExchangeExceptionType.generic,
        ),
      );
    } else {
      return ExchangeResponse(value: value);
    }
  }

  @override
  Future<ExchangeResponse<List<Pair>>> getAllPairs(bool fixedRate) async {
    final response = await getAllCurrencies(fixedRate);

    if (response.value == null) {
      return ExchangeResponse(exception: response.exception);
    }

    final List<Pair> pairs = [];

    for (int i = 0; i < response.value!.length; i++) {
      final a = response.value![i];

      for (int j = i + 1; j < response.value!.length; j++) {
        final b = response.value![j];

        pairs.add(
          Pair(
            exchangeName: exchangeName,
            from: a.ticker,
            to: b.ticker,
            rateType: SupportedRateType.both,
          ),
        );
        pairs.add(
          Pair(
            exchangeName: exchangeName,
            to: a.ticker,
            from: b.ticker,
            rateType: SupportedRateType.both,
          ),
        );
      }
    }

    return ExchangeResponse(value: pairs);
  }

  @override
  Future<ExchangeResponse<List<Estimate>>> getEstimates(
    String from,
    String to,
    Decimal amount,
    bool fixedRate,
    bool reversed,
  ) async {
    final response = reversed
        ? await TrocadorAPI.getNewPaymentRate(
            isOnion: false,
            fromTicker: from,
            fromNetwork: onlySupportedNetwork,
            toTicker: to,
            toNetwork: onlySupportedNetwork,
            toAmount: amount.toString(),
          )
        : await TrocadorAPI.getNewStandardRate(
            isOnion: false,
            fromTicker: from,
            fromNetwork: onlySupportedNetwork,
            toTicker: to,
            toNetwork: onlySupportedNetwork,
            fromAmount: amount.toString(),
          );

    if (response.value == null) {
      return ExchangeResponse(exception: response.exception);
    }

    final List<Estimate> estimates = [];
    final List<TrocadorQuote> cOrLowerQuotes = [];

    for (final quote in response.value!.quotes) {
      if (quote.fixed == fixedRate &&
          quote.provider.toLowerCase() != "changenow") {
        final rating = quote.kycRating.toLowerCase();
        if (rating == "a" || rating == "b") {
          estimates.add(
            Estimate(
              estimatedAmount: reversed ? quote.amountFrom! : quote.amountTo!,
              fixedRate: quote.fixed,
              reversed: reversed,
              exchangeProvider: quote.provider,
              rateId: response.value!.tradeId,
              kycRating: quote.kycRating,
            ),
          );
        } else {
          cOrLowerQuotes.add(quote);
        }
      }
    }

    cOrLowerQuotes.sort((a, b) => b.waste.compareTo(a.waste));

    for (int i = 0; i < min(3, cOrLowerQuotes.length); i++) {
      final quote = cOrLowerQuotes[i];
      estimates.add(
        Estimate(
          estimatedAmount: reversed ? quote.amountFrom! : quote.amountTo!,
          fixedRate: quote.fixed,
          reversed: reversed,
          exchangeProvider: quote.provider,
          rateId: response.value!.tradeId,
          kycRating: quote.kycRating,
        ),
      );
    }

    return ExchangeResponse(
      value: estimates
        ..sort((a, b) => b.estimatedAmount.compareTo(a.estimatedAmount)),
    );
  }

  @override
  Future<ExchangeResponse<List<Currency>>> getPairedCurrencies(
      String forCurrency, bool fixedRate) async {
    // TODO: implement getPairedCurrencies
    throw UnimplementedError();
  }

  @override
  Future<ExchangeResponse<List<Pair>>> getPairsFor(
    String currency,
    bool fixedRate,
  ) async {
    final response = await getAllPairs(fixedRate);
    if (response.value == null) {
      return ExchangeResponse(exception: response.exception);
    }

    final pairs = response.value!.where(
      (e) =>
          e.from.toUpperCase() == currency.toUpperCase() ||
          e.to.toUpperCase() == currency.toUpperCase(),
    );

    return ExchangeResponse(value: pairs.toList());
  }

  @override
  Future<ExchangeResponse<Range>> getRange(
    String from,
    String to,
    bool fixedRate,
  ) async {
    if (_cachedCurrencies == null) {
      await getAllCurrencies(fixedRate);
    }
    if (_cachedCurrencies == null) {
      return ExchangeResponse(
        exception: ExchangeException(
          "Failed to updated trocador cached coins to get min/max range",
          ExchangeExceptionType.generic,
        ),
      );
    }

    final fromCoin = _cachedCurrencies!
        .firstWhere((e) => e.ticker.toLowerCase() == from.toLowerCase());

    return ExchangeResponse(
      value: Range(
        max: fromCoin.maximum,
        min: fromCoin.minimum,
      ),
    );
  }

  @override
  Future<ExchangeResponse<Trade>> getTrade(String tradeId) async {
    // TODO: implement getTrade
    throw UnimplementedError();
  }

  @override
  Future<ExchangeResponse<List<Trade>>> getTrades() async {
    // TODO: implement getTrades
    throw UnimplementedError();
  }

  @override
  String get name => exchangeName;

  @override
  Future<ExchangeResponse<Trade>> updateTrade(Trade trade) async {
    final response = await TrocadorAPI.getTrade(
      isOnion: false,
      tradeId: trade.tradeId,
    );

    if (response.value != null) {
      final updated = response.value!;
      final updatedTrade = Trade(
        uuid: trade.uuid,
        tradeId: updated.tradeId,
        rateType: trade.rateType,
        direction: trade.direction,
        timestamp: trade.timestamp,
        updatedAt: DateTime.now(),
        payInCurrency: updated.coinFrom,
        payInAmount: updated.amountFrom.toString(),
        payInAddress: updated.addressProvider,
        payInNetwork: trade.payInNetwork,
        payInExtraId: trade.payInExtraId,
        payInTxid: trade.payInTxid,
        payOutCurrency: updated.coinTo,
        payOutAmount: updated.amountTo.toString(),
        payOutAddress: updated.addressUser,
        payOutNetwork: trade.payOutNetwork,
        payOutExtraId: trade.payOutExtraId,
        payOutTxid: trade.payOutTxid,
        refundAddress: trade.refundAddress,
        refundExtraId: trade.refundExtraId,
        status: updated.status,
        exchangeName: "$exchangeName (${updated.provider})",
      );

      return ExchangeResponse(value: updatedTrade);
    } else {
      if (response.exception?.type == ExchangeExceptionType.orderNotFound) {
        final updatedTrade = Trade(
          uuid: trade.uuid,
          tradeId: trade.tradeId,
          rateType: trade.rateType,
          direction: trade.direction,
          timestamp: trade.timestamp,
          updatedAt: DateTime.now(),
          payInCurrency: trade.payInCurrency,
          payInAmount: trade.payInAmount,
          payInAddress: trade.payInAddress,
          payInNetwork: trade.payInNetwork,
          payInExtraId: trade.payInExtraId,
          payInTxid: trade.payInTxid,
          payOutCurrency: trade.payOutCurrency,
          payOutAmount: trade.payOutAmount,
          payOutAddress: trade.payOutAddress,
          payOutNetwork: trade.payOutNetwork,
          payOutExtraId: trade.payOutExtraId,
          payOutTxid: trade.payOutTxid,
          refundAddress: trade.refundAddress,
          refundExtraId: trade.refundExtraId,
          status: "Unknown",
          exchangeName: trade.exchangeName,
        );
        return ExchangeResponse(value: updatedTrade);
      }
      return ExchangeResponse(exception: response.exception);
    }
  }
}
