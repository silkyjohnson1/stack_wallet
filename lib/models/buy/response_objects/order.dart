/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'quote.dart';

class SimplexOrder {
  final SimplexQuote quote;

  late final String paymentId;
  late final String orderId;
  late final String userId;
  // TODO remove after userIds are sourced from isar/storage

  SimplexOrder({
    required this.quote,
    required this.paymentId,
    required this.orderId,
    required this.userId,
  });
}
