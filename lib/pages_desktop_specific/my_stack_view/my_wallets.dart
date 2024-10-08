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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_config.dart';
import '../../models/add_wallet_list_entity/sub_classes/coin_entity.dart';
import '../../pages/add_wallet_views/add_wallet_view/add_wallet_view.dart';
import '../../pages/add_wallet_views/create_or_restore_wallet_view/create_or_restore_wallet_view.dart';
import '../../pages/wallets_view/wallets_overview.dart';
import '../../providers/providers.dart';
import '../../themes/stack_colors.dart';
import '../../utilities/text_styles.dart';
import '../../widgets/custom_buttons/blue_text_button.dart';
import 'desktop_favorite_wallets.dart';
import 'wallet_summary_table.dart';

class MyWallets extends ConsumerStatefulWidget {
  const MyWallets({super.key});

  @override
  ConsumerState<MyWallets> createState() => _MyWalletsState();
}

class _MyWalletsState extends ConsumerState<MyWallets> {
  @override
  Widget build(BuildContext context) {
    final showFavorites = ref.watch(
      prefsChangeNotifierProvider.select((value) => value.showFavoriteWallets),
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 14,
        right: 14,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showFavorites)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: DesktopFavoriteWallets(),
            ),
          Padding(
            padding: const EdgeInsets.all(
              10,
            ),
            child: Row(
              children: [
                Text(
                  "All wallets",
                  style: STextStyles.desktopTextExtraSmall(context).copyWith(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textFieldActiveSearchIconRight,
                  ),
                ),
                const Spacer(),
                CustomTextButton(
                  text: "Add new wallet",
                  onTap: () {
                    final String route;
                    final Object? args;
                    if (AppConfig.isSingleCoinApp) {
                      route = CreateOrRestoreWalletView.routeName;
                      args = CoinEntity(AppConfig.coins.first);
                    } else {
                      route = AddWalletView.routeName;
                      args = null;
                    }

                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(
                      route,
                      arguments: args,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: AppConfig.isSingleCoinApp
                ? WalletsOverview(
                    coin: AppConfig.coins.first,
                    navigatorState: Navigator.of(context),
                    overrideSimpleWalletCardPopPreviousValueWith: false,
                  )
                : const WalletSummaryTable(),
          ),
        ],
      ),
    );
  }
}
