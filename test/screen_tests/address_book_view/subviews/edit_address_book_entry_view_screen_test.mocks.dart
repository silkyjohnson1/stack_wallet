// Mocks generated by Mockito 5.3.2 from annotations
// in stackwallet/test/screen_tests/address_book_view/subviews/edit_address_book_entry_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:ui' as _i8;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/balance.dart' as _i5;
import 'package:stackwallet/models/contact.dart' as _i2;
import 'package:stackwallet/models/isar/models/isar_models.dart' as _i11;
import 'package:stackwallet/models/models.dart' as _i4;
import 'package:stackwallet/services/address_book_service.dart' as _i6;
import 'package:stackwallet/services/coins/coin_service.dart' as _i3;
import 'package:stackwallet/services/coins/manager.dart' as _i9;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i10;

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

class _FakeContact_0 extends _i1.SmartFake implements _i2.Contact {
  _FakeContact_0(
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

/// A class which mocks [AddressBookService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAddressBookService extends _i1.Mock
    implements _i6.AddressBookService {
  @override
  List<_i2.Contact> get contacts => (super.noSuchMethod(
        Invocation.getter(#contacts),
        returnValue: <_i2.Contact>[],
      ) as List<_i2.Contact>);
  @override
  _i7.Future<List<_i2.Contact>> get addressBookEntries => (super.noSuchMethod(
        Invocation.getter(#addressBookEntries),
        returnValue: _i7.Future<List<_i2.Contact>>.value(<_i2.Contact>[]),
      ) as _i7.Future<List<_i2.Contact>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i2.Contact getContactById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getContactById,
          [id],
        ),
        returnValue: _FakeContact_0(
          this,
          Invocation.method(
            #getContactById,
            [id],
          ),
        ),
      ) as _i2.Contact);
  @override
  _i7.Future<List<_i2.Contact>> search(String? text) => (super.noSuchMethod(
        Invocation.method(
          #search,
          [text],
        ),
        returnValue: _i7.Future<List<_i2.Contact>>.value(<_i2.Contact>[]),
      ) as _i7.Future<List<_i2.Contact>>);
  @override
  bool matches(
    String? term,
    _i2.Contact? contact,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #matches,
          [
            term,
            contact,
          ],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i7.Future<bool> addContact(_i2.Contact? contact) => (super.noSuchMethod(
        Invocation.method(
          #addContact,
          [contact],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<bool> editContact(_i2.Contact? editedContact) =>
      (super.noSuchMethod(
        Invocation.method(
          #editContact,
          [editedContact],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<void> removeContact(String? id) => (super.noSuchMethod(
        Invocation.method(
          #removeContact,
          [id],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void addListener(_i8.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i8.VoidCallback? listener) => super.noSuchMethod(
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
class MockManager extends _i1.Mock implements _i9.Manager {
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
  _i10.Coin get coin => (super.noSuchMethod(
        Invocation.getter(#coin),
        returnValue: _i10.Coin.bitcoin,
      ) as _i10.Coin);
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
  _i7.Future<_i4.FeeObject> get fees => (super.noSuchMethod(
        Invocation.getter(#fees),
        returnValue: _i7.Future<_i4.FeeObject>.value(_FakeFeeObject_2(
          this,
          Invocation.getter(#fees),
        )),
      ) as _i7.Future<_i4.FeeObject>);
  @override
  _i7.Future<int> get maxFee => (super.noSuchMethod(
        Invocation.getter(#maxFee),
        returnValue: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);
  @override
  _i7.Future<String> get currentReceivingAddress => (super.noSuchMethod(
        Invocation.getter(#currentReceivingAddress),
        returnValue: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
  @override
  _i5.Balance get balance => (super.noSuchMethod(
        Invocation.getter(#balance),
        returnValue: _FakeBalance_3(
          this,
          Invocation.getter(#balance),
        ),
      ) as _i5.Balance);
  @override
  _i7.Future<List<_i11.Transaction>> get transactions => (super.noSuchMethod(
        Invocation.getter(#transactions),
        returnValue:
            _i7.Future<List<_i11.Transaction>>.value(<_i11.Transaction>[]),
      ) as _i7.Future<List<_i11.Transaction>>);
  @override
  _i7.Future<List<_i11.UTXO>> get utxos => (super.noSuchMethod(
        Invocation.getter(#utxos),
        returnValue: _i7.Future<List<_i11.UTXO>>.value(<_i11.UTXO>[]),
      ) as _i7.Future<List<_i11.UTXO>>);
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
  _i7.Future<List<String>> get mnemonic => (super.noSuchMethod(
        Invocation.getter(#mnemonic),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);
  @override
  _i7.Future<String?> get mnemonicPassphrase => (super.noSuchMethod(
        Invocation.getter(#mnemonicPassphrase),
        returnValue: _i7.Future<String?>.value(),
      ) as _i7.Future<String?>);
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
  _i7.Future<void> updateNode(bool? shouldRefresh) => (super.noSuchMethod(
        Invocation.method(
          #updateNode,
          [shouldRefresh],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i7.Future<Map<String, dynamic>> prepareSend({
    required String? address,
    required int? satoshiAmount,
    Map<String, dynamic>? args,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prepareSend,
          [],
          {
            #address: address,
            #satoshiAmount: satoshiAmount,
            #args: args,
          },
        ),
        returnValue:
            _i7.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i7.Future<Map<String, dynamic>>);
  @override
  _i7.Future<String> confirmSend({required Map<String, dynamic>? txData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #confirmSend,
          [],
          {#txData: txData},
        ),
        returnValue: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
  @override
  _i7.Future<void> refresh() => (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  bool validateAddress(String? address) => (super.noSuchMethod(
        Invocation.method(
          #validateAddress,
          [address],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i7.Future<bool> testNetworkConnection() => (super.noSuchMethod(
        Invocation.method(
          #testNetworkConnection,
          [],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<void> initializeNew() => (super.noSuchMethod(
        Invocation.method(
          #initializeNew,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> initializeExisting() => (super.noSuchMethod(
        Invocation.method(
          #initializeExisting,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> recoverFromMnemonic({
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> exitCurrentWallet() => (super.noSuchMethod(
        Invocation.method(
          #exitCurrentWallet,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> fullRescan(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<int> estimateFeeFor(
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
        returnValue: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);
  @override
  _i7.Future<bool> generateNewAddress() => (super.noSuchMethod(
        Invocation.method(
          #generateNewAddress,
          [],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<void> resetRescanOnOpen() => (super.noSuchMethod(
        Invocation.method(
          #resetRescanOnOpen,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void addListener(_i8.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i8.VoidCallback? listener) => super.noSuchMethod(
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
