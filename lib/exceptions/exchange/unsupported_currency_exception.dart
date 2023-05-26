
/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackwallet/exceptions/exchange/exchange_exception.dart';

class UnsupportedCurrencyException extends ExchangeException {
  UnsupportedCurrencyException(super.message, super.type, this.currency);

  final String currency;
}
