import 'dart:convert';
import 'dart:io';

import 'package:stackwallet/utilities/logger.dart';

// WIP wrapper layer

abstract class HTTP {
  static Future<HttpClientResponse> get({
    required Uri url,
    Map<String, String>? headers,
    required bool routeOverTor,
  }) async {
    final httpClient = HttpClient();
    try {
      if (routeOverTor) {
        // TODO
        throw UnimplementedError();
      } else {
        final HttpClientRequest request = await httpClient.getUrl(
          url,
        );

        request.headers.clear();
        if (headers != null) {
          headers.forEach((key, value) => request.headers.add);
        }

        return request.close();
      }
    } catch (e, s) {
      Logging.instance.log(
        "HTTP.get() rethrew: $e\n$s",
        level: LogLevel.Info,
      );
      rethrow;
    } finally {
      httpClient.close(force: true);
    }
  }

  static Future<HttpClientResponse> post({
    required Uri url,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    required bool routeOverTor,
  }) async {
    final httpClient = HttpClient();
    try {
      if (routeOverTor) {
        // TODO
        throw UnimplementedError();
      } else {
        final HttpClientRequest request = await httpClient.postUrl(
          url,
        );

        request.headers.clear();

        if (headers != null) {
          headers.forEach((key, value) => request.headers.add);
        }

        request.write(body);

        return request.close();
      }
    } catch (e, s) {
      Logging.instance.log(
        "HTTP.post() rethrew: $e\n$s",
        level: LogLevel.Info,
      );
      rethrow;
    } finally {
      httpClient.close(force: true);
    }
  }
}
