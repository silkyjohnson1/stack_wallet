/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by julian on 2023-10-16
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/pages_desktop_specific/cashfusion/sub_widgets/fusion_progress.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/mixins/fusion_wallet_interface.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';

class FusionProgressView extends ConsumerStatefulWidget {
  const FusionProgressView({
    super.key,
    required this.walletId,
  });

  static const routeName = "/cashFusionProgressView";

  final String walletId;

  @override
  ConsumerState<FusionProgressView> createState() => _FusionProgressViewState();
}

class _FusionProgressViewState extends ConsumerState<FusionProgressView> {
  /// return true on will cancel, false if cancel cancelled
  Future<bool> _requestCancel() async {
    // TODO
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _requestCancel();
      },
      child: Background(
        child: SafeArea(
          child: Scaffold(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.background,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: AppBarBackButton(
                onPressed: () async {
                  if (await _requestCancel()) {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
              title: Text(
                "Fusion progress",
                style: STextStyles.navBarTitle(context),
              ),
              titleSpacing: 0,
            ),
            body: LayoutBuilder(
              builder: (builderContext, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            FusionProgress(
                              walletId: widget.walletId,
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 16,
                            ),
                            // TODO: various button states
                            // tempt only show cancel button
                            SecondaryButton(
                              label: "Cancela",
                              onPressed: () async {
                                final fusionWallet = ref
                                    .read(walletsChangeNotifierProvider)
                                    .getManager(widget.walletId)
                                    .wallet as FusionWalletInterface;

                                await fusionWallet.stop();
                                // TODO should this stop be unawaited?

                                if (await _requestCancel()) {
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
