// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/screen_tests/onboarding/backup_key_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:ui' as _i10;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/balance.dart' as _i4;
import 'package:stackwallet/models/isar/models/isar_models.dart' as _i9;
import 'package:stackwallet/models/models.dart' as _i3;
import 'package:stackwallet/services/coins/coin_service.dart' as _i2;
import 'package:stackwallet/services/coins/manager.dart' as _i6;
import 'package:stackwallet/utilities/amount/amount.dart' as _i5;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i7;

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

class _FakeCoinServiceAPI_0 extends _i1.SmartFake
    implements _i2.CoinServiceAPI {
  _FakeCoinServiceAPI_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFeeObject_1 extends _i1.SmartFake implements _i3.FeeObject {
  _FakeFeeObject_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBalance_2 extends _i1.SmartFake implements _i4.Balance {
  _FakeBalance_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAmount_3 extends _i1.SmartFake implements _i5.Amount {
  _FakeAmount_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Manager].
///
/// See the documentation for Mockito's code generation for more information.
class MockManager extends _i1.Mock implements _i6.Manager {
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
  _i2.CoinServiceAPI get wallet => (super.noSuchMethod(
        Invocation.getter(#wallet),
        returnValue: _FakeCoinServiceAPI_0(
          this,
          Invocation.getter(#wallet),
        ),
      ) as _i2.CoinServiceAPI);
  @override
  bool get hasBackgroundRefreshListener => (super.noSuchMethod(
        Invocation.getter(#hasBackgroundRefreshListener),
        returnValue: false,
      ) as bool);
  @override
  _i7.Coin get coin => (super.noSuchMethod(
        Invocation.getter(#coin),
        returnValue: _i7.Coin.bitcoin,
      ) as _i7.Coin);
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
  _i8.Future<_i3.FeeObject> get fees => (super.noSuchMethod(
        Invocation.getter(#fees),
        returnValue: _i8.Future<_i3.FeeObject>.value(_FakeFeeObject_1(
          this,
          Invocation.getter(#fees),
        )),
      ) as _i8.Future<_i3.FeeObject>);
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
  _i4.Balance get balance => (super.noSuchMethod(
        Invocation.getter(#balance),
        returnValue: _FakeBalance_2(
          this,
          Invocation.getter(#balance),
        ),
      ) as _i4.Balance);
  @override
  _i8.Future<List<_i9.Transaction>> get transactions => (super.noSuchMethod(
        Invocation.getter(#transactions),
        returnValue:
            _i8.Future<List<_i9.Transaction>>.value(<_i9.Transaction>[]),
      ) as _i8.Future<List<_i9.Transaction>>);
  @override
  _i8.Future<List<_i9.UTXO>> get utxos => (super.noSuchMethod(
        Invocation.getter(#utxos),
        returnValue: _i8.Future<List<_i9.UTXO>>.value(<_i9.UTXO>[]),
      ) as _i8.Future<List<_i9.UTXO>>);
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
  bool get hasOrdinalsSupport => (super.noSuchMethod(
        Invocation.getter(#hasOrdinalsSupport),
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
  bool get hasFusionSupport => (super.noSuchMethod(
        Invocation.getter(#hasFusionSupport),
        returnValue: false,
      ) as bool);
  @override
  int get rescanOnOpenVersion => (super.noSuchMethod(
        Invocation.getter(#rescanOnOpenVersion),
        returnValue: 0,
      ) as int);
  @override
  bool get hasXPub => (super.noSuchMethod(
        Invocation.getter(#hasXPub),
        returnValue: false,
      ) as bool);
  @override
  _i8.Future<String> get xpub => (super.noSuchMethod(
        Invocation.getter(#xpub),
        returnValue: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);
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
    required _i5.Amount? amount,
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
  _i8.Future<void> initializeNew(
          ({String mnemonicPassphrase, int wordCount})? data) =>
      (super.noSuchMethod(
        Invocation.method(
          #initializeNew,
          [data],
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
  _i8.Future<_i5.Amount> estimateFeeFor(
    _i5.Amount? amount,
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
        returnValue: _i8.Future<_i5.Amount>.value(_FakeAmount_3(
          this,
          Invocation.method(
            #estimateFeeFor,
            [
              amount,
              feeRate,
            ],
          ),
        )),
      ) as _i8.Future<_i5.Amount>);
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
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
