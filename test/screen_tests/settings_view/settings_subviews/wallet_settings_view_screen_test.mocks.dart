// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/screen_tests/settings_view/settings_subviews/wallet_settings_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i10;

import 'package:local_auth/auth_strings.dart' as _i7;
import 'package:local_auth/local_auth.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/electrumx_rpc/cached_electrumx_client.dart' as _i3;
import 'package:stackwallet/electrumx_rpc/electrumx_client.dart' as _i2;
import 'package:stackwallet/services/wallets_service.dart' as _i9;
import 'package:stackwallet/utilities/biometrics.dart' as _i8;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i5;

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

class _FakeElectrumXClient_0 extends _i1.SmartFake
    implements _i2.ElectrumXClient {
  _FakeElectrumXClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CachedElectrumXClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockCachedElectrumXClient extends _i1.Mock
    implements _i3.CachedElectrumXClient {
  MockCachedElectrumXClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ElectrumXClient get electrumXClient => (super.noSuchMethod(
        Invocation.getter(#electrumXClient),
        returnValue: _FakeElectrumXClient_0(
          this,
          Invocation.getter(#electrumXClient),
        ),
      ) as _i2.ElectrumXClient);
  @override
  _i4.Future<Map<String, dynamic>> getAnonymitySet({
    required String? groupId,
    String? blockhash = r'',
    required _i5.Coin? coin,
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
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);
  @override
  _i4.Future<Map<String, dynamic>> getSparkAnonymitySet({
    required String? groupId,
    String? blockhash = r'',
    required _i5.Coin? coin,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSparkAnonymitySet,
          [],
          {
            #groupId: groupId,
            #blockhash: blockhash,
            #coin: coin,
          },
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);
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
  _i4.Future<Map<String, dynamic>> getTransaction({
    required String? txHash,
    required _i5.Coin? coin,
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
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);
  @override
  _i4.Future<List<String>> getUsedCoinSerials({
    required _i5.Coin? coin,
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
        returnValue: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);
  @override
  _i4.Future<Set<String>> getSparkUsedCoinsTags({required _i5.Coin? coin}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSparkUsedCoinsTags,
          [],
          {#coin: coin},
        ),
        returnValue: _i4.Future<Set<String>>.value(<String>{}),
      ) as _i4.Future<Set<String>>);
  @override
  _i4.Future<void> clearSharedTransactionCache({required _i5.Coin? coin}) =>
      (super.noSuchMethod(
        Invocation.method(
          #clearSharedTransactionCache,
          [],
          {#coin: coin},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [LocalAuthentication].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalAuthentication extends _i1.Mock
    implements _i6.LocalAuthentication {
  MockLocalAuthentication() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get canCheckBiometrics => (super.noSuchMethod(
        Invocation.getter(#canCheckBiometrics),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> authenticateWithBiometrics({
    required String? localizedReason,
    bool? useErrorDialogs = true,
    bool? stickyAuth = false,
    _i7.AndroidAuthMessages? androidAuthStrings =
        const _i7.AndroidAuthMessages(),
    _i7.IOSAuthMessages? iOSAuthStrings = const _i7.IOSAuthMessages(),
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
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> authenticate({
    required String? localizedReason,
    bool? useErrorDialogs = true,
    bool? stickyAuth = false,
    _i7.AndroidAuthMessages? androidAuthStrings =
        const _i7.AndroidAuthMessages(),
    _i7.IOSAuthMessages? iOSAuthStrings = const _i7.IOSAuthMessages(),
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
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> stopAuthentication() => (super.noSuchMethod(
        Invocation.method(
          #stopAuthentication,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> isDeviceSupported() => (super.noSuchMethod(
        Invocation.method(
          #isDeviceSupported,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<List<_i6.BiometricType>> getAvailableBiometrics() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAvailableBiometrics,
          [],
        ),
        returnValue:
            _i4.Future<List<_i6.BiometricType>>.value(<_i6.BiometricType>[]),
      ) as _i4.Future<List<_i6.BiometricType>>);
}

/// A class which mocks [Biometrics].
///
/// See the documentation for Mockito's code generation for more information.
class MockBiometrics extends _i1.Mock implements _i8.Biometrics {
  MockBiometrics() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> authenticate({
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
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}

/// A class which mocks [WalletsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletsService extends _i1.Mock implements _i9.WalletsService {
  @override
  _i4.Future<Map<String, _i9.WalletInfo>> get walletNames =>
      (super.noSuchMethod(
        Invocation.getter(#walletNames),
        returnValue: _i4.Future<Map<String, _i9.WalletInfo>>.value(
            <String, _i9.WalletInfo>{}),
      ) as _i4.Future<Map<String, _i9.WalletInfo>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i4.Future<bool> renameWallet({
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
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  Map<String, _i9.WalletInfo> fetchWalletsData() => (super.noSuchMethod(
        Invocation.method(
          #fetchWalletsData,
          [],
        ),
        returnValue: <String, _i9.WalletInfo>{},
      ) as Map<String, _i9.WalletInfo>);
  @override
  _i4.Future<void> addExistingStackWallet({
    required String? name,
    required String? walletId,
    required _i5.Coin? coin,
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<String?> addNewWallet({
    required String? name,
    required _i5.Coin? coin,
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
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);
  @override
  _i4.Future<List<String>> getFavoriteWalletIds() => (super.noSuchMethod(
        Invocation.method(
          #getFavoriteWalletIds,
          [],
        ),
        returnValue: _i4.Future<List<String>>.value(<String>[]),
      ) as _i4.Future<List<String>>);
  @override
  _i4.Future<void> saveFavoriteWalletIds(List<String>? walletIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveFavoriteWalletIds,
          [walletIds],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> addFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #addFavorite,
          [walletId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> removeFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #removeFavorite,
          [walletId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> moveFavorite({
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<bool> checkForDuplicate(String? name) => (super.noSuchMethod(
        Invocation.method(
          #checkForDuplicate,
          [name],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<String?> getWalletId(String? walletName) => (super.noSuchMethod(
        Invocation.method(
          #getWalletId,
          [walletName],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);
  @override
  _i4.Future<bool> isMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #isMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<void> setMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #setMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<int> deleteWallet(
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
        returnValue: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);
  @override
  _i4.Future<void> refreshWallets(bool? shouldNotifyListeners) =>
      (super.noSuchMethod(
        Invocation.method(
          #refreshWallets,
          [shouldNotifyListeners],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  void addListener(_i10.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i10.VoidCallback? listener) => super.noSuchMethod(
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
