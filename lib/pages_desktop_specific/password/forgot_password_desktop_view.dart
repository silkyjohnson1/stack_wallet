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

import '../../app_config.dart';
import '../../themes/stack_colors.dart';
import '../../utilities/text_styles.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../widgets/desktop/desktop_app_bar.dart';
import '../../widgets/desktop/desktop_scaffold.dart';
import '../../widgets/desktop/primary_button.dart';
import '../../widgets/desktop/secondary_button.dart';
import 'delete_password_warning_view.dart';

class ForgotPasswordDesktopView extends ConsumerStatefulWidget {
  const ForgotPasswordDesktopView({
    super.key,
  });

  static const String routeName = "/forgotPasswordDesktop";

  @override
  ConsumerState<ForgotPasswordDesktopView> createState() =>
      _ForgotPasswordDesktopViewState();
}

class _ForgotPasswordDesktopViewState
    extends ConsumerState<ForgotPasswordDesktopView> {
  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(
      appBar: DesktopAppBar(
        leading: AppBarBackButton(
          onPressed: () async {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        isCompactHeight: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIcon(
                  width: 100,
                ),
                const SizedBox(
                  height: 42,
                ),
                Text(
                  AppConfig.appName,
                  style: STextStyles.desktopH1(context),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: 400,
                  child: Text(
                    "${AppConfig.appName} does not store your password. Create new wallet or use a Stack backup file to restore your wallet.",
                    textAlign: TextAlign.center,
                    style: STextStyles.desktopTextSmall(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textSubtitle1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                PrimaryButton(
                  label: "Create new Stack",
                  onPressed: () {
                    const shouldCreateNew = true;
                    Navigator.of(context).pushNamed(
                      DeletePasswordWarningView.routeName,
                      arguments: shouldCreateNew,
                    );
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                SecondaryButton(
                  label: "Restore from Stack backup",
                  onPressed: () {
                    const shouldCreateNew = false;
                    Navigator.of(context).pushNamed(
                      DeletePasswordWarningView.routeName,
                      arguments: shouldCreateNew,
                    );
                  },
                ),
                const SizedBox(
                  height: kDesktopAppBarHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
