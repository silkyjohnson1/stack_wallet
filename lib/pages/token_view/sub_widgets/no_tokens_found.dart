/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/cupertino.dart';
import '../../../utilities/text_styles.dart';
import '../../../widgets/rounded_white_container.dart';

class NoTokensFound extends StatelessWidget {
  const NoTokensFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RoundedWhiteContainer(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "You do not have any tokens",
              style: STextStyles.itemSubtitle(context),
            ),
          ),
        ),
      ],
    );
  }
}
