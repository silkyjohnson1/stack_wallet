
/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:barcode_scan2/barcode_scan2.dart';

abstract class BarcodeScannerInterface {
  Future<ScanResult> scan({ScanOptions options = const ScanOptions()});
}

class BarcodeScannerWrapper implements BarcodeScannerInterface {
  const BarcodeScannerWrapper();

  @override
  Future<ScanResult> scan({ScanOptions options = const ScanOptions()}) async {
    try {
      final result = await BarcodeScanner.scan(options: options);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
