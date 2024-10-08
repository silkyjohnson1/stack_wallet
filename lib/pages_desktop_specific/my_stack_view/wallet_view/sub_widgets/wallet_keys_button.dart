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
import 'package:flutter_svg/svg.dart';
import 'unlock_wallet_keys_desktop.dart';
import '../../../../route_generator.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/text_styles.dart';

class WalletKeysButton extends StatelessWidget {
  const WalletKeysButton({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
      onPressed: () {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => Navigator(
            initialRoute: UnlockWalletKeysDesktop.routeName,
            onGenerateRoute: RouteGenerator.generateRoute,
            onGenerateInitialRoutes: (_, __) {
              return [
                RouteGenerator.generateRoute(
                  RouteSettings(
                    name: UnlockWalletKeysDesktop.routeName,
                    arguments: walletId,
                  ),
                ),
              ];
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 19,
          horizontal: 32,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.svg.key,
              width: 20,
              height: 20,
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .buttonTextSecondary,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              "Wallet keys",
              style: STextStyles.desktopMenuItemSelected(context),
            ),
          ],
        ),
      ),
    );
  }
}
