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
import 'package:stackwallet/pages/buy_view/buy_form.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/desktop/desktop_app_bar.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/desktop_scaffold.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class DesktopBuyView extends ConsumerStatefulWidget {
  const DesktopBuyView({Key? key}) : super(key: key);

  static const String routeName = "/desktopBuyView";

  @override
  ConsumerState<DesktopBuyView> createState() => _DesktopBuyViewState();
}

class _DesktopBuyViewState extends ConsumerState<DesktopBuyView> {
  late bool torEnabled = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        torEnabled = ref.read(prefsChangeNotifierProvider).useTor;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DesktopScaffold(
          appBar: DesktopAppBar(
            isCompactHeight: true,
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 24,
              ),
              child: Text(
                "Buy crypto",
                style: STextStyles.desktopH3(context),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 16,
                      ),
                      RoundedWhiteContainer(
                        padding: EdgeInsets.all(24),
                        child: BuyForm(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                // Expanded(
                //   child: Row(
                //     children: const [
                //       Expanded(
                //         child: DesktopTradeHistory(),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
        if (torEnabled)
          Container(
            color: Theme.of(context)
                .extension<StackColors>()!
                .overlay
                .withOpacity(0.7),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: DesktopDialog(
              maxHeight: 200,
              maxWidth: 350,
              child: Padding(
                padding: const EdgeInsets.all(
                  15.0,
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tor is enabled",
                      textAlign: TextAlign.center,
                      style: STextStyles.pageTitleH1(context),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Purchasing not available while Tor is enabled",
                      textAlign: TextAlign.center,
                      style: STextStyles.desktopTextMedium(context).copyWith(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .infoItemLabel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
