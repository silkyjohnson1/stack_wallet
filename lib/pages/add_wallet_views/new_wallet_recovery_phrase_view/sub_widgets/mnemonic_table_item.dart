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
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../widgets/rounded_white_container.dart';

class MnemonicTableItem extends StatelessWidget {
  const MnemonicTableItem({
    Key? key,
    required this.number,
    required this.word,
    required this.isDesktop,
    this.borderColor,
  }) : super(key: key);

  final int number;
  final String word;
  final bool isDesktop;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return RoundedWhiteContainer(
      borderColor: borderColor,
      padding: isDesktop
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 9)
          : const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            number.toString(),
            style: isDesktop
                ? STextStyles.desktopTextExtraSmall(context).copyWith(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textSubtitle2,
                  )
                : STextStyles.baseXS(context).copyWith(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textSubtitle2,
                    fontSize: 10,
                  ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            word,
            style: isDesktop
                ? STextStyles.desktopTextExtraSmall(context).copyWith(
                    color: Theme.of(context).extension<StackColors>()!.textDark,
                  )
                : STextStyles.baseXS(context),
          ),
        ],
      ),
    );
  }
}
