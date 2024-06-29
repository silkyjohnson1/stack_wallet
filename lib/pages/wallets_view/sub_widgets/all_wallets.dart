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

import '../../../app_config.dart';
import '../../../models/add_wallet_list_entity/sub_classes/coin_entity.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/text_styles.dart';
import '../../../wallets/isar/providers/all_wallets_info_provider.dart';
import '../../../widgets/custom_buttons/blue_text_button.dart';
import '../../add_wallet_views/add_wallet_view/add_wallet_view.dart';
import '../../add_wallet_views/create_or_restore_wallet_view/create_or_restore_wallet_view.dart';
import '../wallets_overview.dart';
import 'wallet_list_item.dart';

class AllWallets extends StatelessWidget {
  const AllWallets({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "All wallets",
              style: STextStyles.itemSubtitle(context).copyWith(
                color: Theme.of(context).extension<StackColors>()!.textDark3,
              ),
            ),
            CustomTextButton(
              text: "Add new",
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
                Navigator.of(context).pushNamed(
                  route,
                  arguments: args,
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Consumer(
            builder: (_, ref, __) {
              final walletsByCoin = ref.watch(pAllWalletsInfoByCoin);

              if (AppConfig.isSingleCoinApp && walletsByCoin.isNotEmpty) {
                return WalletsOverview(
                  coin: AppConfig.coins.first,
                );
              }

              return ListView.builder(
                itemCount: walletsByCoin.length,
                itemBuilder: (builderContext, index) {
                  final coin = walletsByCoin[index].coin;
                  final int walletCount = walletsByCoin[index].wallets.length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: WalletListItem(
                      coin: coin,
                      walletCount: walletCount,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
