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

class MBOrderCalculation extends MBObject {
  MBOrderCalculation({
    required this.fromCurrency,
    required this.fromAmount,
    required this.receiveCurrency,
    required this.receiveAmount,
  });

  final String fromCurrency;
  final Decimal fromAmount;
  final String receiveCurrency;
  final Decimal receiveAmount;

  @override
  String toString() {
    return "MBOrderCalculation: { $fromCurrency: $fromAmount, $receiveCurrency: $receiveAmount }";
  }
}
