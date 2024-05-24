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
import '../../../pages/settings_views/global_settings_view/syncing_preferences_views/syncing_options_view.dart';
import '../../../providers/global/prefs_provider.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/enums/sync_type_enum.dart';
import '../../../utilities/text_styles.dart';
import '../../../widgets/desktop/primary_button.dart';
import '../../../widgets/rounded_container.dart';
import '../../../widgets/rounded_white_container.dart';

class SyncingPreferencesSettings extends ConsumerStatefulWidget {
  const SyncingPreferencesSettings({Key? key}) : super(key: key);

  static const String routeName = "/settingsMenuSyncingPref";

  @override
  ConsumerState<SyncingPreferencesSettings> createState() =>
      _SyncingPreferencesSettings();
}

class _SyncingPreferencesSettings
    extends ConsumerState<SyncingPreferencesSettings> {
  String _currentTypeDescription(SyncingType type) {
    switch (type) {
      case SyncingType.currentWalletOnly:
        return "Sync only currently open wallet";
      case SyncingType.selectedWalletsAtStartup:
        return "Sync only selected wallets at startup";
      case SyncingType.allWalletsOnStartup:
        return "Sync all wallets at startup";
    }
  }

  late bool changePrefs = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 30,
          ),
          child: RoundedWhiteContainer(
            radiusMultiplier: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        Assets.svg.circleArrowRotate,
                        width: 48,
                        height: 48,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundedContainer(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .buttonBackSecondaryDisabled,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _currentTypeDescription(ref.watch(
                                prefsChangeNotifierProvider
                                    .select((value) => value.syncType))),
                            style: STextStyles.desktopTextExtraSmall(context)
                                .copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textDark2),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Syncing Preferences",
                              style: STextStyles.desktopTextSmall(context),
                            ),
                            TextSpan(
                              text:
                                  "\n\nSet up your syncing preferences for all wallets in your Stack.",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                  context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(
                          10,
                        ),
                        child: changePrefs
                            ? SizedBox(
                                width: 512,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SyncingOptionsView(),
                                    PrimaryButton(
                                      width: 200,
                                      buttonHeight: ButtonHeight.m,
                                      enabled: true,
                                      label: "Save",
                                      onPressed: () {
                                        setState(() {
                                          changePrefs = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  const SizedBox(height: 10),
                                  PrimaryButton(
                                    width: 200,
                                    buttonHeight: ButtonHeight.m,
                                    enabled: true,
                                    label: "Change preferences",
                                    onPressed: () {
                                      setState(() {
                                        changePrefs = true;
                                      });
                                    },
                                  ),
                                ],
                              )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
