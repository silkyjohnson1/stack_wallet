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
import '../themes/stack_colors.dart';
import '../utilities/text_styles.dart';
import '../utilities/util.dart';

class StackDialogBase extends StatelessWidget {
  const StackDialogBase({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(24),
    this.keyboardPaddingAmount = 0,
  });

  final EdgeInsets padding;
  final Widget? child;
  final double keyboardPaddingAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: 16 + keyboardPaddingAmount,
      ),
      child: Column(
        mainAxisAlignment:
            !Util.isDesktop ? MainAxisAlignment.end : MainAxisAlignment.center,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Material(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).extension<StackColors>()!.popupBG,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Padding(
                    padding: padding,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StackDialog extends StatelessWidget {
  const StackDialog({
    super.key,
    this.leftButton,
    this.rightButton,
    this.icon,
    required this.title,
    this.message,
  });

  final Widget? leftButton;
  final Widget? rightButton;

  final Widget? icon;

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return StackDialogBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: STextStyles.pageTitleH2(context),
                ),
              ),
              icon != null ? icon! : Container(),
            ],
          ),
          if (message != null)
            const SizedBox(
              height: 8,
            ),
          if (message != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message!,
                  style: STextStyles.smallMed14(context),
                ),
              ],
            ),
          if (leftButton != null || rightButton != null)
            const SizedBox(
              height: 20,
            ),
          if (leftButton != null || rightButton != null)
            Row(
              children: [
                leftButton == null
                    ? const Spacer()
                    : Expanded(child: leftButton!),
                const SizedBox(
                  width: 8,
                ),
                rightButton == null
                    ? const Spacer()
                    : Expanded(child: rightButton!),
              ],
            ),
        ],
      ),
    );
  }
}

class StackOkDialog extends StatelessWidget {
  const StackOkDialog({
    super.key,
    this.leftButton,
    this.onOkPressed,
    this.icon,
    required this.title,
    this.message,
    this.desktopPopRootNavigator = false,
  });

  final bool desktopPopRootNavigator;
  final Widget? leftButton;
  final void Function(String)? onOkPressed;

  final Widget? icon;

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return StackDialogBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: STextStyles.pageTitleH2(context),
                ),
              ),
              icon != null ? icon! : Container(),
            ],
          ),
          if (message != null)
            const SizedBox(
              height: 8,
            ),
          if (message != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message!,
                  style: STextStyles.smallMed14(context),
                ),
              ],
            ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              leftButton == null
                  ? const Spacer()
                  : Expanded(child: leftButton!),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextButton(
                  onPressed: !Util.isDesktop
                      ? () {
                          Navigator.of(context).pop();
                          onOkPressed?.call("OK");
                        }
                      : () {
                          if (desktopPopRootNavigator) {
                            Navigator.of(context, rootNavigator: true).pop();
                          } else {
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                            // onOkPressed?.call("OK");
                          }
                        },
                  style: Theme.of(context)
                      .extension<StackColors>()!
                      .getPrimaryEnabledButtonStyle(context),
                  child: Text(
                    "Ok",
                    style: STextStyles.button(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
