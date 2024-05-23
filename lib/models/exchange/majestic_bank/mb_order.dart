/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:decimal/decimal.dart';
import 'mb_object.dart';

enum MBOrderType {
  fixed,
  floating,
}

class MBOrder extends MBObject {
  MBOrder({
    required this.orderId,
    required this.fromCurrency,
    required this.fromAmount,
    required this.receiveCurrency,
    required this.receiveAmount,
    required this.address,
    required this.orderType,
    required this.expiration,
    required this.createdAt,
  });

  final String orderId;
  final String fromCurrency;
  final Decimal fromAmount;
  final String receiveCurrency;
  final String address;
  final Decimal receiveAmount;
  final MBOrderType orderType;

  ///     minutes
  final int expiration;

  final DateTime createdAt;

  bool isExpired() =>
      (DateTime.now().difference(createdAt) >= Duration(minutes: expiration));

  @override
  String toString() {
    // todo: full toString
    return orderId;
  }
}
