/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'secure_store_provider.dart';
import '../../services/node_service.dart';

int _count = 0;
final nodeServiceChangeNotifierProvider =
    ChangeNotifierProvider<NodeService>((ref) {
  if (kDebugMode) {
    _count++;
  }

  return NodeService(secureStorageInterface: ref.read(secureStoreProvider));
});
