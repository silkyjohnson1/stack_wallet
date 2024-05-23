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
import '../../../../models/add_wallet_list_entity/sub_classes/eth_token_entity.dart';
import '../../create_or_restore_wallet_view/create_or_restore_wallet_view.dart';
import '../../select_wallet_for_token_view.dart';
import '../../../../providers/providers.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/text_styles.dart';

class AddWalletNextButton extends ConsumerWidget {
  const AddWalletNextButton({
    Key? key,
    required this.isDesktop,
  }) : super(key: key);

  final bool isDesktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("BUILD: NextButton");
    final selectedCoin =
        ref.watch(addWalletSelectedEntityStateProvider.state).state;

    final enabled = selectedCoin != null;

    return TextButton(
      onPressed: !enabled
          ? null
          : () {
              if (selectedCoin is EthTokenEntity) {
                Navigator.of(context).pushNamed(
                  SelectWalletForTokenView.routeName,
                  arguments: selectedCoin,
                );
              } else {
                Navigator.of(context).pushNamed(
                  CreateOrRestoreWalletView.routeName,
                  arguments: selectedCoin,
                );
              }
            },
      style: enabled
          ? Theme.of(context)
              .extension<StackColors>()!
              .getPrimaryEnabledButtonStyle(context)
          : Theme.of(context)
              .extension<StackColors>()!
              .getPrimaryDisabledButtonStyle(context),
      child: Text(
        "Next",
        style: isDesktop
            ? enabled
                ? STextStyles.desktopButtonEnabled(context)
                : STextStyles.desktopButtonDisabled(context)
            : STextStyles.button(context),
      ),
    );
  }
}
