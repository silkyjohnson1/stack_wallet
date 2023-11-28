// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/widget_tests/table_view/table_view_row_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i11;
import 'dart:typed_data' as _i20;
import 'dart:ui' as _i17;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/db/isar/main_db.dart' as _i3;
import 'package:stackwallet/models/balance.dart' as _i8;
import 'package:stackwallet/models/isar/models/isar_models.dart' as _i22;
import 'package:stackwallet/models/isar/stack_theme.dart' as _i19;
import 'package:stackwallet/models/paymint/fee_object_model.dart' as _i7;
import 'package:stackwallet/networking/http.dart' as _i6;
import 'package:stackwallet/services/coins/coin_service.dart' as _i21;
import 'package:stackwallet/services/node_service.dart' as _i2;
import 'package:stackwallet/services/wallets.dart' as _i10;
import 'package:stackwallet/services/wallets_service.dart' as _i15;
import 'package:stackwallet/themes/theme_service.dart' as _i18;
import 'package:stackwallet/utilities/amount/amount.dart' as _i9;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i16;
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart'
    as _i13;
import 'package:stackwallet/utilities/prefs.dart' as _i14;
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart'
    as _i4;
import 'package:stackwallet/wallets/isar/models/wallet_info.dart' as _i12;
import 'package:stackwallet/wallets/wallet/wallet.dart' as _i5;

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

