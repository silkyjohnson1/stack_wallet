// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/cached_electrumx_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:ui' as _i11;

import 'package:decimal/decimal.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/electrumx_rpc/electrumx_client.dart' as _i4;
import 'package:stackwallet/utilities/amount/amount_unit.dart' as _i9;
import 'package:stackwallet/utilities/enums/backup_frequency_type.dart' as _i8;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i10;
import 'package:stackwallet/utilities/enums/sync_type_enum.dart' as _i7;
import 'package:stackwallet/utilities/prefs.dart' as _i6;
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/cash_fusion_interface.dart'
    as _i3;

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

class _FakeDuration_0 extends _i1.SmartFake implements Duration {
  _FakeDuration_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDecimal_1 extends _i1.SmartFake implements _i2.Decimal {
  _FakeDecimal_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFusionInfo_2 extends _i1.SmartFake implements _i3.FusionInfo {
  _FakeFusionInfo_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ElectrumXClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockElectrumXClient extends _i1.Mock implements _i4.ElectrumXClient {
  MockElectrumXClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set failovers(List<_i4.ElectrumXNode>? _failovers) => super.noSuchMethod(
        Invocation.setter(
          #failovers,
          _failovers,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get currentFailoverIndex => (super.noSuchMethod(
        Invocation.getter(#currentFailoverIndex),
        returnValue: 0,
      ) as int);
  @override
  set currentFailoverIndex(int? _currentFailoverIndex) => super.noSuchMethod(
        Invocation.setter(
          #currentFailoverIndex,
          _currentFailoverIndex,
        ),
        returnValueForMissingStub: null,
      );
  @override
  Duration get connectionTimeoutForSpecialCaseJsonRPCClients =>
      (super.noSuchMethod(
        Invocation.getter(#connectionTimeoutForSpecialCaseJsonRPCClients),
        returnValue: _FakeDuration_0(
          this,
          Invocation.getter(#connectionTimeoutForSpecialCaseJsonRPCClients),
        ),
      ) as Duration);
  @override
  String get host => (super.noSuchMethod(
        Invocation.getter(#host),
        returnValue: '',
      ) as String);
  @override
  int get port => (super.noSuchMethod(
        Invocation.getter(#port),
        returnValue: 0,
      ) as int);
  @override
  bool get useSSL => (super.noSuchMethod(
        Invocation.getter(#useSSL),
        returnValue: false,
      ) as bool);
  @override
  _i5.Future<dynamic> request({
    required String? command,
    List<dynamic>? args = const [],
    String? requestID,
    int? retries = 2,
    Duration? requestTimeout = const Duration(seconds: 60),
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #request,
          [],
          {
            #command: command,
            #args: args,
            #requestID: requestID,
            #retries: retries,
            #requestTimeout: requestTimeout,
          },
        ),
        returnValue: _i5.Future<dynamic>.value(),
      ) as _i5.Future<dynamic>);
  @override
  _i5.Future<List<Map<String, dynamic>>> batchRequest({
    required String? command,
    required Map<String, List<dynamic>>? args,
    Duration? requestTimeout = const Duration(seconds: 60),
    int? retries = 2,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #batchRequest,
          [],
          {
            #command: command,
            #args: args,
            #requestTimeout: requestTimeout,
            #retries: retries,
          },
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i5.Future<List<Map<String, dynamic>>>);
  @override
  _i5.Future<bool> ping({
    String? requestID,
    int? retryCount = 1,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #ping,
          [],
          {
            #requestID: requestID,
            #retryCount: retryCount,
          },
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<Map<String, dynamic>> getBlockHeadTip({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBlockHeadTip,
          [],
          {#requestID: requestID},
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<Map<String, dynamic>> getServerFeatures({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getServerFeatures,
          [],
          {#requestID: requestID},
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<String> broadcastTransaction({
    required String? rawTx,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #broadcastTransaction,
          [],
          {
            #rawTx: rawTx,
            #requestID: requestID,
          },
        ),
        returnValue: _i5.Future<String>.value(''),
      ) as _i5.Future<String>);
  @override
  _i5.Future<Map<String, dynamic>> getBalance({
    required String? scripthash,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBalance,
          [],
          {
            #scripthash: scripthash,
            #requestID: requestID,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<List<Map<String, dynamic>>> getHistory({
    required String? scripthash,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getHistory,
          [],
          {
            #scripthash: scripthash,
            #requestID: requestID,
          },
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i5.Future<List<Map<String, dynamic>>>);
  @override
  _i5.Future<Map<String, List<Map<String, dynamic>>>> getBatchHistory(
          {required Map<String, List<dynamic>>? args}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBatchHistory,
          [],
          {#args: args},
        ),
        returnValue: _i5.Future<Map<String, List<Map<String, dynamic>>>>.value(
            <String, List<Map<String, dynamic>>>{}),
      ) as _i5.Future<Map<String, List<Map<String, dynamic>>>>);
  @override
  _i5.Future<List<Map<String, dynamic>>> getUTXOs({
    required String? scripthash,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUTXOs,
          [],
          {
            #scripthash: scripthash,
            #requestID: requestID,
          },
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i5.Future<List<Map<String, dynamic>>>);
  @override
  _i5.Future<Map<String, List<Map<String, dynamic>>>> getBatchUTXOs(
          {required Map<String, List<dynamic>>? args}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBatchUTXOs,
          [],
          {#args: args},
        ),
        returnValue: _i5.Future<Map<String, List<Map<String, dynamic>>>>.value(
            <String, List<Map<String, dynamic>>>{}),
      ) as _i5.Future<Map<String, List<Map<String, dynamic>>>>);
  @override
  _i5.Future<Map<String, dynamic>> getTransaction({
    required String? txHash,
    bool? verbose = true,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransaction,
          [],
          {
            #txHash: txHash,
            #verbose: verbose,
            #requestID: requestID,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<Map<String, dynamic>> getLelantusAnonymitySet({
    String? groupId = r'1',
    String? blockhash = r'',
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLelantusAnonymitySet,
          [],
          {
            #groupId: groupId,
            #blockhash: blockhash,
            #requestID: requestID,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<dynamic> getLelantusMintData({
    dynamic mints,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLelantusMintData,
          [],
          {
            #mints: mints,
            #requestID: requestID,
          },
        ),
        returnValue: _i5.Future<dynamic>.value(),
      ) as _i5.Future<dynamic>);
  @override
  _i5.Future<Map<String, dynamic>> getLelantusUsedCoinSerials({
    String? requestID,
    required int? startNumber,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLelantusUsedCoinSerials,
          [],
          {
            #requestID: requestID,
            #startNumber: startNumber,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<int> getLelantusLatestCoinId({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLelantusLatestCoinId,
          [],
          {#requestID: requestID},
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);
  @override
  _i5.Future<Map<String, dynamic>> getSparkAnonymitySet({
    String? coinGroupId = r'1',
    String? startBlockHash = r'',
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSparkAnonymitySet,
          [],
          {
            #coinGroupId: coinGroupId,
            #startBlockHash: startBlockHash,
            #requestID: requestID,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<Set<String>> getSparkUsedCoinsTags({
    String? requestID,
    required int? startNumber,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSparkUsedCoinsTags,
          [],
          {
            #requestID: requestID,
            #startNumber: startNumber,
          },
        ),
        returnValue: _i5.Future<Set<String>>.value(<String>{}),
      ) as _i5.Future<Set<String>>);
  @override
  _i5.Future<List<Map<String, dynamic>>> getSparkMintMetaData({
    String? requestID,
    required List<String>? sparkCoinHashes,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSparkMintMetaData,
          [],
          {
            #requestID: requestID,
            #sparkCoinHashes: sparkCoinHashes,
          },
        ),
        returnValue: _i5.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i5.Future<List<Map<String, dynamic>>>);
  @override
  _i5.Future<int> getSparkLatestCoinId({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSparkLatestCoinId,
          [],
          {#requestID: requestID},
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);
  @override
  _i5.Future<Map<String, dynamic>> getFeeRate({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFeeRate,
          [],
          {#requestID: requestID},
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
  @override
  _i5.Future<_i2.Decimal> estimateFee({
    String? requestID,
    required int? blocks,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #estimateFee,
          [],
          {
            #requestID: requestID,
            #blocks: blocks,
          },
        ),
        returnValue: _i5.Future<_i2.Decimal>.value(_FakeDecimal_1(
          this,
          Invocation.method(
            #estimateFee,
            [],
            {
              #requestID: requestID,
              #blocks: blocks,
            },
          ),
        )),
      ) as _i5.Future<_i2.Decimal>);
  @override
  _i5.Future<_i2.Decimal> relayFee({String? requestID}) => (super.noSuchMethod(
        Invocation.method(
          #relayFee,
          [],
          {#requestID: requestID},
        ),
        returnValue: _i5.Future<_i2.Decimal>.value(_FakeDecimal_1(
          this,
          Invocation.method(
            #relayFee,
            [],
            {#requestID: requestID},
          ),
        )),
      ) as _i5.Future<_i2.Decimal>);
}

/// A class which mocks [Prefs].
///
/// See the documentation for Mockito's code generation for more information.
class MockPrefs extends _i1.Mock implements _i6.Prefs {
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
  _i7.SyncingType get syncType => (super.noSuchMethod(
        Invocation.getter(#syncType),
        returnValue: _i7.SyncingType.currentWalletOnly,
      ) as _i7.SyncingType);
  @override
  set syncType(_i7.SyncingType? syncType) => super.noSuchMethod(
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
  _i8.BackupFrequencyType get backupFrequencyType => (super.noSuchMethod(
        Invocation.getter(#backupFrequencyType),
        returnValue: _i8.BackupFrequencyType.everyTenMinutes,
      ) as _i8.BackupFrequencyType);
  @override
  set backupFrequencyType(_i8.BackupFrequencyType? backupFrequencyType) =>
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
  _i5.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> incrementCurrentNotificationIndex() => (super.noSuchMethod(
        Invocation.method(
          #incrementCurrentNotificationIndex,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<bool> isExternalCallsSet() => (super.noSuchMethod(
        Invocation.method(
          #isExternalCallsSet,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<void> saveUserID(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #saveUserID,
          [userId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> saveSignupEpoch(int? signupEpoch) => (super.noSuchMethod(
        Invocation.method(
          #saveSignupEpoch,
          [signupEpoch],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i9.AmountUnit amountUnit(_i10.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #amountUnit,
          [coin],
        ),
        returnValue: _i9.AmountUnit.normal,
      ) as _i9.AmountUnit);
  @override
  void updateAmountUnit({
    required _i10.Coin? coin,
    required _i9.AmountUnit? amountUnit,
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
  _i3.FusionInfo getFusionServerInfo(_i10.Coin? coin) => (super.noSuchMethod(
        Invocation.method(
          #getFusionServerInfo,
          [coin],
        ),
        returnValue: _FakeFusionInfo_2(
          this,
          Invocation.method(
            #getFusionServerInfo,
            [coin],
          ),
        ),
      ) as _i3.FusionInfo);
  @override
  void setFusionServerInfo(
    _i10.Coin? coin,
    _i3.FusionInfo? fusionServerInfo,
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
  void addListener(_i11.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i11.VoidCallback? listener) => super.noSuchMethod(
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
