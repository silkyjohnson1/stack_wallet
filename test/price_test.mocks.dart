// Mocks generated by Mockito 5.4.4 from annotations
// in stackwallet/test/price_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:convert' as _i5;
import 'dart:io' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/networking/http.dart' as _i2;

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

class _FakeResponse_0 extends _i1.SmartFake implements _i2.Response {
  _FakeResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HTTP].
///
/// See the documentation for Mockito's code generation for more information.
class MockHTTP extends _i1.Mock implements _i2.HTTP {
  MockHTTP() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i2.Response> get({
    required Uri? url,
    Map<String, String>? headers,
    required ({_i4.InternetAddress host, int port})? proxyInfo,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [],
          {
            #url: url,
            #headers: headers,
            #proxyInfo: proxyInfo,
          },
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #get,
            [],
            {
              #url: url,
              #headers: headers,
              #proxyInfo: proxyInfo,
            },
          ),
        )),
      ) as _i3.Future<_i2.Response>);
  @override
  _i3.Future<_i2.Response> post({
    required Uri? url,
    Map<String, String>? headers,
    Object? body,
    _i5.Encoding? encoding,
    required ({_i4.InternetAddress host, int port})? proxyInfo,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [],
          {
            #url: url,
            #headers: headers,
            #body: body,
            #encoding: encoding,
            #proxyInfo: proxyInfo,
          },
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #post,
            [],
            {
              #url: url,
              #headers: headers,
              #body: body,
              #encoding: encoding,
              #proxyInfo: proxyInfo,
            },
          ),
        )),
      ) as _i3.Future<_i2.Response>);
}
