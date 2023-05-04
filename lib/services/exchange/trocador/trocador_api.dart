import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:http/http.dart' as http;
import 'package:stackwallet/exceptions/exchange/exchange_exception.dart';
import 'package:stackwallet/services/exchange/exchange_response.dart';
import 'package:stackwallet/services/exchange/trocador/response_objects/trocador_coin.dart';
import 'package:stackwallet/services/exchange/trocador/response_objects/trocador_rate.dart';
import 'package:stackwallet/services/exchange/trocador/response_objects/trocador_trade.dart';
import 'package:stackwallet/services/exchange/trocador/response_objects/trocador_trade_new.dart';
import 'package:stackwallet/utilities/logger.dart';

const kTrocadorApiKey = "8rFqf7QLxX1mUBiNPEMaLUpV2biz6n";
const kTrocadorRefCode = "9eHm9BkQfS";

abstract class TrocadorAPI {
  static const String authority = "trocador.app";
  static const String onionAuthority =
      "trocadorfyhlu27aefre5u7zri66gudtzdyelymftvr4yjwcxhfaqsid.onion";

  static const String markup = "1";
  static const String minKYCRating = "C";

  static Uri _buildUri({
    required String method,
    required bool isOnion,
    Map<String, String>? params,
  }) {
    return isOnion
        ? Uri.http(onionAuthority, "api/$method", params)
        : Uri.https(authority, "api/$method", params);
  }

  static Future<dynamic> _makeGetRequest(Uri uri) async {
    int code = -1;
    try {
      debugPrint("URI: $uri");
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      code = response.statusCode;

      debugPrint("CODE: $code");
      debugPrint("BODY: ${response.body}");

      final json = jsonDecode(response.body);

      return json;
    } catch (e, s) {
      Logging.instance.log(
        "_makeRequest($uri) HTTP:$code threw: $e\n$s",
        level: LogLevel.Error,
      );
      rethrow;
    }
  }

  /// fetch all supported coins
  static Future<ExchangeResponse<List<TrocadorCoin>>> getCoins({
    required bool isOnion,
  }) async {
    final uri = _buildUri(
      isOnion: isOnion,
      method: "coins",
      params: {
        "api_key": kTrocadorApiKey,
        "ref": kTrocadorRefCode,
      },
    );

    try {
      final json = await _makeGetRequest(uri);

      if (json is List) {
        final list = List<Map<String, dynamic>>.from(json);
        final List<TrocadorCoin> coins = list
            .map(
              (e) => TrocadorCoin.fromMap(e),
            )
            .toList();

        return ExchangeResponse(value: coins);
      } else {
        throw Exception("unexpected json: $json");
      }
    } catch (e, s) {
      Logging.instance.log("getCoins exception: $e\n$s", level: LogLevel.Error);
      return ExchangeResponse(
        exception: ExchangeException(
          e.toString(),
          ExchangeExceptionType.generic,
        ),
      );
    }
  }

  /// get trade info
  static Future<ExchangeResponse<TrocadorTrade>> getTrade({
    required bool isOnion,
    required String tradeId,
  }) async {
    final uri = _buildUri(
      isOnion: isOnion,
      method: "trade",
      params: {
        "api_key": kTrocadorApiKey,
        "ref": kTrocadorRefCode,
        "id": tradeId,
      },
    );

    try {
      final json = await _makeGetRequest(uri);
      final map = Map<String, dynamic>.from((json as List).first as Map);

      return ExchangeResponse(value: TrocadorTrade.fromMap(map));
    } catch (e, s) {
      Logging.instance.log("getTrade exception: $e\n$s", level: LogLevel.Error);
      return ExchangeResponse(
        exception: ExchangeException(
          e.toString(),
          ExchangeExceptionType.generic,
        ),
      );
    }
  }

  /// get standard/floating rate
  static Future<ExchangeResponse<TrocadorRate>> getNewStandardRate({
    required bool isOnion,
    required String fromTicker,
    required String fromNetwork,
    required String toTicker,
    required String toNetwork,
    required String fromAmount,
  }) async {
    final params = {
      "api_key": kTrocadorApiKey,
      "ref": kTrocadorRefCode,
      "ticker_from": fromTicker.toLowerCase(),
      "network_from": fromNetwork,
      "ticker_to": toTicker.toLowerCase(),
      "network_to": toNetwork,
      "amount_from": fromAmount,
      "payment": "false",
      "min_kycrating": minKYCRating,
      "markup": markup,
    };

    return await _getNewRate(isOnion: isOnion, params: params);
  }

