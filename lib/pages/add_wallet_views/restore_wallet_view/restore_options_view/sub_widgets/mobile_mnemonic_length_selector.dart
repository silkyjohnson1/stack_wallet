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
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/providers/ui/verify_recovery_phrase/mnemonic_word_count_state_provider.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';

class MobileMnemonicLengthSelector extends ConsumerWidget {
  const MobileMnemonicLengthSelector({
    Key? key,
    required this.chooseMnemonicLength,
  }) : super(key: key);

  final VoidCallback chooseMnemonicLength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        TextField(
          autocorrect: Util.isDesktop ? false : true,
          enableSuggestions: Util.isDesktop ? false : true,
          // controller: _lengthController,
          readOnly: true,
          textInputAction: TextInputAction.none,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: RawMaterialButton(
            splashColor: Theme.of(context).extension<StackColors>()!.highlight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
            ),
            onPressed: chooseMnemonicLength,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${ref.watch(mnemonicWordCountStateProvider.state).state} words",
                  style: STextStyles.itemSubtitle12(context),
                ),
                SvgPicture.asset(
                  Assets.svg.chevronDown,
                  width: 8,
                  height: 4,
                  color:
                      Theme.of(context).extension<StackColors>()!.textSubtitle2,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
