/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/isar/stack_theme.dart';
import 'package:stackwallet/themes/theme_providers.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

final coinCardProvider = Provider.family<String?, Coin>((ref, coin) {
  final assets = ref.watch(themeAssetsProvider);

  if (assets is ThemeAssetsV3) {
    return assets.coinCardImages?[coin.mainNetVersion];
  } else {
    return null;
  }
});
