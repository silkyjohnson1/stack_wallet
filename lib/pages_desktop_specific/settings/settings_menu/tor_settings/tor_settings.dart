/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

import '../../../../providers/global/prefs_provider.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../widgets/custom_buttons/draggable_switch_button.dart';

class TorSettings extends ConsumerStatefulWidget {
  const TorSettings({Key? key}) : super(key: key);

  static const String routeName = "/torDesktopSettings";

  @override
  ConsumerState<TorSettings> createState() => _TorSettingsState();
}

class _TorSettingsState extends ConsumerState<TorSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Util.isDesktop;

    /// todo: redo the padding
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 30,
          ),
          child: RoundedWhiteContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        Assets.svg.circleTor,
                        width: 48,
                        height: 48,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        Assets.svg.disconnectedButton,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tor settings",
                        style: STextStyles.desktopTextSmall(context),
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "\nConnect to the Tor Network with one click.",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                  context),
                            ),
                            TextSpan(
                              text: "\tWhat is Tor?",
                              style: STextStyles.richLink(context).copyWith(
                                fontSize: 14,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog<dynamic>(
                                      context: context,
                                      useSafeArea: false,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return DesktopDialog(
                                          maxWidth: 580,
                                          maxHeight: double.infinity,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  DesktopDialogCloseButton(
                                                    onPressedOverride: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      "What is Tor?",
                                                      style:
                                                          STextStyles.desktopH2(
                                                              context),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Short for \"The Onion Router\", is an open-source software that enables internet communication"
                                                      " to remain anonymous by routing internet traffic through a series of layered nodes,"
                                                      " to obscure the origin and destination of data.",
                                                      style: STextStyles
                                                              .desktopTextMedium(
                                                                  context)
                                                          .copyWith(
                                                        color: Theme.of(context)
                                                            .extension<
                                                                StackColors>()!
                                                            .textDark3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SecondaryButton(
                    label: "Disconnect from Tor",
                    width: 200,
                    buttonHeight: ButtonHeight.m,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Tor killswitch",
                                  style: STextStyles.desktopTextExtraExtraSmall(
                                          context)
                                      .copyWith(
                                          color: Theme.of(context)
                                              .extension<StackColors>()!
                                              .textDark),
                                ),
                                TextSpan(
                                  text: "\nWhat is Tor killswitch?",
                                  style: STextStyles.richLink(context).copyWith(
                                    fontSize: 14,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog<dynamic>(
                                          context: context,
                                          useSafeArea: false,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return DesktopDialog(
                                              maxWidth: 580,
                                              maxHeight: double.infinity,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      DesktopDialogCloseButton(
                                                        onPressedOverride: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          "What is Tor killswitch?",
                                                          style: STextStyles
                                                              .desktopH2(
                                                                  context),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          "A security feature that protects your information from accidental exposure by"
                                                          " disconnecting your device from the Tor network if your virtual private network (VPN)"
                                                          " connection is disrupted or compromised.",
                                                          style: STextStyles
                                                                  .desktopTextMedium(
                                                                      context)
                                                              .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .extension<
                                                                    StackColors>()!
                                                                .textDark3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          height: 20,
                          width: 40,
                          child: DraggableSwitchButton(
                            isOn: ref.watch(
                              prefsChangeNotifierProvider
                                  .select((value) => value.torKillswitch),
                            ),
                            onValueChanged: (newValue) {
                              ref
                                  .read(prefsChangeNotifierProvider)
                                  .torKillswitch = newValue;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
