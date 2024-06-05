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
import 'package:flutter_svg/flutter_svg.dart';
import '../../wallet_view/wallet_view.dart';
import '../../../pages_desktop_specific/my_stack_view/wallet_view/desktop_wallet_view.dart';
import '../../../providers/providers.dart';
import '../../../themes/coin_icon_provider.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/amount/amount.dart';
import '../../../utilities/amount/amount_formatter.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/show_loading.dart';
import '../../../utilities/text_styles.dart';
import '../../../utilities/util.dart';
import '../../../wallets/crypto_currency/coins/firo.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../wallets/wallet/wallet_mixin_interfaces/cw_based_interface.dart';
import '../../../widgets/coin_card.dart';
import '../../../widgets/conditional_parent.dart';

class FavoriteCard extends ConsumerStatefulWidget {
  const FavoriteCard({
    super.key,
    required this.walletId,
    required this.width,
    required this.height,
  });

  final String walletId;
  final double width;
  final double height;

  @override
  ConsumerState<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends ConsumerState<FavoriteCard> {
  late final String walletId;

  @override
  void initState() {
    walletId = widget.walletId;

    super.initState();
  }

  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final coin = ref.watch(pWalletCoin(walletId));
    final externalCalls = ref.watch(
      prefsChangeNotifierProvider.select((value) => value.externalCalls),
    );

    return ConditionalParent(
      condition: Util.isDesktop,
      builder: (child) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hovering = false;
          });
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _hovering ? 1.05 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: _hovering
                ? BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      Constants.size.circularBorderRadius,
                    ),
                    boxShadow: [
                      Theme.of(context)
                          .extension<StackColors>()!
                          .standardBoxShadow,
                      Theme.of(context)
                          .extension<StackColors>()!
                          .standardBoxShadow,
                      Theme.of(context)
                          .extension<StackColors>()!
                          .standardBoxShadow,
                    ],
                  )
                : BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      Constants.size.circularBorderRadius,
                    ),
                  ),
            child: child,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          final wallet = ref.read(pWallets).getWallet(walletId);

          final Future<void> loadFuture;
          if (wallet is CwBasedInterface) {
            loadFuture =
                wallet.init().then((value) async => await (wallet).open());
          } else {
            loadFuture = wallet.init();
          }
          await showLoading(
            whileFuture: loadFuture,
            context: context,
            message: 'Opening ${wallet.info.name}',
            rootNavigator: Util.isDesktop,
          );

          if (mounted) {
            if (Util.isDesktop) {
              await Navigator.of(context).pushNamed(
                DesktopWalletView.routeName,
                arguments: walletId,
              );
            } else {
              await Navigator.of(context).pushNamed(
                WalletView.routeName,
                arguments: walletId,
              );
            }
          }
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: CardOverlayStack(
            background: CoinCard(
              walletId: widget.walletId,
              width: widget.width,
              height: widget.height,
              isFavorite: true,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ref.watch(pWalletName(walletId)),
                            style: STextStyles.itemSubtitle12(context).copyWith(
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFavoriteCard,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        SvgPicture.file(
                          File(
                            ref.watch(coinIconProvider(coin)),
                          ),
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final balance = ref.watch(
                        pWalletBalance(walletId),
                      );

                      Amount total = balance.total;
                      if (coin is Firo) {
                        total += ref
                            .watch(
                              pWalletBalanceSecondary(walletId),
                            )
                            .total;
                        total += ref
                            .watch(
                              pWalletBalanceTertiary(walletId),
                            )
                            .total;
                      }

                      Amount fiatTotal = Amount.zero;

                      if (externalCalls && total > Amount.zero) {
                        fiatTotal = (total.decimal *
                                ref
                                    .watch(
                                      priceAnd24hChangeNotifierProvider.select(
                                        (value) => value.getPrice(coin),
                                      ),
                                    )
                                    .item1)
                            .toAmount(fractionDigits: 2);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              ref.watch(pAmountFormatter(coin)).format(total),
                              style: STextStyles.titleBold12(context).copyWith(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textFavoriteCard,
                              ),
                            ),
                          ),
                          if (externalCalls)
                            const SizedBox(
                              height: 4,
                            ),
                          if (externalCalls)
                            Text(
                              "${fiatTotal.fiatString(
                                locale: ref.watch(
                                  localeServiceChangeNotifierProvider.select(
                                    (value) => value.locale,
                                  ),
                                ),
                              )} ${ref.watch(
                                prefsChangeNotifierProvider.select(
                                  (value) => value.currency,
                                ),
                              )}",
                              style:
                                  STextStyles.itemSubtitle12(context).copyWith(
                                fontSize: 10,
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textFavoriteCard,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardOverlayStack extends StatelessWidget {
  const CardOverlayStack({
    super.key,
    required this.background,
    required this.child,
  });

  final Widget background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background,
        child,
      ],
    );
  }
}
