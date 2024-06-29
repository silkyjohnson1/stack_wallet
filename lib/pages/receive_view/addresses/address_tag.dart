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

import '../../../themes/stack_colors.dart';
import '../../../utilities/extensions/extensions.dart';
import '../../../utilities/text_styles.dart';
import '../../../widgets/rounded_container.dart';

class AddressTag extends StatelessWidget {
  const AddressTag({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      radiusMultiplier: 0.5,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 7,
      ),
      color: Theme.of(context).extension<StackColors>()!.buttonBackPrimary,
      child: Text(
        tag.capitalize(),
        style: STextStyles.w500_14(context).copyWith(
          color: Theme.of(context).extension<StackColors>()!.buttonTextPrimary,
        ),
      ),
    );
  }
}
