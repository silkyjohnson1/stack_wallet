/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:convert';

import 'package:stackwallet/networking/http.dart';
import 'package:stackwallet/pages/settings_views/global_settings_view/manage_nodes_views/add_edit_node_view.dart';
import 'package:stackwallet/services/tor_service.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/prefs.dart';

Future<bool> _testEpicBoxNodeConnection(Uri uri) async {
  HTTP client = HTTP();
  try {
    final response = await client
        .get(
          url: uri,
          headers: {'Content-Type': 'application/json'},
          proxyInfo: Prefs.instance.useTor
              ? TorService.sharedInstance.proxyInfo
              : null,
        )
        .timeout(const Duration(milliseconds: 2000),
            onTimeout: () async => Response(utf8.encode('Error'), 408));

    final json = jsonDecode(response.body);

    if (response.code == 200 && json["node_version"] != null) {
      return true;
    } else {
      return false;
    }
  } catch (e, s) {
    Logging.instance.log("$e\n$s", level: LogLevel.Warning);
    return false;
  }
}

// returns node data with properly formatted host/url if successful, otherwise null
Future<NodeFormData?> testEpicNodeConnection(NodeFormData data) async {
  if (data.host == null || data.port == null || data.useSSL == null) {
    return null;
  }
  const String path_postfix = "/v1/version";

  if (data.host!.startsWith("https://")) {
    data.useSSL = true;
  } else if (data.host!.startsWith("http://")) {
    data.useSSL = false;
  } else {
    if (data.useSSL!) {
      data.host = "https://${data.host!}";
    } else {
      data.host = "http://${data.host!}";
    }
  }

  Uri uri = Uri.parse(data.host! + path_postfix);

  uri = uri.replace(port: data.port);

  try {
    if (await _testEpicBoxNodeConnection(uri)) {
      return data;
    } else {
      return null;
    }
  } catch (e, s) {
    Logging.instance.log("$e\n$s", level: LogLevel.Warning);
    return null;
  }
}
