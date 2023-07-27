// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/notifications/notification_card_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:typed_data' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/db/isar/main_db.dart' as _i2;
import 'package:stackwallet/models/isar/stack_theme.dart' as _i4;
import 'package:stackwallet/themes/theme_service.dart' as _i3;

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

class _FakeMainDB_0 extends _i1.SmartFake implements _i2.MainDB {
  _FakeMainDB_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ThemeService].
///
/// See the documentation for Mockito's code generation for more information.
class MockThemeService extends _i1.Mock implements _i3.ThemeService {
  MockThemeService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MainDB get db => (super.noSuchMethod(
        Invocation.getter(#db),
        returnValue: _FakeMainDB_0(
          this,
          Invocation.getter(#db),
        ),
      ) as _i2.MainDB);
  @override
  List<_i4.StackTheme> get installedThemes => (super.noSuchMethod(
        Invocation.getter(#installedThemes),
        returnValue: <_i4.StackTheme>[],
      ) as List<_i4.StackTheme>);
  @override
  void init(_i2.MainDB? db) => super.noSuchMethod(
        Invocation.method(
          #init,
          [db],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i5.Future<void> install({required _i6.Uint8List? themeArchiveData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #install,
          [],
          {#themeArchiveData: themeArchiveData},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> remove({required String? themeId}) => (super.noSuchMethod(
        Invocation.method(
          #remove,
          [],
          {#themeId: themeId},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> checkDefaultThemesOnStartup() => (super.noSuchMethod(
        Invocation.method(
          #checkDefaultThemesOnStartup,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<bool> verifyInstalled({required String? themeId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #verifyInstalled,
          [],
          {#themeId: themeId},
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
  @override
  _i5.Future<List<_i3.StackThemeMetaData>> fetchThemes() => (super.noSuchMethod(
        Invocation.method(
          #fetchThemes,
          [],
        ),
        returnValue: _i5.Future<List<_i3.StackThemeMetaData>>.value(
            <_i3.StackThemeMetaData>[]),
      ) as _i5.Future<List<_i3.StackThemeMetaData>>);
  @override
  _i5.Future<_i6.Uint8List> fetchTheme(
          {required _i3.StackThemeMetaData? themeMetaData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchTheme,
          [],
          {#themeMetaData: themeMetaData},
        ),
        returnValue: _i5.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      ) as _i5.Future<_i6.Uint8List>);
  @override
  _i4.StackTheme? getTheme({required String? themeId}) =>
      (super.noSuchMethod(Invocation.method(
        #getTheme,
        [],
        {#themeId: themeId},
      )) as _i4.StackTheme?);
}