class _FakeHTTP_3 extends _i1.SmartFake implements _i6.HTTP {
  _FakeHTTP_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFeeObject_4 extends _i1.SmartFake implements _i7.FeeObject {
  _FakeFeeObject_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBalance_5 extends _i1.SmartFake implements _i8.Balance {
  _FakeBalance_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAmount_6 extends _i1.SmartFake implements _i9.Amount {
  _FakeAmount_6(
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
class MockWallets extends _i1.Mock implements _i10.Wallets {
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
    _i12.WalletInfo? info,
    _i13.SecureStorageInterface? secureStorage,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteWallet,
          [
            info,
            secureStorage,
          ],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> load(
    _i14.Prefs? prefs,
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
    _i14.Prefs? prefs,
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

/// A class which mocks [WalletsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletsService extends _i1.Mock implements _i15.WalletsService {
  MockWalletsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i11.Future<Map<String, _i15.WalletInfo>> get walletNames =>
      (super.noSuchMethod(
        Invocation.getter(#walletNames),
        returnValue: _i11.Future<Map<String, _i15.WalletInfo>>.value(
            <String, _i15.WalletInfo>{}),
      ) as _i11.Future<Map<String, _i15.WalletInfo>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i11.Future<bool> renameWallet({
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
        returnValue: _i11.Future<bool>.value(false),
      ) as _i11.Future<bool>);
  @override
  Map<String, _i15.WalletInfo> fetchWalletsData() => (super.noSuchMethod(
        Invocation.method(
          #fetchWalletsData,
          [],
        ),
        returnValue: <String, _i15.WalletInfo>{},
      ) as Map<String, _i15.WalletInfo>);
  @override
  _i11.Future<void> addExistingStackWallet({
    required String? name,
    required String? walletId,
    required _i16.Coin? coin,
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
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<String?> addNewWallet({
    required String? name,
    required _i16.Coin? coin,
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
        returnValue: _i11.Future<String?>.value(),
      ) as _i11.Future<String?>);
  @override
  _i11.Future<List<String>> getFavoriteWalletIds() => (super.noSuchMethod(
        Invocation.method(
          #getFavoriteWalletIds,
          [],
        ),
        returnValue: _i11.Future<List<String>>.value(<String>[]),
      ) as _i11.Future<List<String>>);
  @override
  _i11.Future<void> saveFavoriteWalletIds(List<String>? walletIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveFavoriteWalletIds,
          [walletIds],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> addFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #addFavorite,
          [walletId],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> removeFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #removeFavorite,
          [walletId],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> moveFavorite({
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
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<bool> checkForDuplicate(String? name) => (super.noSuchMethod(
        Invocation.method(
          #checkForDuplicate,
          [name],
        ),
        returnValue: _i11.Future<bool>.value(false),
      ) as _i11.Future<bool>);
  @override
  _i11.Future<String?> getWalletId(String? walletName) => (super.noSuchMethod(
        Invocation.method(
          #getWalletId,
          [walletName],
        ),
        returnValue: _i11.Future<String?>.value(),
      ) as _i11.Future<String?>);
  @override
  _i11.Future<bool> isMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #isMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i11.Future<bool>.value(false),
      ) as _i11.Future<bool>);
  @override
  _i11.Future<void> setMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #setMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<int> deleteWallet(
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
        returnValue: _i11.Future<int>.value(0),
      ) as _i11.Future<int>);
  @override
  _i11.Future<void> refreshWallets(bool? shouldNotifyListeners) =>
      (super.noSuchMethod(
        Invocation.method(
          #refreshWallets,
          [shouldNotifyListeners],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  void addListener(_i17.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i17.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [ThemeService].
///
/// See the documentation for Mockito's code generation for more information.
class MockThemeService extends _i1.Mock implements _i18.ThemeService {
  MockThemeService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.HTTP get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeHTTP_3(
          this,
          Invocation.getter(#client),
        ),
      ) as _i6.HTTP);
  @override
  set client(_i6.HTTP? _client) => super.noSuchMethod(
        Invocation.setter(
          #client,
          _client,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.MainDB get db => (super.noSuchMethod(
        Invocation.getter(#db),
        returnValue: _FakeMainDB_1(
          this,
          Invocation.getter(#db),
        ),
      ) as _i3.MainDB);
  @override
  List<_i19.StackTheme> get installedThemes => (super.noSuchMethod(
        Invocation.getter(#installedThemes),
        returnValue: <_i19.StackTheme>[],
      ) as List<_i19.StackTheme>);
  @override
  void init(_i3.MainDB? db) => super.noSuchMethod(
        Invocation.method(
          #init,
          [db],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i11.Future<void> install({required _i20.Uint8List? themeArchiveData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #install,
          [],
          {#themeArchiveData: themeArchiveData},
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> remove({required String? themeId}) => (super.noSuchMethod(
        Invocation.method(
          #remove,
          [],
          {#themeId: themeId},
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> checkDefaultThemesOnStartup() => (super.noSuchMethod(
        Invocation.method(
          #checkDefaultThemesOnStartup,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<bool> verifyInstalled({required String? themeId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #verifyInstalled,
          [],
          {#themeId: themeId},
        ),
        returnValue: _i11.Future<bool>.value(false),
      ) as _i11.Future<bool>);
  @override
  _i11.Future<List<_i18.StackThemeMetaData>> fetchThemes() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchThemes,
          [],
        ),
        returnValue: _i11.Future<List<_i18.StackThemeMetaData>>.value(
            <_i18.StackThemeMetaData>[]),
      ) as _i11.Future<List<_i18.StackThemeMetaData>>);
  @override
  _i11.Future<_i20.Uint8List> fetchTheme(
          {required _i18.StackThemeMetaData? themeMetaData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchTheme,
          [],
          {#themeMetaData: themeMetaData},
        ),
        returnValue: _i11.Future<_i20.Uint8List>.value(_i20.Uint8List(0)),
      ) as _i11.Future<_i20.Uint8List>);
  @override
  _i19.StackTheme? getTheme({required String? themeId}) =>
      (super.noSuchMethod(Invocation.method(
        #getTheme,
        [],
        {#themeId: themeId},
      )) as _i19.StackTheme?);
}

/// A class which mocks [CoinServiceAPI].
///
/// See the documentation for Mockito's code generation for more information.
class MockCoinServiceAPI extends _i1.Mock implements _i21.CoinServiceAPI {
  @override
  set onIsActiveWalletChanged(void Function(bool)? _onIsActiveWalletChanged) =>
      super.noSuchMethod(
        Invocation.setter(
          #onIsActiveWalletChanged,
          _onIsActiveWalletChanged,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i16.Coin get coin => (super.noSuchMethod(
        Invocation.getter(#coin),
        returnValue: _i16.Coin.bitcoin,
      ) as _i16.Coin);
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
  _i11.Future<_i7.FeeObject> get fees => (super.noSuchMethod(
        Invocation.getter(#fees),
        returnValue: _i11.Future<_i7.FeeObject>.value(_FakeFeeObject_4(
          this,
          Invocation.getter(#fees),
        )),
      ) as _i11.Future<_i7.FeeObject>);
  @override
  _i11.Future<int> get maxFee => (super.noSuchMethod(
        Invocation.getter(#maxFee),
        returnValue: _i11.Future<int>.value(0),
      ) as _i11.Future<int>);
  @override
  _i11.Future<String> get currentReceivingAddress => (super.noSuchMethod(
        Invocation.getter(#currentReceivingAddress),
        returnValue: _i11.Future<String>.value(''),
      ) as _i11.Future<String>);
  @override
  _i8.Balance get balance => (super.noSuchMethod(
        Invocation.getter(#balance),
        returnValue: _FakeBalance_5(
          this,
          Invocation.getter(#balance),
        ),
      ) as _i8.Balance);
  @override
  _i11.Future<List<_i22.Transaction>> get transactions => (super.noSuchMethod(
        Invocation.getter(#transactions),
        returnValue:
            _i11.Future<List<_i22.Transaction>>.value(<_i22.Transaction>[]),
      ) as _i11.Future<List<_i22.Transaction>>);
  @override
  _i11.Future<List<_i22.UTXO>> get utxos => (super.noSuchMethod(
        Invocation.getter(#utxos),
        returnValue: _i11.Future<List<_i22.UTXO>>.value(<_i22.UTXO>[]),
      ) as _i11.Future<List<_i22.UTXO>>);
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
  _i11.Future<List<String>> get mnemonic => (super.noSuchMethod(
        Invocation.getter(#mnemonic),
        returnValue: _i11.Future<List<String>>.value(<String>[]),
      ) as _i11.Future<List<String>>);
  @override
  _i11.Future<String?> get mnemonicString => (super.noSuchMethod(
        Invocation.getter(#mnemonicString),
        returnValue: _i11.Future<String?>.value(),
      ) as _i11.Future<String?>);
  @override
  _i11.Future<String?> get mnemonicPassphrase => (super.noSuchMethod(
        Invocation.getter(#mnemonicPassphrase),
        returnValue: _i11.Future<String?>.value(),
      ) as _i11.Future<String?>);
  @override
  bool get hasCalledExit => (super.noSuchMethod(
        Invocation.getter(#hasCalledExit),
        returnValue: false,
      ) as bool);
  @override
  bool get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: false,
      ) as bool);
  @override
  int get storedChainHeight => (super.noSuchMethod(
        Invocation.getter(#storedChainHeight),
        returnValue: 0,
      ) as int);
  @override
  _i11.Future<Map<String, dynamic>> prepareSend({
    required String? address,
    required _i9.Amount? amount,
    Map<String, dynamic>? args,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prepareSend,
          [],
          {
            #address: address,
            #amount: amount,
            #args: args,
          },
        ),
        returnValue:
            _i11.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i11.Future<Map<String, dynamic>>);
  @override
  _i11.Future<String> confirmSend({required Map<String, dynamic>? txData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #confirmSend,
          [],
          {#txData: txData},
        ),
        returnValue: _i11.Future<String>.value(''),
      ) as _i11.Future<String>);
  @override
  _i11.Future<void> refresh() => (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> updateNode(bool? shouldRefresh) => (super.noSuchMethod(
        Invocation.method(
          #updateNode,
          [shouldRefresh],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  bool validateAddress(String? address) => (super.noSuchMethod(
        Invocation.method(
          #validateAddress,
          [address],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i11.Future<bool> testNetworkConnection() => (super.noSuchMethod(
        Invocation.method(
          #testNetworkConnection,
          [],
        ),
        returnValue: _i11.Future<bool>.value(false),
      ) as _i11.Future<bool>);
  @override
  _i11.Future<void> recoverFromMnemonic({
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
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> initializeNew(
          ({String mnemonicPassphrase, int wordCount})? data) =>
      (super.noSuchMethod(
        Invocation.method(
          #initializeNew,
          [data],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> initializeExisting() => (super.noSuchMethod(
        Invocation.method(
          #initializeExisting,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> exit() => (super.noSuchMethod(
        Invocation.method(
          #exit,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<void> fullRescan(
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
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
  @override
  _i11.Future<_i9.Amount> estimateFeeFor(
    _i9.Amount? amount,
    int? feeRate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #estimateFeeFor,
          [
            amount,
            feeRate,
          ],
        ),
        returnValue: _i11.Future<_i9.Amount>.value(_FakeAmount_6(
          this,
          Invocation.method(
            #estimateFeeFor,
            [
              amount,
              feeRate,
            ],
          ),
        )),
      ) as _i11.Future<_i9.Amount>);
  @override
  _i11.Future<bool> generateNewAddress() => (super.noSuchMethod(
        Invocation.method(
          #generateNewAddress,
          [],
        ),
        returnValue: _i11.Future<bool>.value(false),
      ) as _i11.Future<bool>);
  @override
  _i11.Future<void> updateSentCachedTxData(Map<String, dynamic>? txData) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateSentCachedTxData,
          [txData],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
}
