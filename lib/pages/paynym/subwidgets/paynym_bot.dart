/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stackwallet/networking/http.dart';
import 'package:stackwallet/services/tor_service.dart';
import 'package:stackwallet/utilities/prefs.dart';

class PayNymBot extends StatelessWidget {
  const PayNymBot({
    Key? key,
    required this.paymentCodeString,
    this.size = 60.0,
  }) : super(key: key);

  final String paymentCodeString;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        width: size,
        height: size,
        child: FutureBuilder<Uint8List>(
          future: _fetchImage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(snapshot.data!);
            } else if (snapshot.hasError) {
              return const Center(child: Icon(Icons.error));
            } else {
              return const Center(); // TODO [prio=low]: Make better loading indicator.
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List> _fetchImage() async {
    final HTTP client = HTTP();
    final Uri uri = Uri.parse("https://paynym.is/$paymentCodeString/avatar");

    final response = await client.get(
      url: uri,
      proxyInfo: Prefs.instance.useTor
          ? TorService.sharedInstance.getProxyInfo()
          : null,
    );

    if (response.code == 200) {
      return Uint8List.fromList(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
  }
}
