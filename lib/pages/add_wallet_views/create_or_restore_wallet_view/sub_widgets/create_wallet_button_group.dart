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

import 'package:flutter/material.dart';
import 'package:stackwallet/pages/add_wallet_views/name_your_wallet_view/name_your_wallet_view.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/enums/add_wallet_type_enum.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:tuple/tuple.dart';

class CreateWalletButtonGroup extends StatelessWidget {
  const CreateWalletButtonGroup({
    Key? key,
    required this.coin,
    required this.isDesktop,
  }) : super(key: key);

  final Coin coin;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
      children: [
        if (Platform.isAndroid || coin != Coin.wownero)
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: isDesktop ? 70 : 0,
              minWidth: isDesktop ? 480 : 0,
            ),
            child: TextButton(
              style: Theme.of(context)
                  .extension<StackColors>()!
                  .getPrimaryEnabledButtonStyle(context),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  NameYourWalletView.routeName,
                  arguments: Tuple2(
                    AddWalletType.New,
                    coin,
                  ),
                );
              },
              child: Text(
                "Create new wallet",
                style: isDesktop
                    ? STextStyles.desktopButtonEnabled(context)
                    : STextStyles.button(context),
              ),
            ),
          ),
        if (Platform.isAndroid || coin != Coin.wownero)
          SizedBox(
            height: isDesktop ? 16 : 12,
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: isDesktop ? 70 : 0,
            minWidth: isDesktop ? 480 : 0,
          ),
          child: TextButton(
            style: Theme.of(context)
                .extension<StackColors>()!
                .getSecondaryEnabledButtonStyle(context),
            onPressed: () {
              Navigator.of(context).pushNamed(
                NameYourWalletView.routeName,
                arguments: Tuple2(
                  AddWalletType.Restore,
                  coin,
                ),
              );
            },
            child: Text(
              "Restore wallet",
              style: isDesktop
                  ? STextStyles.desktopButtonSecondaryEnabled(context)
                  : STextStyles.button(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .accentColorDark),
            ),
          ),
        ),
      ],
    );
  }
}
