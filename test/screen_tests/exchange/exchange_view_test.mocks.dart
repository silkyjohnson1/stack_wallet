// Mocks generated by Mockito 5.2.0 from annotations
// in stackwallet/test/screen_tests/exchange/exchange_view_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;
import 'dart:ui' as _i7;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/exchange/change_now/exchange_transaction.dart'
    as _i9;
import 'package:stackwallet/pages/exchange_view/sub_widgets/exchange_rate_sheet.dart'
    as _i4;
import 'package:stackwallet/services/change_now/change_now.dart' as _i11;
import 'package:stackwallet/services/trade_notes_service.dart' as _i10;
import 'package:stackwallet/services/trade_service.dart' as _i8;
import 'package:stackwallet/utilities/enums/backup_frequency_type.dart' as _i5;
import 'package:stackwallet/utilities/enums/sync_type_enum.dart' as _i3;
import 'package:stackwallet/utilities/prefs.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [Prefs].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrefs extends _i1.Mock implements _i2.Prefs {
  MockPrefs() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isInitialized =>
      (super.noSuchMethod(Invocation.getter(#isInitialized), returnValue: false)
          as bool);
  @override
  int get lastUnlockedTimeout => (super
          .noSuchMethod(Invocation.getter(#lastUnlockedTimeout), returnValue: 0)
      as int);
  @override
  set lastUnlockedTimeout(int? lastUnlockedTimeout) => super.noSuchMethod(
      Invocation.setter(#lastUnlockedTimeout, lastUnlockedTimeout),
      returnValueForMissingStub: null);
  @override
  int get lastUnlocked =>
      (super.noSuchMethod(Invocation.getter(#lastUnlocked), returnValue: 0)
          as int);
  @override
  set lastUnlocked(int? lastUnlocked) =>
      super.noSuchMethod(Invocation.setter(#lastUnlocked, lastUnlocked),
          returnValueForMissingStub: null);
  @override
  int get currentNotificationId =>
      (super.noSuchMethod(Invocation.getter(#currentNotificationId),
          returnValue: 0) as int);
  @override
  List<String> get walletIdsSyncOnStartup =>
      (super.noSuchMethod(Invocation.getter(#walletIdsSyncOnStartup),
          returnValue: <String>[]) as List<String>);
  @override
  set walletIdsSyncOnStartup(List<String>? walletIdsSyncOnStartup) =>
      super.noSuchMethod(
          Invocation.setter(#walletIdsSyncOnStartup, walletIdsSyncOnStartup),
          returnValueForMissingStub: null);
  @override
  _i3.SyncingType get syncType =>
      (super.noSuchMethod(Invocation.getter(#syncType),
          returnValue: _i3.SyncingType.currentWalletOnly) as _i3.SyncingType);
  @override
  set syncType(_i3.SyncingType? syncType) =>
      super.noSuchMethod(Invocation.setter(#syncType, syncType),
          returnValueForMissingStub: null);
  @override
  bool get wifiOnly =>
      (super.noSuchMethod(Invocation.getter(#wifiOnly), returnValue: false)
          as bool);
  @override
  set wifiOnly(bool? wifiOnly) =>
      super.noSuchMethod(Invocation.setter(#wifiOnly, wifiOnly),
          returnValueForMissingStub: null);
  @override
  bool get showFavoriteWallets =>
      (super.noSuchMethod(Invocation.getter(#showFavoriteWallets),
          returnValue: false) as bool);
  @override
  set showFavoriteWallets(bool? showFavoriteWallets) => super.noSuchMethod(
      Invocation.setter(#showFavoriteWallets, showFavoriteWallets),
      returnValueForMissingStub: null);
  @override
  String get language =>
      (super.noSuchMethod(Invocation.getter(#language), returnValue: '')
          as String);
  @override
  set language(String? newLanguage) =>
      super.noSuchMethod(Invocation.setter(#language, newLanguage),
          returnValueForMissingStub: null);
  @override
  String get currency =>
      (super.noSuchMethod(Invocation.getter(#currency), returnValue: '')
          as String);
  @override
  set currency(String? newCurrency) =>
      super.noSuchMethod(Invocation.setter(#currency, newCurrency),
          returnValueForMissingStub: null);
  @override
  _i4.ExchangeRateType get exchangeRateType =>
      (super.noSuchMethod(Invocation.getter(#exchangeRateType),
          returnValue: _i4.ExchangeRateType.estimated) as _i4.ExchangeRateType);
  @override
  set exchangeRateType(_i4.ExchangeRateType? exchangeRateType) =>
      super.noSuchMethod(Invocation.setter(#exchangeRateType, exchangeRateType),
          returnValueForMissingStub: null);
  @override
  bool get useBiometrics =>
      (super.noSuchMethod(Invocation.getter(#useBiometrics), returnValue: false)
          as bool);
  @override
  set useBiometrics(bool? useBiometrics) =>
      super.noSuchMethod(Invocation.setter(#useBiometrics, useBiometrics),
          returnValueForMissingStub: null);
  @override
  bool get hasPin =>
      (super.noSuchMethod(Invocation.getter(#hasPin), returnValue: false)
          as bool);
  @override
  set hasPin(bool? hasPin) =>
      super.noSuchMethod(Invocation.setter(#hasPin, hasPin),
          returnValueForMissingStub: null);
  @override
  bool get showTestNetCoins =>
      (super.noSuchMethod(Invocation.getter(#showTestNetCoins),
          returnValue: false) as bool);
  @override
  set showTestNetCoins(bool? showTestNetCoins) =>
      super.noSuchMethod(Invocation.setter(#showTestNetCoins, showTestNetCoins),
          returnValueForMissingStub: null);
  @override
  bool get isAutoBackupEnabled =>
      (super.noSuchMethod(Invocation.getter(#isAutoBackupEnabled),
          returnValue: false) as bool);
  @override
  set isAutoBackupEnabled(bool? isAutoBackupEnabled) => super.noSuchMethod(
      Invocation.setter(#isAutoBackupEnabled, isAutoBackupEnabled),
      returnValueForMissingStub: null);
  @override
  set autoBackupLocation(String? autoBackupLocation) => super.noSuchMethod(
      Invocation.setter(#autoBackupLocation, autoBackupLocation),
      returnValueForMissingStub: null);
  @override
  _i5.BackupFrequencyType get backupFrequencyType =>
      (super.noSuchMethod(Invocation.getter(#backupFrequencyType),
              returnValue: _i5.BackupFrequencyType.everyTenMinutes)
          as _i5.BackupFrequencyType);
  @override
  set backupFrequencyType(_i5.BackupFrequencyType? backupFrequencyType) =>
      super.noSuchMethod(
          Invocation.setter(#backupFrequencyType, backupFrequencyType),
          returnValueForMissingStub: null);
  @override
  set lastAutoBackup(DateTime? lastAutoBackup) =>
      super.noSuchMethod(Invocation.setter(#lastAutoBackup, lastAutoBackup),
          returnValueForMissingStub: null);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i6.Future<void> init() => (super.noSuchMethod(Invocation.method(#init, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> incrementCurrentNotificationIndex() => (super.noSuchMethod(
      Invocation.method(#incrementCurrentNotificationIndex, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [TradesService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTradesService extends _i1.Mock implements _i8.TradesService {
  MockTradesService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i9.ExchangeTransaction> get trades =>
      (super.noSuchMethod(Invocation.getter(#trades),
              returnValue: <_i9.ExchangeTransaction>[])
          as List<_i9.ExchangeTransaction>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i6.Future<void> add(
          {_i9.ExchangeTransaction? trade, bool? shouldNotifyListeners}) =>
      (super.noSuchMethod(
          Invocation.method(#add, [],
              {#trade: trade, #shouldNotifyListeners: shouldNotifyListeners}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> edit(
          {_i9.ExchangeTransaction? trade, bool? shouldNotifyListeners}) =>
      (super.noSuchMethod(
          Invocation.method(#edit, [],
              {#trade: trade, #shouldNotifyListeners: shouldNotifyListeners}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> delete(
          {_i9.ExchangeTransaction? trade, bool? shouldNotifyListeners}) =>
      (super.noSuchMethod(
          Invocation.method(#delete, [],
              {#trade: trade, #shouldNotifyListeners: shouldNotifyListeners}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteByUuid({String? uuid, bool? shouldNotifyListeners}) =>
      (super.noSuchMethod(
          Invocation.method(#deleteByUuid, [],
              {#uuid: uuid, #shouldNotifyListeners: shouldNotifyListeners}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [TradeNotesService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTradeNotesService extends _i1.Mock implements _i10.TradeNotesService {
  MockTradeNotesService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, String> get all => (super.noSuchMethod(Invocation.getter(#all),
      returnValue: <String, String>{}) as Map<String, String>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  String getNote({String? tradeId}) =>
      (super.noSuchMethod(Invocation.method(#getNote, [], {#tradeId: tradeId}),
          returnValue: '') as String);
  @override
  _i6.Future<void> set({String? tradeId, String? note}) => (super.noSuchMethod(
      Invocation.method(#set, [], {#tradeId: tradeId, #note: note}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> delete({String? tradeId}) =>
      (super.noSuchMethod(Invocation.method(#delete, [], {#tradeId: tradeId}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [ChangeNow].
///
/// See the documentation for Mockito's code generation for more information.
class MockChangeNow extends _i1.Mock implements _i11.ChangeNow {
  MockChangeNow() {
    _i1.throwOnMissingStub(this);
  }
}
