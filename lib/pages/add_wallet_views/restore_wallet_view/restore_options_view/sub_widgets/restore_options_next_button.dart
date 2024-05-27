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
import '../../../../../themes/stack_colors.dart';
import '../../../../../utilities/text_styles.dart';

class RestoreOptionsNextButton extends StatelessWidget {
  const RestoreOptionsNextButton({
    super.key,
    required this.isDesktop,
    this.onPressed,
  });

  final bool isDesktop;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: isDesktop ? 70 : 0,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: onPressed != null
            ? Theme.of(context)
                .extension<StackColors>()!
                .getPrimaryEnabledButtonStyle(context)
            : Theme.of(context)
                .extension<StackColors>()!
                .getPrimaryDisabledButtonStyle(context),
        child: Text(
          "Next",
          style: STextStyles.button(context),
        ),
      ),
    );
  }
}
