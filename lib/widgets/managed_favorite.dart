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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../providers/db/main_db_provider.dart';
import '../themes/coin_icon_provider.dart';
import '../themes/stack_colors.dart';
import '../themes/theme_providers.dart';
import '../utilities/amount/amount.dart';
import '../utilities/amount/amount_formatter.dart';
import '../utilities/constants.dart';
import '../utilities/text_styles.dart';
import '../utilities/util.dart';
import '../wallets/crypto_currency/coins/firo.dart';
import '../wallets/isar/providers/wallet_info_provider.dart';
import 'custom_buttons/favorite_toggle.dart';
import 'rounded_white_container.dart';

class ManagedFavorite extends ConsumerStatefulWidget {
  const ManagedFavorite({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  ConsumerState<ManagedFavorite> createState() => _ManagedFavoriteCardState();
}

class _ManagedFavoriteCardState extends ConsumerState<ManagedFavorite> {
  @override
  Widget build(BuildContext context) {
    final walletId = widget.walletId;

    debugPrint("BUILD: $runtimeType with walletId $walletId");

    final isDesktop = Util.isDesktop;

    final coin = ref.watch(pWalletCoin(walletId));

    Amount total = ref.watch(pWalletBalance(walletId)).total;
    if (coin is Firo) {
      final balancePrivate =
          ref.watch(pWalletBalanceSecondary(walletId)).total +
              ref.watch(pWalletBalanceTertiary(walletId)).total;

      total += balancePrivate;
    }

    final isFavourite = ref.watch(pWalletIsFavourite(walletId));

    return RoundedWhiteContainer(
      padding: EdgeInsets.all(isDesktop ? 0 : 4.0),
      child: RawMaterialButton(
        onPressed: () {
          ref.read(pWalletInfo(walletId)).updateIsFavourite(
                !isFavourite,
                isar: ref.read(mainDBProvider).isar,
              );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
        ),
        child: Padding(
          padding: isDesktop
              ? const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                )
              : const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ref.watch(pCoinColor(coin)).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    Constants.size.circularBorderRadius,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 6 : 4),
                  child: SvgPicture.file(
                    File(
                      ref.watch(coinIconProvider(coin)),
                    ),
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              if (isDesktop)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ref.watch(pWalletName(walletId)),
                          style: STextStyles.titleBold12(context),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ref
                              .watch(
                                pAmountFormatter(coin),
                              )
                              .format(total),
                          style: STextStyles.itemSubtitle(context),
                        ),
                      ),
                      Text(
                        isFavourite
                            ? "Remove from favorites"
                            : "Add to favorites",
                        style:
                            STextStyles.desktopTextExtraSmall(context).copyWith(
                          color: isFavourite
                              ? Theme.of(context)
                                  .extension<StackColors>()!
                                  .accentColorRed
                              : Theme.of(context)
                                  .extension<StackColors>()!
                                  .buttonTextBorderless,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isDesktop)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.watch(pWalletName(walletId)),
                        style: STextStyles.titleBold12(context),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        ref
                            .watch(
                              pAmountFormatter(coin),
                            )
                            .format(total),
                        style: STextStyles.itemSubtitle(context),
                      ),
                    ],
                  ),
                ),
              if (!isDesktop)
                FavoriteToggle(
                  borderRadius: BorderRadius.circular(
                    Constants.size.circularBorderRadius,
                  ),
                  initialState: isFavourite,
                  onChanged: null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
