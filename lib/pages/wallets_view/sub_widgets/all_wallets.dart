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
import 'package:stackwallet/pages/add_wallet_views/add_wallet_view/add_wallet_view.dart';
import 'package:stackwallet/pages/wallets_view/sub_widgets/wallet_list_item.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/wallets/isar/providers/all_wallets_info_provider.dart';
import 'package:stackwallet/widgets/custom_buttons/blue_text_button.dart';

class AllWallets extends StatelessWidget {
  const AllWallets({Key? key}) : super(key: key);

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
                Navigator.of(context).pushNamed(AddWalletView.routeName);
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
