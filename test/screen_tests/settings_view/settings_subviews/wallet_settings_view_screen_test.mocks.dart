// Mocks generated by Mockito 5.3.2 from annotations
// in stackwallet/test/screen_tests/settings_view/settings_subviews/wallet_settings_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:ui' as _i14;

import 'package:local_auth/auth_strings.dart' as _i11;
import 'package:local_auth/local_auth.dart' as _i10;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/electrumx_rpc/cached_electrumx.dart' as _i6;
import 'package:stackwallet/electrumx_rpc/electrumx.dart' as _i7;
import 'package:stackwallet/models/balance.dart' as _i5;
import 'package:stackwallet/models/isar/models/isar_models.dart' as _i16;
import 'package:stackwallet/models/models.dart' as _i4;
import 'package:stackwallet/services/coins/coin_service.dart' as _i3;
import 'package:stackwallet/services/coins/manager.dart' as _i15;
import 'package:stackwallet/services/wallets_service.dart' as _i13;
import 'package:stackwallet/utilities/biometrics.dart' as _i12;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i9;
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
// ignore_for_file: subtype_of_sealed_class

class _FakePrefs_0 extends _i1.SmartFake implements _i2.Prefs {
  _FakePrefs_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCoinServiceAPI_1 extends _i1.SmartFake
    implements _i3.CoinServiceAPI {
  _FakeCoinServiceAPI_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFeeObject_2 extends _i1.SmartFake implements _i4.FeeObject {
  _FakeFeeObject_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBalance_3 extends _i1.SmartFake implements _i5.Balance {
  _FakeBalance_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CachedElectrumX].
///
/// See the documentation for Mockito's code generation for more information.
class MockCachedElectrumX extends _i1.Mock implements _i6.CachedElectrumX {
  MockCachedElectrumX() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get server => (super.noSuchMethod(
        Invocation.getter(#server),
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
  _i2.Prefs get prefs => (super.noSuchMethod(
        Invocation.getter(#prefs),
        returnValue: _FakePrefs_0(
          this,
          Invocation.getter(#prefs),
        ),
      ) as _i2.Prefs);
  @override
  List<_i7.ElectrumXNode> get failovers => (super.noSuchMethod(
        Invocation.getter(#failovers),
        returnValue: <_i7.ElectrumXNode>[],
      ) as List<_i7.ElectrumXNode>);
  @override
  _i8.Future<Map<String, dynamic>> getAnonymitySet({
    required String? groupId,
    String? blockhash = r'',
    required _i9.Coin? coin,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAnonymitySet,
          [],
          {
            #groupId: groupId,
            #blockhash: blockhash,
            #coin: coin,
          },
        ),
        returnValue:
            _i8.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i8.Future<Map<String, dynamic>>);
  @override
  String base64ToHex(String? source) => (super.noSuchMethod(
        Invocation.method(
          #base64ToHex,
          [source],
        ),
        returnValue: '',
      ) as String);
  @override
  String base64ToReverseHex(String? source) => (super.noSuchMethod(
        Invocation.method(
          #base64ToReverseHex,
          [source],
        ),
        returnValue: '',
      ) as String);
  @override
  _i8.Future<Map<String, dynamic>> getTransaction({
    required String? txHash,
    required _i9.Coin? coin,
    bool? verbose = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransaction,
          [],
          {
            #txHash: txHash,
            #coin: coin,
            #verbose: verbose,
          },
        ),
        returnValue:
            _i8.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<List<dynamic>> getUsedCoinSerials({
    required _i9.Coin? coin,
    int? startNumber = 0,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUsedCoinSerials,
          [],
          {
            #coin: coin,
            #startNumber: startNumber,
          },
        ),
        returnValue: _i8.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i8.Future<List<dynamic>>);
  @override
  _i8.Future<void> clearSharedTransactionCache({required _i9.Coin? coin}) =>
      (super.noSuchMethod(
        Invocation.method(
          #clearSharedTransactionCache,
          [],
          {#coin: coin},
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [LocalAuthentication].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalAuthentication extends _i1.Mock
    implements _i10.LocalAuthentication {
  MockLocalAuthentication() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<bool> get canCheckBiometrics => (super.noSuchMethod(
        Invocation.getter(#canCheckBiometrics),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<bool> authenticateWithBiometrics({
    required String? localizedReason,
    bool? useErrorDialogs = true,
    bool? stickyAuth = false,
    _i11.AndroidAuthMessages? androidAuthStrings =
        const _i11.AndroidAuthMessages(),
    _i11.IOSAuthMessages? iOSAuthStrings = const _i11.IOSAuthMessages(),
    bool? sensitiveTransaction = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #authenticateWithBiometrics,
          [],
          {
            #localizedReason: localizedReason,
            #useErrorDialogs: useErrorDialogs,
            #stickyAuth: stickyAuth,
            #androidAuthStrings: androidAuthStrings,
            #iOSAuthStrings: iOSAuthStrings,
            #sensitiveTransaction: sensitiveTransaction,
          },
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<bool> authenticate({
    required String? localizedReason,
    bool? useErrorDialogs = true,
    bool? stickyAuth = false,
    _i11.AndroidAuthMessages? androidAuthStrings =
        const _i11.AndroidAuthMessages(),
    _i11.IOSAuthMessages? iOSAuthStrings = const _i11.IOSAuthMessages(),
    bool? sensitiveTransaction = true,
    bool? biometricOnly = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [],
          {
            #localizedReason: localizedReason,
            #useErrorDialogs: useErrorDialogs,
            #stickyAuth: stickyAuth,
            #androidAuthStrings: androidAuthStrings,
            #iOSAuthStrings: iOSAuthStrings,
            #sensitiveTransaction: sensitiveTransaction,
            #biometricOnly: biometricOnly,
          },
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<bool> stopAuthentication() => (super.noSuchMethod(
        Invocation.method(
          #stopAuthentication,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<bool> isDeviceSupported() => (super.noSuchMethod(
        Invocation.method(
          #isDeviceSupported,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<List<_i10.BiometricType>> getAvailableBiometrics() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAvailableBiometrics,
          [],
        ),
        returnValue:
            _i8.Future<List<_i10.BiometricType>>.value(<_i10.BiometricType>[]),
      ) as _i8.Future<List<_i10.BiometricType>>);
}

/// A class which mocks [Biometrics].
///
/// See the documentation for Mockito's code generation for more information.
class MockBiometrics extends _i1.Mock implements _i12.Biometrics {
  MockBiometrics() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<bool> authenticate({
    required String? cancelButtonText,
    required String? localizedReason,
    required String? title,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #authenticate,
          [],
          {
            #cancelButtonText: cancelButtonText,
            #localizedReason: localizedReason,
            #title: title,
          },
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
}

/// A class which mocks [WalletsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletsService extends _i1.Mock implements _i13.WalletsService {
  @override
  _i8.Future<Map<String, _i13.WalletInfo>> get walletNames =>
      (super.noSuchMethod(
        Invocation.getter(#walletNames),
        returnValue: _i8.Future<Map<String, _i13.WalletInfo>>.value(
            <String, _i13.WalletInfo>{}),
      ) as _i8.Future<Map<String, _i13.WalletInfo>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i8.Future<bool> renameWallet({
    required String? from,
    required String? to,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #renameWallet,
          [],
          {
            #from: from,
            #to: to,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  Map<String, _i13.WalletInfo> fetchWalletsData() => (super.noSuchMethod(
        Invocation.method(
          #fetchWalletsData,
          [],
        ),
        returnValue: <String, _i13.WalletInfo>{},
      ) as Map<String, _i13.WalletInfo>);
  @override
  _i8.Future<void> addExistingStackWallet({
    required String? name,
    required String? walletId,
    required _i9.Coin? coin,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addExistingStackWallet,
          [],
          {
            #name: name,
            #walletId: walletId,
            #coin: coin,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<String?> addNewWallet({
    required String? name,
    required _i9.Coin? coin,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addNewWallet,
          [],
          {
            #name: name,
            #coin: coin,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);
  @override
  _i8.Future<List<String>> getFavoriteWalletIds() => (super.noSuchMethod(
        Invocation.method(
          #getFavoriteWalletIds,
          [],
        ),
        returnValue: _i8.Future<List<String>>.value(<String>[]),
      ) as _i8.Future<List<String>>);
  @override
  _i8.Future<void> saveFavoriteWalletIds(List<String>? walletIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveFavoriteWalletIds,
          [walletIds],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> addFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #addFavorite,
          [walletId],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> removeFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #removeFavorite,
          [walletId],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> moveFavorite({
    required int? fromIndex,
    required int? toIndex,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #moveFavorite,
          [],
          {
            #fromIndex: fromIndex,
            #toIndex: toIndex,
          },
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<bool> checkForDuplicate(String? name) => (super.noSuchMethod(
        Invocation.method(
          #checkForDuplicate,
          [name],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<String?> getWalletId(String? walletName) => (super.noSuchMethod(
        Invocation.method(
          #getWalletId,
          [walletName],
        ),
        returnValue: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);
  @override
  _i8.Future<bool> isMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #isMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<void> setMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #setMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<int> deleteWallet(
    String? name,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteWallet,
          [
            name,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i8.Future<int>.value(0),
      ) as _i8.Future<int>);
  @override
  _i8.Future<void> refreshWallets(bool? shouldNotifyListeners) =>
      (super.noSuchMethod(
        Invocation.method(
          #refreshWallets,
          [shouldNotifyListeners],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  void addListener(_i14.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i14.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [Manager].
///
/// See the documentation for Mockito's code generation for more information.
class MockManager extends _i1.Mock implements _i15.Manager {
  @override
  bool get isActiveWallet => (super.noSuchMethod(
        Invocation.getter(#isActiveWallet),
        returnValue: false,
      ) as bool);
  @override
  set isActiveWallet(bool? isActive) => super.noSuchMethod(
        Invocation.setter(
          #isActiveWallet,
          isActive,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.CoinServiceAPI get wallet => (super.noSuchMethod(
        Invocation.getter(#wallet),
        returnValue: _FakeCoinServiceAPI_1(
          this,
          Invocation.getter(#wallet),
        ),
      ) as _i3.CoinServiceAPI);
  @override
  bool get hasBackgroundRefreshListener => (super.noSuchMethod(
        Invocation.getter(#hasBackgroundRefreshListener),
        returnValue: false,
      ) as bool);
  @override
  _i9.Coin get coin => (super.noSuchMethod(
        Invocation.getter(#coin),
        returnValue: _i9.Coin.bitcoin,
      ) as _i9.Coin);
  @override
  bool get isRefreshing => (super.noSuchMethod(
        Invocation.getter(#isRefreshing),
        returnValue: false,
      ) as bool);
  @override
  bool get shouldAutoSync => (super.noSuchMethod(
        Invocation.getter(#shouldAutoSync),
        returnValue: false,
      ) as bool);
  @override
  set shouldAutoSync(bool? shouldAutoSync) => super.noSuchMethod(
        Invocation.setter(
          #shouldAutoSync,
          shouldAutoSync,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get isFavorite => (super.noSuchMethod(
        Invocation.getter(#isFavorite),
        returnValue: false,
      ) as bool);
  @override
  set isFavorite(bool? markFavorite) => super.noSuchMethod(
        Invocation.setter(
          #isFavorite,
          markFavorite,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i8.Future<_i4.FeeObject> get fees => (super.noSuchMethod(
        Invocation.getter(#fees),
        returnValue: _i8.Future<_i4.FeeObject>.value(_FakeFeeObject_2(
          this,
          Invocation.getter(#fees),
        )),
      ) as _i8.Future<_i4.FeeObject>);
  @override
  _i8.Future<int> get maxFee => (super.noSuchMethod(
        Invocation.getter(#maxFee),
        returnValue: _i8.Future<int>.value(0),
      ) as _i8.Future<int>);
  @override
  _i8.Future<String> get currentReceivingAddress => (super.noSuchMethod(
        Invocation.getter(#currentReceivingAddress),
        returnValue: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);
  @override
  _i5.Balance get balance => (super.noSuchMethod(
        Invocation.getter(#balance),
        returnValue: _FakeBalance_3(
          this,
          Invocation.getter(#balance),
        ),
      ) as _i5.Balance);
  @override
  _i8.Future<List<_i16.Transaction>> get transactions => (super.noSuchMethod(
        Invocation.getter(#transactions),
        returnValue:
            _i8.Future<List<_i16.Transaction>>.value(<_i16.Transaction>[]),
      ) as _i8.Future<List<_i16.Transaction>>);
  @override
  _i8.Future<List<_i16.UTXO>> get utxos => (super.noSuchMethod(
        Invocation.getter(#utxos),
        returnValue: _i8.Future<List<_i16.UTXO>>.value(<_i16.UTXO>[]),
      ) as _i8.Future<List<_i16.UTXO>>);
  @override
  set walletName(String? newName) => super.noSuchMethod(
        Invocation.setter(
          #walletName,
          newName,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get walletName => (super.noSuchMethod(
        Invocation.getter(#walletName),
        returnValue: '',
      ) as String);
  @override
  String get walletId => (super.noSuchMethod(
        Invocation.getter(#walletId),
        returnValue: '',
      ) as String);
  @override
  _i8.Future<List<String>> get mnemonic => (super.noSuchMethod(
        Invocation.getter(#mnemonic),
        returnValue: _i8.Future<List<String>>.value(<String>[]),
      ) as _i8.Future<List<String>>);
  @override
  _i8.Future<String?> get mnemonicPassphrase => (super.noSuchMethod(
        Invocation.getter(#mnemonicPassphrase),
        returnValue: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);
  @override
  bool get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: false,
      ) as bool);
  @override
  int get currentHeight => (super.noSuchMethod(
        Invocation.getter(#currentHeight),
        returnValue: 0,
      ) as int);
  @override
  bool get hasPaynymSupport => (super.noSuchMethod(
        Invocation.getter(#hasPaynymSupport),
        returnValue: false,
      ) as bool);
  @override
  bool get hasCoinControlSupport => (super.noSuchMethod(
        Invocation.getter(#hasCoinControlSupport),
        returnValue: false,
      ) as bool);
  @override
  bool get hasTokenSupport => (super.noSuchMethod(
        Invocation.getter(#hasTokenSupport),
        returnValue: false,
      ) as bool);
  @override
  bool get hasWhirlpoolSupport => (super.noSuchMethod(
        Invocation.getter(#hasWhirlpoolSupport),
        returnValue: false,
      ) as bool);
  @override
  int get rescanOnOpenVersion => (super.noSuchMethod(
        Invocation.getter(#rescanOnOpenVersion),
        returnValue: 0,
      ) as int);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i8.Future<void> updateNode(bool? shouldRefresh) => (super.noSuchMethod(
        Invocation.method(
          #updateNode,
          [shouldRefresh],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i8.Future<Map<String, dynamic>> prepareSend({
    required String? address,
    required int? amount,
    Map<String, dynamic>? args,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prepareSend,
          [],
          {
            #address: address,
            #satoshiAmount: amount,
            #args: args,
          },
        ),
        returnValue:
            _i8.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<String> confirmSend({required Map<String, dynamic>? txData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #confirmSend,
          [],
          {#txData: txData},
        ),
        returnValue: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);
  @override
  _i8.Future<void> refresh() => (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  bool validateAddress(String? address) => (super.noSuchMethod(
        Invocation.method(
          #validateAddress,
          [address],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i8.Future<bool> testNetworkConnection() => (super.noSuchMethod(
        Invocation.method(
          #testNetworkConnection,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<void> initializeNew() => (super.noSuchMethod(
        Invocation.method(
          #initializeNew,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> initializeExisting() => (super.noSuchMethod(
        Invocation.method(
          #initializeExisting,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> recoverFromMnemonic({
    required String? mnemonic,
    String? mnemonicPassphrase,
    required int? maxUnusedAddressGap,
    required int? maxNumberOfIndexesToCheck,
    required int? height,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #recoverFromMnemonic,
          [],
          {
            #mnemonic: mnemonic,
            #mnemonicPassphrase: mnemonicPassphrase,
            #maxUnusedAddressGap: maxUnusedAddressGap,
            #maxNumberOfIndexesToCheck: maxNumberOfIndexesToCheck,
            #height: height,
          },
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> exitCurrentWallet() => (super.noSuchMethod(
        Invocation.method(
          #exitCurrentWallet,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<void> fullRescan(
    int? maxUnusedAddressGap,
    int? maxNumberOfIndexesToCheck,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fullRescan,
          [
            maxUnusedAddressGap,
            maxNumberOfIndexesToCheck,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  _i8.Future<int> estimateFeeFor(
    int? satoshiAmount,
    int? feeRate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #estimateFeeFor,
          [
            satoshiAmount,
            feeRate,
          ],
        ),
        returnValue: _i8.Future<int>.value(0),
      ) as _i8.Future<int>);
  @override
  _i8.Future<bool> generateNewAddress() => (super.noSuchMethod(
        Invocation.method(
          #generateNewAddress,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
  @override
  _i8.Future<void> resetRescanOnOpen() => (super.noSuchMethod(
        Invocation.method(
          #resetRescanOnOpen,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
  @override
  void addListener(_i14.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i14.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
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