  /// get fixed rate/payment rate
  static Future<ExchangeResponse<TrocadorRate>> getNewPaymentRate({
    required bool isOnion,
    required String fromTicker,
    required String fromNetwork,
    required String toTicker,
    required String toNetwork,
    required String toAmount,
  }) async {
    final params = {
      "api_key": kTrocadorApiKey,
      "ref": kTrocadorRefCode,
      "ticker_from": fromTicker.toLowerCase(),
      "network_from": fromNetwork,
      "ticker_to": toTicker.toLowerCase(),
      "network_to": toNetwork,
      "amount_to": toAmount,
      "payment": "true",
      "min_kycrating": minKYCRating,
      "markup": markup,
    };

    return await _getNewRate(isOnion: isOnion, params: params);
  }

  static Future<ExchangeResponse<TrocadorRate>> _getNewRate({
    required bool isOnion,
    required Map<String, String> params,
  }) async {
    final uri = _buildUri(
      isOnion: isOnion,
      method: "new_rate",
      params: params,
    );

    try {
      final json = await _makeGetRequest(uri);
      final map = Map<String, dynamic>.from(json as Map);

      return ExchangeResponse(value: TrocadorRate.fromMap(map));
    } catch (e, s) {
      Logging.instance
          .log("getNewRate exception: $e\n$s", level: LogLevel.Error);
      return ExchangeResponse(
        exception: ExchangeException(
          e.toString(),
          ExchangeExceptionType.generic,
        ),
      );
    }
  }

  /// create new floating rate/standard trade
  static Future<ExchangeResponse<TrocadorTradeNew>> createNewStandardRateTrade({
    required bool isOnion,
    required String? rateId,
    required String fromTicker,
    required String fromNetwork,
    required String toTicker,
    required String toNetwork,
    required String fromAmount,
    required String receivingAddress,
    required String? receivingMemo,
    required String refundAddress,
    required String? refundMemo,
    required String exchangeProvider,
    required bool isFixedRate,
  }) async {
    final Map<String, String> params = {
      "api_key": kTrocadorApiKey,
      "ref": kTrocadorRefCode,
      "ticker_from": fromTicker.toLowerCase(),
      "network_from": fromNetwork,
      "ticker_to": toTicker.toLowerCase(),
      "network_to": toNetwork,
      "amount_from": fromAmount,
      "address": receivingAddress,
      "address_memo": receivingMemo ?? "0",
      "refund": refundAddress,
      "refund_memo": refundMemo ?? "0",
      "provider": exchangeProvider,
      "fixed": isFixedRate.toString().capitalize(),
      "payment": "False",
      "min_kycrating": minKYCRating,
      "markup": markup,
    };

    if (rateId != null) {
      params["id"] = rateId;
    }

    return await _getNewTrade(isOnion: isOnion, params: params);
  }

  static Future<ExchangeResponse<TrocadorTradeNew>> createNewPaymentRateTrade({
    required bool isOnion,
    required String? rateId,
    required String fromTicker,
    required String fromNetwork,
    required String toTicker,
    required String toNetwork,
    required String toAmount,
    required String receivingAddress,
    required String? receivingMemo,
    required String refundAddress,
    required String? refundMemo,
    required String exchangeProvider,
    required bool isFixedRate,
  }) async {
    final params = {
      "api_key": kTrocadorApiKey,
      "ref": kTrocadorRefCode,
      "ticker_from": fromTicker.toLowerCase(),
      "network_from": fromNetwork,
      "ticker_to": toTicker.toLowerCase(),
      "network_to": toNetwork,
      "amount_to": toAmount,
      "address": receivingAddress,
      "address_memo": receivingMemo ?? "0",
      "refund": refundAddress,
      "refund_memo": refundMemo ?? "0",
      "provider": exchangeProvider,
      "fixed": isFixedRate.toString().capitalize(),
      "payment": "True",
      "min_kycrating": minKYCRating,
      "markup": markup,
    };

    if (rateId != null) {
      params["id"] = rateId;
    }

    return await _getNewTrade(isOnion: isOnion, params: params);
  }

  static Future<ExchangeResponse<TrocadorTradeNew>> _getNewTrade({
    required bool isOnion,
    required Map<String, String> params,
  }) async {
    final uri = _buildUri(
      isOnion: isOnion,
      method: "new_trade",
      params: params,
    );

    try {
      final json = await _makeGetRequest(uri);
      final map = Map<String, dynamic>.from(json as Map);

      return ExchangeResponse(value: TrocadorTradeNew.fromMap(map));
    } catch (e, s) {
      Logging.instance
          .log("_getNewTrade exception: $e\n$s", level: LogLevel.Error);
      return ExchangeResponse(
        exception: ExchangeException(
          e.toString(),
          ExchangeExceptionType.generic,
        ),
      );
    }
  }
}
