/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:io';

import 'util.dart';

class _LayoutSizing {
  const _LayoutSizing();

  double get circularBorderRadius => 8.0;
  double get checkboxBorderRadius => 4.0;

  double get standardPadding => 16.0;
}

abstract class Constants {
  static const size = _LayoutSizing();

  static void exchangeForExperiencedUsers(int count) {
    enableExchange =
        Util.isDesktop || Platform.isAndroid || count > 5 || !Platform.isIOS;
  }

  static bool enableExchange = Util.isDesktop || !Platform.isIOS;
  // just use enable exchange flag
  // static bool enableBuy = enableExchange;
  // // true; // true for development,

  static const int notificationsMax = 0xFFFFFFFF;
  static const Duration networkAliveTimerDuration = Duration(seconds: 10);

  // Enable Logger.print statements
  static const bool disableLogger = false;

  static const int currentDataVersion = 12;

  static const int rescanV1 = 1;

  static const Map<int, String> monthMapShort = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  static const Map<int, String> monthMap = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };
}
