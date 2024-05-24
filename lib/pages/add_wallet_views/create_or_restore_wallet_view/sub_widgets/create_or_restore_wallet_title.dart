/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../wallets/crypto_currency/crypto_currency.dart';

class CreateRestoreWalletTitle extends StatelessWidget {
  const CreateRestoreWalletTitle({
    super.key,
    required this.coin,
    required this.isDesktop,
  });

  final CryptoCurrency coin;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Add ${coin.prettyName} wallet",
      textAlign: TextAlign.center,
      style: isDesktop
          ? STextStyles.desktopH2(context)
          : STextStyles.pageTitleH1(context),
    );
  }
}
