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
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/assets.dart';

class ReceiveNavIcon extends StatelessWidget {
  const ReceiveNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .extension<StackColors>()!
            .bottomNavIconIcon
            .withOpacity(0.4),
        borderRadius: BorderRadius.circular(
          24,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SvgPicture.asset(
          Assets.svg.arrowDownLeft,
          width: 12,
          height: 12,
          color: Theme.of(context).extension<StackColors>()!.bottomNavIconIcon,
        ),
      ),
    );
  }
}
