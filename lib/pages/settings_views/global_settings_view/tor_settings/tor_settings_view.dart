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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/draggable_switch_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

class TorSettingsView extends ConsumerStatefulWidget {
  const TorSettingsView({Key? key}) : super(key: key);

  static const String routeName = "/torSettings";

  @override
  ConsumerState<TorSettingsView> createState() => _TorSettingsViewState();
}

class _TorSettingsViewState extends ConsumerState<TorSettingsView> {
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

    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.backgroundAppBar,
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Tor settings",
            style: STextStyles.navBarTitle(context),
          ),
          actions: [
            AspectRatio(
              aspectRatio: 1,
              child: AppBarIconButton(
                icon: SvgPicture.asset(
                  Assets.svg.circleQuestion,
                ),
                onPressed: () {
                  showDialog<dynamic>(
                    context: context,
                    useSafeArea: false,
                    barrierDismissible: true,
                    builder: (context) {
                      return const StackDialog(
                        title: "What is Tor?",
                        message:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                            "Sed sit amet nulla accumsan, ornare felis pellentesque, auctor nulla.",
                        rightButton: SecondaryButton(
                          label: "Close",
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      Assets.svg.tor,
                      height: 200,
                      width: 200,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              RoundedWhiteContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Tor status",
                        style: STextStyles.titleBold12(context),
                      ),
                      const Spacer(),
                      Text(
                        "Tor network status",
                        style: STextStyles.itemSubtitle(context),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RoundedWhiteContainer(
                child: Consumer(
                  builder: (_, ref, __) {
                    return RawMaterialButton(
                      // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constants.size.circularBorderRadius,
                        ),
                      ),
                      onPressed: null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Tor killswitch",
                                  style: STextStyles.titleBold12(context),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                  Assets.svg.circleInfo,
                                  height: 16,
                                  width: 16,
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .infoItemLabel,
                                ),
                              ],
                            ),
                            SizedBox(
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
