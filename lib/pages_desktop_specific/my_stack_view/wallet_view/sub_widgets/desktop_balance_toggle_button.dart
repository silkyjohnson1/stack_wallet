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
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../providers/wallet/public_private_balance_state_provider.dart';
import '../../../../providers/wallet/wallet_balance_toggle_state_provider.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/enums/wallet_balance_toggle_state.dart';
import '../../../../utilities/text_styles.dart';

class DesktopBalanceToggleButton extends ConsumerWidget {
  const DesktopBalanceToggleButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 22,
      width: 80,
      child: MaterialButton(
        color: Theme.of(context).extension<StackColors>()!.buttonBackSecondary,
        splashColor: Theme.of(context).extension<StackColors>()!.highlight,
        onPressed: () {
          if (ref.read(walletBalanceToggleStateProvider.state).state ==
              WalletBalanceToggleState.available) {
            ref.read(walletBalanceToggleStateProvider.state).state =
                WalletBalanceToggleState.full;
          } else {
            ref.read(walletBalanceToggleStateProvider.state).state =
                WalletBalanceToggleState.available;
          }
          onPressed?.call();
        },
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              ref.watch(walletBalanceToggleStateProvider.state).state ==
                      WalletBalanceToggleState.available
                  ? "AVAILABLE"
                  : "FULL",
              style: STextStyles.w500_10(context),
            ),
          ),
        ),
      ),
    );
  }
}

class DesktopPrivateBalanceToggleButton extends ConsumerWidget {
  const DesktopPrivateBalanceToggleButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentType = ref.watch(publicPrivateBalanceStateProvider);

    return SizedBox(
      height: 22,
      width: 22,
      child: MaterialButton(
        color: Theme.of(context).extension<StackColors>()!.buttonBackSecondary,
        splashColor: Theme.of(context).extension<StackColors>()!.highlight,
        onPressed: () {
          switch (currentType) {
            case FiroType.public:
              ref.read(publicPrivateBalanceStateProvider.state).state =
                  FiroType.lelantus;
              break;

            case FiroType.lelantus:
              ref.read(publicPrivateBalanceStateProvider.state).state =
                  FiroType.spark;
              break;

            case FiroType.spark:
              ref.read(publicPrivateBalanceStateProvider.state).state =
                  FiroType.public;
              break;
          }
          onPressed?.call();
        },
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
        ),
        child: Center(
          child: currentType == FiroType.spark
              ? SvgPicture.asset(
                  Assets.svg.spark,
                  width: 16,
                  // color: Theme.of(context)
                  //     .extension<StackColors>()!
                  //     .accentColorYellow,
                )
              : Image(
                  image: AssetImage(
                    currentType == FiroType.public
                        ? Assets.png.glasses
                        : Assets.png.glassesHidden,
                  ),
                  width: 16,
                ),
        ),
      ),
    );
  }
}
