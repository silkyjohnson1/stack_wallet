// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/widget_tests/node_options_sheet_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i11;
import 'dart:io' as _i8;
import 'dart:ui' as _i16;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/db/isar/main_db.dart' as _i3;
import 'package:stackwallet/models/node_model.dart' as _i17;
import 'package:stackwallet/services/event_bus/events/global/tor_connection_status_changed_event.dart'
    as _i19;
import 'package:stackwallet/services/node_service.dart' as _i2;
import 'package:stackwallet/services/tor_service.dart' as _i18;
import 'package:stackwallet/services/wallets.dart' as _i9;
import 'package:stackwallet/utilities/amount/amount_unit.dart' as _i15;
import 'package:stackwallet/utilities/enums/backup_frequency_type.dart' as _i14;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i10;
import 'package:stackwallet/utilities/enums/sync_type_enum.dart' as _i13;
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart'
    as _i7;
import 'package:stackwallet/utilities/prefs.dart' as _i12;
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart'
    as _i4;
import 'package:stackwallet/wallets/wallet/mixins/cash_fusion.dart' as _i6;
import 'package:stackwallet/wallets/wallet/wallet.dart' as _i5;
import 'package:tor_ffi_plugin/tor_ffi_plugin.dart' as _i20;

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

class _FakeNodeService_0 extends _i1.SmartFake implements _i2.NodeService {
  _FakeNodeService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMainDB_1 extends _i1.SmartFake implements _i3.MainDB {
  _FakeMainDB_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWallet_2<T extends _i4.CryptoCurrency> extends _i1.SmartFake
    implements _i5.Wallet<T> {
  _FakeWallet_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFusionInfo_3 extends _i1.SmartFake implements _i6.FusionInfo {
  _FakeFusionInfo_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSecureStorageInterface_4 extends _i1.SmartFake
    implements _i7.SecureStorageInterface {
  _FakeSecureStorageInterface_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeInternetAddress_5 extends _i1.SmartFake
    implements _i8.InternetAddress {
  _FakeInternetAddress_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Wallets].
///
/// See the documentation for Mockito's code generation for more information.
class MockWallets extends _i1.Mock implements _i9.Wallets {
  MockWallets() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.NodeService get nodeService => (super.noSuchMethod(
        Invocation.getter(#nodeService),
        returnValue: _FakeNodeService_0(
          this,
          Invocation.getter(#nodeService),
        ),
      ) as _i2.NodeService);
  @override
  set nodeService(_i2.NodeService? _nodeService) => super.noSuchMethod(
        Invocation.setter(
          #nodeService,
          _nodeService,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.MainDB get mainDB => (super.noSuchMethod(
        Invocation.getter(#mainDB),
        returnValue: _FakeMainDB_1(
          this,
          Invocation.getter(#mainDB),
        ),
      ) as _i3.MainDB);
  @override
  set mainDB(_i3.MainDB? _mainDB) => super.noSuchMethod(
        Invocation.setter(
          #mainDB,
          _mainDB,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasWallets => (super.noSuchMethod(
        Invocation.getter(#hasWallets),
        returnValue: false,
      ) as bool);
  @override
  List<_i5.Wallet<_i4.CryptoCurrency>> get wallets => (super.noSuchMethod(
        Invocation.getter(#wallets),
        returnValue: <_i5.Wallet<_i4.CryptoCurrency>>[],
      ) as List<_i5.Wallet<_i4.CryptoCurrency>>);
  @override
  List<({_i10.Coin coin, List<_i5.Wallet<_i4.CryptoCurrency>> wallets})>
      get walletsByCoin => (super.noSuchMethod(
            Invocation.getter(#walletsByCoin),
            returnValue: <({
              _i10.Coin coin,
              List<_i5.Wallet<_i4.CryptoCurrency>> wallets
            })>[],
          ) as List<
              ({
                _i10.Coin coin,
                List<_i5.Wallet<_i4.CryptoCurrency>> wallets
              })>);
  @override
  _i5.Wallet<_i4.CryptoCurrency> getWallet(String? walletId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getWallet,
          [walletId],
        ),
        returnValue: _FakeWallet_2<_i4.CryptoCurrency>(
          this,
          Invocation.method(
            #getWallet,
            [walletId],
          ),
        ),
      ) as _i5.Wallet<_i4.CryptoCurrency>);
  @override
  void addWallet(_i5.Wallet<_i4.CryptoCurrency>? wallet) => super.noSuchMethod(
        Invocation.method(
          #addWallet,
          [wallet],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i11.Future<void> deleteWallet(
    String? walletId,
    _i7.SecureStorageInterface? secureStorage,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteWallet,
          [
            walletId,
            secureStorage,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> load(
    _i12.Prefs? prefs,
    _i3.MainDB? mainDB,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #load,
          [
            prefs,
            mainDB,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> loadAfterStackRestore(
    _i12.Prefs? prefs,
    List<_i5.Wallet<_i4.CryptoCurrency>>? wallets,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #loadAfterStackRestore,
          [
            prefs,
            wallets,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
}

/// A class which mocks [Prefs].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrefs extends _i1.Mock implements _i12.Prefs {
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
  _i13.SyncingType get syncType => (super.noSuchMethod(
        Invocation.getter(#syncType),
        returnValue: _i13.SyncingType.currentWalletOnly,
      ) as _i13.SyncingType);
  @override
  set syncType(_i13.SyncingType? syncType) => super.noSuchMethod(
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
  bool get torKillSwitch => (super.noSuchMethod(
        Invocation.getter(#torKillSwitch),
        returnValue: false,
      ) as bool);
  @override
  set torKillSwitch(bool? torKillswitch) => super.noSuchMethod(
        Invocation.setter(
          #torKillSwitch,
          torKillswitch,
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
  _i14.BackupFrequencyType get backupFrequencyType => (super.noSuchMethod(
        Invocation.getter(#backupFrequencyType),
        returnValue: _i14.BackupFrequencyType.everyTenMinutes,
      ) as _i14.BackupFrequencyType);
  @override
  set backupFrequencyType(_i14.BackupFrequencyType? backupFrequencyType) =>
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
  bool get useTor => (super.noSuchMethod(
        Invocation.getter(#useTor),
        returnValue: false,
      ) as bool);
  @override
  set useTor(bool? useTor) => super.noSuchMethod(
        Invocation.setter(
          #useTor,
          useTor,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i11.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> incrementCurrentNotificationIndex() => (super.noSuchMethod(
        Invocation.method(
          #incrementCurrentNotificationIndex,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<bool> isExternalCallsSet() => (super.noSuchMethod(
        Invocation.method(
          #isExternalCallsSet,
          [],
        ),
        returnValue: _i11.Future<bool>.value(false),
      ) as _i11.Future<bool>);
  @override
  _i11.Future<void> saveUserID(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #saveUserID,
          [userId],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> saveSignupEpoch(int? signupEpoch) => (super.noSuchMethod(
        Invocation.method(
          #saveSignupEpoch,
          [signupEpoch],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i15.AmountUnit amountUnit(_i10.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #amountUnit,
          [coin],
        ),
        returnValue: _i15.AmountUnit.normal,
      ) as _i15.AmountUnit);
  @override
  void updateAmountUnit({
    required _i10.Coin? coin,
    required _i15.AmountUnit? amountUnit,
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
  int maxDecimals(_i10.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #maxDecimals,
          [coin],
        ),
        returnValue: 0,
      ) as int);
  @override
  void updateMaxDecimals({
    required _i10.Coin? coin,
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
  _i6.FusionInfo getFusionServerInfo(_i10.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #getFusionServerInfo,
          [coin],
        ),
        returnValue: _FakeFusionInfo_3(
          this,
          Invocation.method(
            #getFusionServerInfo,
            [coin],
          ),
        ),
      ) as _i6.FusionInfo);
  @override
  void setFusionServerInfo(
    _i10.Coin? coin,
    _i6.FusionInfo? fusionServerInfo,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #setFusionServerInfo,
          [
            coin,
            fusionServerInfo,
          ],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i16.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i16.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [NodeService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNodeService extends _i1.Mock implements _i2.NodeService {
  MockNodeService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.SecureStorageInterface get secureStorageInterface => (super.noSuchMethod(
        Invocation.getter(#secureStorageInterface),
        returnValue: _FakeSecureStorageInterface_4(
          this,
          Invocation.getter(#secureStorageInterface),
        ),
      ) as _i7.SecureStorageInterface);
  @override
  List<_i17.NodeModel> get primaryNodes => (super.noSuchMethod(
        Invocation.getter(#primaryNodes),
        returnValue: <_i17.NodeModel>[],
      ) as List<_i17.NodeModel>);
  @override
  List<_i17.NodeModel> get nodes => (super.noSuchMethod(
        Invocation.getter(#nodes),
        returnValue: <_i17.NodeModel>[],
      ) as List<_i17.NodeModel>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i11.Future<void> updateDefaults() => (super.noSuchMethod(
        Invocation.method(
          #updateDefaults,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> setPrimaryNodeFor({
    required _i10.Coin? coin,
    required _i17.NodeModel? node,
    bool? shouldNotifyListeners = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #setPrimaryNodeFor,
          [],
          {
            #coin: coin,
            #node: node,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i17.NodeModel? getPrimaryNodeFor({required _i10.Coin? coin}) =>
      (super.noSuchMethod(Invocation.method(
        #getPrimaryNodeFor,
        [],
        {#coin: coin},
      )) as _i17.NodeModel?);
  @override
  List<_i17.NodeModel> getNodesFor(_i10.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #getNodesFor,
          [coin],
        ),
        returnValue: <_i17.NodeModel>[],
      ) as List<_i17.NodeModel>);
  @override
  _i17.NodeModel? getNodeById({required String? id}) =>
      (super.noSuchMethod(Invocation.method(
        #getNodeById,
        [],
        {#id: id},
      )) as _i17.NodeModel?);
  @override
  List<_i17.NodeModel> failoverNodesFor({required _i10.Coin? coin}) =>
      (super.noSuchMethod(
        Invocation.method(
          #failoverNodesFor,
          [],
          {#coin: coin},
        ),
        returnValue: <_i17.NodeModel>[],
      ) as List<_i17.NodeModel>);
  @override
  _i11.Future<void> add(
    _i17.NodeModel? node,
    String? password,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [
            node,
            password,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> delete(
    String? id,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [
            id,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> setEnabledState(
    String? id,
    bool? enabled,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setEnabledState,
          [
            id,
            enabled,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> edit(
    _i17.NodeModel? editedNode,
    String? password,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #edit,
          [
            editedNode,
            password,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> updateCommunityNodes() => (super.noSuchMethod(
        Invocation.method(
          #updateCommunityNodes,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  void addListener(_i16.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i16.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [TorService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTorService extends _i1.Mock implements _i18.TorService {
  MockTorService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i19.TorConnectionStatus get status => (super.noSuchMethod(
        Invocation.getter(#status),
        returnValue: _i19.TorConnectionStatus.disconnected,
      ) as _i19.TorConnectionStatus);
  @override
  ({_i8.InternetAddress host, int port}) getProxyInfo() => (super.noSuchMethod(
        Invocation.method(
          #getProxyInfo,
          [],
        ),
        returnValue: (
          host: _FakeInternetAddress_5(
            this,
            Invocation.method(
              #getProxyInfo,
              [],
            ),
          ),
          port: 0
        ),
      ) as ({_i8.InternetAddress host, int port}));
  @override
  void init({
    required String? torDataDirPath,
    _i20.Tor? mockableOverride,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #init,
          [],
          {
            #torDataDirPath: torDataDirPath,
            #mockableOverride: mockableOverride,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i11.Future<void> start() => (super.noSuchMethod(
        Invocation.method(
          #start,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> disable() => (super.noSuchMethod(
        Invocation.method(
          #disable,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
}
