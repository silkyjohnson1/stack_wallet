// Mocks generated by Mockito 5.4.4 from annotations
// in stackwallet/test/screen_tests/address_book_view/subviews/add_address_book_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:ui' as _i7;

import 'package:barcode_scan2/barcode_scan2.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/isar/models/contact_entry.dart' as _i3;
import 'package:stackwallet/services/address_book_service.dart' as _i6;
import 'package:stackwallet/utilities/barcode_scanner_interface.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeScanResult_0 extends _i1.SmartFake implements _i2.ScanResult {
  _FakeScanResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeContactEntry_1 extends _i1.SmartFake implements _i3.ContactEntry {
  _FakeContactEntry_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BarcodeScannerWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockBarcodeScannerWrapper extends _i1.Mock
    implements _i4.BarcodeScannerWrapper {
  MockBarcodeScannerWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.ScanResult> scan(
          {_i2.ScanOptions? options = const _i2.ScanOptions()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #scan,
          [],
          {#options: options},
        ),
        returnValue: _i5.Future<_i2.ScanResult>.value(_FakeScanResult_0(
          this,
          Invocation.method(
            #scan,
            [],
            {#options: options},
          ),
        )),
      ) as _i5.Future<_i2.ScanResult>);
}

/// A class which mocks [AddressBookService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAddressBookService extends _i1.Mock
    implements _i6.AddressBookService {
  MockAddressBookService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i3.ContactEntry> get contacts => (super.noSuchMethod(
        Invocation.getter(#contacts),
        returnValue: <_i3.ContactEntry>[],
      ) as List<_i3.ContactEntry>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i3.ContactEntry getContactById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getContactById,
          [id],
        ),
        returnValue: _FakeContactEntry_1(
          this,
          Invocation.method(
            #getContactById,
            [id],
          ),
        ),
      ) as _i3.ContactEntry);
  @override
  _i5.Future<List<_i3.ContactEntry>> search(String? text) =>
      (super.noSuchMethod(
        Invocation.method(
          #search,
          [text],
        ),
        returnValue:
            _i5.Future<List<_i3.ContactEntry>>.value(<_i3.ContactEntry>[]),
      ) as _i5.Future<List<_i3.ContactEntry>>);
  @override
  bool matches(
    String? term,
    _i3.ContactEntry? contact,
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
  _i5.Future<bool> addContact(_i3.ContactEntry? contact) => (super.noSuchMethod(
        Invocation.method(
          #addContact,
          [contact],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<bool> editContact(_i3.ContactEntry? editedContact) =>
      (super.noSuchMethod(
        Invocation.method(
          #editContact,
          [editedContact],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<void> removeContact(String? id) => (super.noSuchMethod(
        Invocation.method(
          #removeContact,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
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
