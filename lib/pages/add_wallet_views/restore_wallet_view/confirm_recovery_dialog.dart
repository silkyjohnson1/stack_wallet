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
import 'package:flutter_svg/svg.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/text_styles.dart';
import '../../../utilities/util.dart';
import '../../../widgets/desktop/desktop_dialog.dart';
import '../../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../../widgets/desktop/primary_button.dart';
import '../../../widgets/desktop/secondary_button.dart';
import '../../../widgets/stack_dialog.dart';

class ConfirmRecoveryDialog extends StatelessWidget {
  const ConfirmRecoveryDialog({Key? key, required this.onConfirm})
      : super(key: key);

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    if (Util.isDesktop) {
      return DesktopDialog(
        child: Column(
          children: [
            const DesktopDialogCloseButton(),
            const SizedBox(
              height: 5,
            ),
            SvgPicture.asset(
              Assets.svg.drd,
              width: 99,
              height: 70,
            ),
            const Spacer(),
            Text(
              "Restore wallet",
              style: STextStyles.desktopH2(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Restoring your wallet may take a while.\nPlease do not exit this screen once the process is started.",
              style: STextStyles.desktopTextMedium(context).copyWith(
                color: Theme.of(context).extension<StackColors>()!.textDark3,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                bottom: 32,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: "Cancel",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      label: "Restore",
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm.call();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: StackDialog(
          title: "Are you ready?",
          message:
              "Restoring your wallet may take a while. Please do not exit this screen once the process is started.",
          leftButton: SecondaryButton(
            label: "Cancel",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          rightButton: PrimaryButton(
            label: "Restore",
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm.call();
            },
          ),
        ),
      );
    }
  }
}
