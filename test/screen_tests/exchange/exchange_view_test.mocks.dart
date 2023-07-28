// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/screen_tests/exchange/exchange_view_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:ui' as _i9;

import 'package:decimal/decimal.dart' as _i16;
import 'package:http/http.dart' as _i14;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/exchange/change_now/cn_exchange_estimate.dart'
    as _i19;
import 'package:stackwallet/models/exchange/change_now/exchange_transaction.dart'
    as _i21;
import 'package:stackwallet/models/exchange/change_now/exchange_transaction_status.dart'
    as _i22;
import 'package:stackwallet/models/exchange/response_objects/estimate.dart'
    as _i18;
import 'package:stackwallet/models/exchange/response_objects/fixed_rate_market.dart'
    as _i20;
import 'package:stackwallet/models/exchange/response_objects/range.dart'
    as _i17;
import 'package:stackwallet/models/exchange/response_objects/trade.dart'
    as _i11;
import 'package:stackwallet/models/isar/exchange_cache/currency.dart' as _i15;
import 'package:stackwallet/models/isar/exchange_cache/pair.dart' as _i23;
import 'package:stackwallet/services/exchange/change_now/change_now_api.dart'
    as _i13;
import 'package:stackwallet/services/exchange/exchange_response.dart' as _i2;
import 'package:stackwallet/services/trade_notes_service.dart' as _i12;
import 'package:stackwallet/services/trade_service.dart' as _i10;
import 'package:stackwallet/utilities/amount/amount_unit.dart' as _i7;
import 'package:stackwallet/utilities/enums/backup_frequency_type.dart' as _i5;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i8;
import 'package:stackwallet/utilities/enums/sync_type_enum.dart' as _i4;
import 'package:stackwallet/utilities/prefs.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeExchangeResponse_0<T> extends _i1.SmartFake
    implements _i2.ExchangeResponse<T> {
  _FakeExchangeResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Prefs].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrefs extends _i1.Mock implements _i3.Prefs {
  MockPrefs() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isInitialized => (super.noSuchMethod(
        Invocation.getter(#isInitialized),
        returnValue: false,
      ) as bool);
  @override
  int get lastUnlockedTimeout => (super.noSuchMethod(
        Invocation.getter(#lastUnlockedTimeout),
        returnValue: 0,
      ) as int);
  @override
  set lastUnlockedTimeout(int? lastUnlockedTimeout) => super.noSuchMethod(
        Invocation.setter(
          #lastUnlockedTimeout,
          lastUnlockedTimeout,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get lastUnlocked => (super.noSuchMethod(
        Invocation.getter(#lastUnlocked),
        returnValue: 0,
      ) as int);
  @override
  set lastUnlocked(int? lastUnlocked) => super.noSuchMethod(
        Invocation.setter(
          #lastUnlocked,
          lastUnlocked,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get currentNotificationId => (super.noSuchMethod(
        Invocation.getter(#currentNotificationId),
        returnValue: 0,
      ) as int);
  @override
  List<String> get walletIdsSyncOnStartup => (super.noSuchMethod(
        Invocation.getter(#walletIdsSyncOnStartup),
        returnValue: <String>[],
      ) as List<String>);
  @override
  set walletIdsSyncOnStartup(List<String>? walletIdsSyncOnStartup) =>
      super.noSuchMethod(
        Invocation.setter(
          #walletIdsSyncOnStartup,
          walletIdsSyncOnStartup,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.SyncingType get syncType => (super.noSuchMethod(
        Invocation.getter(#syncType),
        returnValue: _i4.SyncingType.currentWalletOnly,
      ) as _i4.SyncingType);
  @override
  set syncType(_i4.SyncingType? syncType) => super.noSuchMethod(
        Invocation.setter(
          #syncType,
          syncType,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get wifiOnly => (super.noSuchMethod(
        Invocation.getter(#wifiOnly),
        returnValue: false,
      ) as bool);
  @override
  set wifiOnly(bool? wifiOnly) => super.noSuchMethod(
        Invocation.setter(
          #wifiOnly,
          wifiOnly,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get showFavoriteWallets => (super.noSuchMethod(
        Invocation.getter(#showFavoriteWallets),
        returnValue: false,
      ) as bool);
  @override
  set showFavoriteWallets(bool? showFavoriteWallets) => super.noSuchMethod(
        Invocation.setter(
          #showFavoriteWallets,
          showFavoriteWallets,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get language => (super.noSuchMethod(
        Invocation.getter(#language),
        returnValue: '',
      ) as String);
  @override
  set language(String? newLanguage) => super.noSuchMethod(
        Invocation.setter(
          #language,
          newLanguage,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get currency => (super.noSuchMethod(
        Invocation.getter(#currency),
        returnValue: '',
      ) as String);
  @override
  set currency(String? newCurrency) => super.noSuchMethod(
        Invocation.setter(
          #currency,
          newCurrency,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get randomizePIN => (super.noSuchMethod(
        Invocation.getter(#randomizePIN),
        returnValue: false,
      ) as bool);
  @override
  set randomizePIN(bool? randomizePIN) => super.noSuchMethod(
        Invocation.setter(
          #randomizePIN,
          randomizePIN,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get useBiometrics => (super.noSuchMethod(
        Invocation.getter(#useBiometrics),
        returnValue: false,
      ) as bool);
  @override
  set useBiometrics(bool? useBiometrics) => super.noSuchMethod(
        Invocation.setter(
          #useBiometrics,
          useBiometrics,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasPin => (super.noSuchMethod(
        Invocation.getter(#hasPin),
        returnValue: false,
      ) as bool);
  @override
  set hasPin(bool? hasPin) => super.noSuchMethod(
        Invocation.setter(
          #hasPin,
          hasPin,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get familiarity => (super.noSuchMethod(
        Invocation.getter(#familiarity),
        returnValue: 0,
      ) as int);
  @override
  set familiarity(int? familiarity) => super.noSuchMethod(
        Invocation.setter(
          #familiarity,
          familiarity,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get showTestNetCoins => (super.noSuchMethod(
        Invocation.getter(#showTestNetCoins),
        returnValue: false,
      ) as bool);
  @override
  set showTestNetCoins(bool? showTestNetCoins) => super.noSuchMethod(
        Invocation.setter(
          #showTestNetCoins,
          showTestNetCoins,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get isAutoBackupEnabled => (super.noSuchMethod(
        Invocation.getter(#isAutoBackupEnabled),
        returnValue: false,
      ) as bool);
  @override
  set isAutoBackupEnabled(bool? isAutoBackupEnabled) => super.noSuchMethod(
        Invocation.setter(
          #isAutoBackupEnabled,
          isAutoBackupEnabled,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set autoBackupLocation(String? autoBackupLocation) => super.noSuchMethod(
        Invocation.setter(
          #autoBackupLocation,
          autoBackupLocation,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i5.BackupFrequencyType get backupFrequencyType => (super.noSuchMethod(
        Invocation.getter(#backupFrequencyType),
        returnValue: _i5.BackupFrequencyType.everyTenMinutes,
      ) as _i5.BackupFrequencyType);
  @override
  set backupFrequencyType(_i5.BackupFrequencyType? backupFrequencyType) =>
      super.noSuchMethod(
        Invocation.setter(
          #backupFrequencyType,
          backupFrequencyType,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set lastAutoBackup(DateTime? lastAutoBackup) => super.noSuchMethod(
        Invocation.setter(
          #lastAutoBackup,
          lastAutoBackup,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hideBlockExplorerWarning => (super.noSuchMethod(
        Invocation.getter(#hideBlockExplorerWarning),
        returnValue: false,
      ) as bool);
  @override
  set hideBlockExplorerWarning(bool? hideBlockExplorerWarning) =>
      super.noSuchMethod(
        Invocation.setter(
          #hideBlockExplorerWarning,
          hideBlockExplorerWarning,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get gotoWalletOnStartup => (super.noSuchMethod(
        Invocation.getter(#gotoWalletOnStartup),
        returnValue: false,
      ) as bool);
  @override
  set gotoWalletOnStartup(bool? gotoWalletOnStartup) => super.noSuchMethod(
        Invocation.setter(
          #gotoWalletOnStartup,
          gotoWalletOnStartup,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set startupWalletId(String? startupWalletId) => super.noSuchMethod(
        Invocation.setter(
          #startupWalletId,
          startupWalletId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get externalCalls => (super.noSuchMethod(
        Invocation.getter(#externalCalls),
        returnValue: false,
      ) as bool);
  @override
  set externalCalls(bool? externalCalls) => super.noSuchMethod(
        Invocation.setter(
          #externalCalls,
          externalCalls,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get enableCoinControl => (super.noSuchMethod(
        Invocation.getter(#enableCoinControl),
        returnValue: false,
      ) as bool);
  @override
  set enableCoinControl(bool? enableCoinControl) => super.noSuchMethod(
        Invocation.setter(
          #enableCoinControl,
          enableCoinControl,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get enableSystemBrightness => (super.noSuchMethod(
        Invocation.getter(#enableSystemBrightness),
        returnValue: false,
      ) as bool);
  @override
  set enableSystemBrightness(bool? enableSystemBrightness) =>
      super.noSuchMethod(
        Invocation.setter(
          #enableSystemBrightness,
          enableSystemBrightness,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get themeId => (super.noSuchMethod(
        Invocation.getter(#themeId),
        returnValue: '',
      ) as String);
  @override
  set themeId(String? themeId) => super.noSuchMethod(
        Invocation.setter(
          #themeId,
          themeId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get systemBrightnessLightThemeId => (super.noSuchMethod(
        Invocation.getter(#systemBrightnessLightThemeId),
        returnValue: '',
      ) as String);
  @override
  set systemBrightnessLightThemeId(String? systemBrightnessLightThemeId) =>
      super.noSuchMethod(
        Invocation.setter(
          #systemBrightnessLightThemeId,
          systemBrightnessLightThemeId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get systemBrightnessDarkThemeId => (super.noSuchMethod(
        Invocation.getter(#systemBrightnessDarkThemeId),
        returnValue: '',
      ) as String);
  @override
  set systemBrightnessDarkThemeId(String? systemBrightnessDarkThemeId) =>
      super.noSuchMethod(
        Invocation.setter(
          #systemBrightnessDarkThemeId,
          systemBrightnessDarkThemeId,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i6.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> incrementCurrentNotificationIndex() => (super.noSuchMethod(
        Invocation.method(
          #incrementCurrentNotificationIndex,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> isExternalCallsSet() => (super.noSuchMethod(
        Invocation.method(
          #isExternalCallsSet,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<void> saveUserID(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #saveUserID,
          [userId],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> saveSignupEpoch(int? signupEpoch) => (super.noSuchMethod(
        Invocation.method(
          #saveSignupEpoch,
          [signupEpoch],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i7.AmountUnit amountUnit(_i8.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #amountUnit,
          [coin],
        ),
        returnValue: _i7.AmountUnit.normal,
      ) as _i7.AmountUnit);
  @override
  void updateAmountUnit({
    required _i8.Coin? coin,
    required _i7.AmountUnit? amountUnit,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #updateAmountUnit,
          [],
          {
            #coin: coin,
            #amountUnit: amountUnit,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  int maxDecimals(_i8.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #maxDecimals,
          [coin],
        ),
        returnValue: 0,
      ) as int);
  @override
  void updateMaxDecimals({
    required _i8.Coin? coin,
    required int? maxDecimals,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #updateMaxDecimals,
          [],
          {
            #coin: coin,
            #maxDecimals: maxDecimals,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TradesService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTradesService extends _i1.Mock implements _i10.TradesService {
  MockTradesService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i11.Trade> get trades => (super.noSuchMethod(
        Invocation.getter(#trades),
        returnValue: <_i11.Trade>[],
      ) as List<_i11.Trade>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i11.Trade? get(String? tradeId) => (super.noSuchMethod(Invocation.method(
        #get,
        [tradeId],
      )) as _i11.Trade?);
  @override
  _i6.Future<void> add({
    required _i11.Trade? trade,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [],
          {
            #trade: trade,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> edit({
    required _i11.Trade? trade,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #edit,
          [],
          {
            #trade: trade,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> delete({
    required _i11.Trade? trade,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
          {
            #trade: trade,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteByUuid({
    required String? uuid,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteByUuid,
          [],
          {
            #uuid: uuid,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TradeNotesService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTradeNotesService extends _i1.Mock implements _i12.TradeNotesService {
  MockTradeNotesService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, String> get all => (super.noSuchMethod(
        Invocation.getter(#all),
        returnValue: <String, String>{},
      ) as Map<String, String>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  String getNote({required String? tradeId}) => (super.noSuchMethod(
        Invocation.method(
          #getNote,
          [],
          {#tradeId: tradeId},
        ),
        returnValue: '',
      ) as String);
  @override
  _i6.Future<void> set({
    required String? tradeId,
    required String? note,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #set,
          [],
          {
            #tradeId: tradeId,
            #note: note,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> delete({required String? tradeId}) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
          {#tradeId: tradeId},
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [ChangeNowAPI].
///
/// See the documentation for Mockito's code generation for more information.
class MockChangeNowAPI extends _i1.Mock implements _i13.ChangeNowAPI {
  MockChangeNowAPI() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set client(_i14.Client? _client) => super.noSuchMethod(
        Invocation.setter(
          #client,
          _client,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>> getAvailableCurrencies({
    bool? fixedRate,
    bool? active,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAvailableCurrencies,
          [],
          {
            #fixedRate: fixedRate,
            #active: active,
          },
        ),
        returnValue:
            _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>>.value(
                _FakeExchangeResponse_0<List<_i15.Currency>>(
          this,
          Invocation.method(
            #getAvailableCurrencies,
            [],
            {
              #fixedRate: fixedRate,
              #active: active,
            },
          ),
        )),
      ) as _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>>);
  @override
  _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>> getCurrenciesV2() =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrenciesV2,
          [],
        ),
        returnValue:
            _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>>.value(
                _FakeExchangeResponse_0<List<_i15.Currency>>(
          this,
          Invocation.method(
            #getCurrenciesV2,
            [],
          ),
        )),
      ) as _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>>);
  @override
  _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>> getPairedCurrencies({
    required String? ticker,
    bool? fixedRate,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPairedCurrencies,
          [],
          {
            #ticker: ticker,
            #fixedRate: fixedRate,
          },
        ),
        returnValue:
            _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>>.value(
                _FakeExchangeResponse_0<List<_i15.Currency>>(
          this,
          Invocation.method(
            #getPairedCurrencies,
            [],
            {
              #ticker: ticker,
              #fixedRate: fixedRate,
            },
          ),
        )),
      ) as _i6.Future<_i2.ExchangeResponse<List<_i15.Currency>>>);
  @override
  _i6.Future<_i2.ExchangeResponse<_i16.Decimal>> getMinimalExchangeAmount({
    required String? fromTicker,
    required String? toTicker,
    String? apiKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMinimalExchangeAmount,
          [],
          {
            #fromTicker: fromTicker,
            #toTicker: toTicker,
            #apiKey: apiKey,
          },
        ),
        returnValue: _i6.Future<_i2.ExchangeResponse<_i16.Decimal>>.value(
            _FakeExchangeResponse_0<_i16.Decimal>(
          this,
          Invocation.method(
            #getMinimalExchangeAmount,
            [],
            {
              #fromTicker: fromTicker,
              #toTicker: toTicker,
              #apiKey: apiKey,
            },
          ),
        )),
      ) as _i6.Future<_i2.ExchangeResponse<_i16.Decimal>>);
  @override
  _i6.Future<_i2.ExchangeResponse<_i17.Range>> getRange({
    required String? fromTicker,
    required String? toTicker,
    required bool? isFixedRate,
    String? apiKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRange,
          [],
          {
            #fromTicker: fromTicker,
            #toTicker: toTicker,
            #isFixedRate: isFixedRate,
            #apiKey: apiKey,
          },
        ),
        returnValue: _i6.Future<_i2.ExchangeResponse<_i17.Range>>.value(
            _FakeExchangeResponse_0<_i17.Range>(
          this,
          Invocation.method(
            #getRange,
            [],
            {
              #fromTicker: fromTicker,
              #toTicker: toTicker,
              #isFixedRate: isFixedRate,
              #apiKey: apiKey,
            },
          ),
        )),
      ) as _i6.Future<_i2.ExchangeResponse<_i17.Range>>);
  @override
  _i6.Future<_i2.ExchangeResponse<_i18.Estimate>> getEstimatedExchangeAmount({
    required String? fromTicker,
    required String? toTicker,
    required _i16.Decimal? fromAmount,
    String? apiKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getEstimatedExchangeAmount,
          [],
          {
            #fromTicker: fromTicker,
            #toTicker: toTicker,
            #fromAmount: fromAmount,
            #apiKey: apiKey,
          },
        ),
        returnValue: _i6.Future<_i2.ExchangeResponse<_i18.Estimate>>.value(
            _FakeExchangeResponse_0<_i18.Estimate>(
          this,
          Invocation.method(
            #getEstimatedExchangeAmount,
            [],
            {
              #fromTicker: fromTicker,
              #toTicker: toTicker,
              #fromAmount: fromAmount,
              #apiKey: apiKey,
            },
          ),
        )),
      ) as _i6.Future<_i2.ExchangeResponse<_i18.Estimate>>);
  @override
  _i6.Future<_i2.ExchangeResponse<_i18.Estimate>>
      getEstimatedExchangeAmountFixedRate({
    required String? fromTicker,
    required String? toTicker,
    required _i16.Decimal? fromAmount,
    required bool? reversed,
    bool? useRateId = true,
    String? apiKey,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #getEstimatedExchangeAmountFixedRate,
              [],
              {
                #fromTicker: fromTicker,
                #toTicker: toTicker,
                #fromAmount: fromAmount,
                #reversed: reversed,
                #useRateId: useRateId,
                #apiKey: apiKey,
              },
            ),
            returnValue: _i6.Future<_i2.ExchangeResponse<_i18.Estimate>>.value(
                _FakeExchangeResponse_0<_i18.Estimate>(
              this,
              Invocation.method(
                #getEstimatedExchangeAmountFixedRate,
                [],
                {
                  #fromTicker: fromTicker,
                  #toTicker: toTicker,
                  #fromAmount: fromAmount,
                  #reversed: reversed,
                  #useRateId: useRateId,
                  #apiKey: apiKey,
                },
              ),
            )),
          ) as _i6.Future<_i2.ExchangeResponse<_i18.Estimate>>);
  @override
  _i6.Future<_i2.ExchangeResponse<_i19.CNExchangeEstimate>>
      getEstimatedExchangeAmountV2({
    required String? fromTicker,
    required String? toTicker,
    required _i19.CNEstimateType? fromOrTo,
    required _i16.Decimal? amount,
    String? fromNetwork,
    String? toNetwork,
    _i19.CNFlowType? flow = _i19.CNFlowType.standard,
    String? apiKey,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #getEstimatedExchangeAmountV2,
              [],
              {
                #fromTicker: fromTicker,
                #toTicker: toTicker,
                #fromOrTo: fromOrTo,
                #amount: amount,
                #fromNetwork: fromNetwork,
                #toNetwork: toNetwork,
                #flow: flow,
                #apiKey: apiKey,
              },
            ),
            returnValue:
                _i6.Future<_i2.ExchangeResponse<_i19.CNExchangeEstimate>>.value(
                    _FakeExchangeResponse_0<_i19.CNExchangeEstimate>(
              this,
              Invocation.method(
                #getEstimatedExchangeAmountV2,
                [],
                {
                  #fromTicker: fromTicker,
                  #toTicker: toTicker,
                  #fromOrTo: fromOrTo,
                  #amount: amount,
                  #fromNetwork: fromNetwork,
                  #toNetwork: toNetwork,
                  #flow: flow,
                  #apiKey: apiKey,
                },
              ),
            )),
          ) as _i6.Future<_i2.ExchangeResponse<_i19.CNExchangeEstimate>>);
  @override
  _i6.Future<_i2.ExchangeResponse<List<_i20.FixedRateMarket>>>
      getAvailableFixedRateMarkets({String? apiKey}) => (super.noSuchMethod(
            Invocation.method(
              #getAvailableFixedRateMarkets,
              [],
              {#apiKey: apiKey},
            ),
            returnValue: _i6
                .Future<_i2.ExchangeResponse<List<_i20.FixedRateMarket>>>.value(
                _FakeExchangeResponse_0<List<_i20.FixedRateMarket>>(
              this,
              Invocation.method(
                #getAvailableFixedRateMarkets,
                [],
                {#apiKey: apiKey},
              ),
            )),
          ) as _i6.Future<_i2.ExchangeResponse<List<_i20.FixedRateMarket>>>);
  @override
  _i6.Future<_i2.ExchangeResponse<_i21.ExchangeTransaction>>
      createStandardExchangeTransaction({
    required String? fromTicker,
    required String? toTicker,
    required String? receivingAddress,
    required _i16.Decimal? amount,
    String? extraId = r'',
    String? userId = r'',
    String? contactEmail = r'',
    String? refundAddress = r'',
    String? refundExtraId = r'',
    String? apiKey,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #createStandardExchangeTransaction,
              [],
              {
                #fromTicker: fromTicker,
                #toTicker: toTicker,
                #receivingAddress: receivingAddress,
                #amount: amount,
                #extraId: extraId,
                #userId: userId,
                #contactEmail: contactEmail,
                #refundAddress: refundAddress,
                #refundExtraId: refundExtraId,
                #apiKey: apiKey,
              },
            ),
            returnValue: _i6
                .Future<_i2.ExchangeResponse<_i21.ExchangeTransaction>>.value(
                _FakeExchangeResponse_0<_i21.ExchangeTransaction>(
              this,
              Invocation.method(
                #createStandardExchangeTransaction,
                [],
                {
                  #fromTicker: fromTicker,
                  #toTicker: toTicker,
                  #receivingAddress: receivingAddress,
                  #amount: amount,
                  #extraId: extraId,
                  #userId: userId,
                  #contactEmail: contactEmail,
                  #refundAddress: refundAddress,
                  #refundExtraId: refundExtraId,
                  #apiKey: apiKey,
                },
              ),
            )),
          ) as _i6.Future<_i2.ExchangeResponse<_i21.ExchangeTransaction>>);
  @override
  _i6.Future<_i2.ExchangeResponse<_i21.ExchangeTransaction>>
      createFixedRateExchangeTransaction({
    required String? fromTicker,
    required String? toTicker,
    required String? receivingAddress,
    required _i16.Decimal? amount,
    required String? rateId,
    required bool? reversed,
    String? extraId = r'',
    String? userId = r'',
    String? contactEmail = r'',
    String? refundAddress = r'',
    String? refundExtraId = r'',
    String? apiKey,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #createFixedRateExchangeTransaction,
              [],
              {
                #fromTicker: fromTicker,
                #toTicker: toTicker,
                #receivingAddress: receivingAddress,
                #amount: amount,
                #rateId: rateId,
                #reversed: reversed,
                #extraId: extraId,
                #userId: userId,
                #contactEmail: contactEmail,
                #refundAddress: refundAddress,
                #refundExtraId: refundExtraId,
                #apiKey: apiKey,
              },
            ),
            returnValue: _i6
                .Future<_i2.ExchangeResponse<_i21.ExchangeTransaction>>.value(
                _FakeExchangeResponse_0<_i21.ExchangeTransaction>(
              this,
              Invocation.method(
                #createFixedRateExchangeTransaction,
                [],
                {
                  #fromTicker: fromTicker,
                  #toTicker: toTicker,
                  #receivingAddress: receivingAddress,
                  #amount: amount,
                  #rateId: rateId,
                  #reversed: reversed,
                  #extraId: extraId,
                  #userId: userId,
                  #contactEmail: contactEmail,
                  #refundAddress: refundAddress,
                  #refundExtraId: refundExtraId,
                  #apiKey: apiKey,
                },
              ),
            )),
          ) as _i6.Future<_i2.ExchangeResponse<_i21.ExchangeTransaction>>);
  @override
  _i6.Future<
      _i2
      .ExchangeResponse<_i22.ExchangeTransactionStatus>> getTransactionStatus({
    required String? id,
    String? apiKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransactionStatus,
          [],
          {
            #id: id,
            #apiKey: apiKey,
          },
        ),
        returnValue: _i6
            .Future<_i2.ExchangeResponse<_i22.ExchangeTransactionStatus>>.value(
            _FakeExchangeResponse_0<_i22.ExchangeTransactionStatus>(
          this,
          Invocation.method(
            #getTransactionStatus,
            [],
            {
              #id: id,
              #apiKey: apiKey,
            },
          ),
        )),
      ) as _i6.Future<_i2.ExchangeResponse<_i22.ExchangeTransactionStatus>>);
  @override
  _i6.Future<_i2.ExchangeResponse<List<_i23.Pair>>>
      getAvailableFloatingRatePairs({bool? includePartners = false}) =>
          (super.noSuchMethod(
            Invocation.method(
              #getAvailableFloatingRatePairs,
              [],
              {#includePartners: includePartners},
            ),
            returnValue:
                _i6.Future<_i2.ExchangeResponse<List<_i23.Pair>>>.value(
                    _FakeExchangeResponse_0<List<_i23.Pair>>(
              this,
              Invocation.method(
                #getAvailableFloatingRatePairs,
                [],
                {#includePartners: includePartners},
              ),
            )),
          ) as _i6.Future<_i2.ExchangeResponse<List<_i23.Pair>>>);
}
