/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by julian on 2023-10-16
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/pages_desktop_specific/cashfusion/sub_widgets/fusion_progress.dart';
import 'package:stackwallet/providers/cash_fusion/fusion_progress_ui_state_provider.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/mixins/fusion_wallet_interface.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/show_loading.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/rounded_container.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

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
  Future<bool> _requestAndProcessCancel() async {
    final shouldCancel = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StackDialog(
        title: "Cancel fusion?",
        leftButton: SecondaryButton(
          label: "No",
          buttonHeight: ButtonHeight.l,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        rightButton: PrimaryButton(
          label: "Yes",
          buttonHeight: ButtonHeight.l,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );

    if (shouldCancel == true && mounted) {
      final fusionWallet = ref
          .read(walletsChangeNotifierProvider)
          .getManager(widget.walletId)
          .wallet as FusionWalletInterface;

      await showLoading(
        whileFuture: Future.wait([
          fusionWallet.stop(),
          Future<void>.delayed(const Duration(seconds: 2)),
        ]),
        context: context,
        isDesktop: Util.isDesktop,
        message: "Stopping fusion",
      );

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _succeeded =
        ref.watch(fusionProgressUIStateProvider(widget.walletId)).succeeded;

    final bool _failed =
        ref.watch(fusionProgressUIStateProvider(widget.walletId)).failed;

    final int _fusionRoundsCompleted = ref
        .watch(fusionProgressUIStateProvider(widget.walletId))
        .fusionRoundsCompleted;

    return WillPopScope(
      onWillPop: () async {
        return await _requestAndProcessCancel();
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
                  if (await _requestAndProcessCancel()) {
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
                            // TODO if (_succeeded but roundCount > roundCount)
                            // show "Fusion completed" as snackBarBackSuccess.
                            if (_fusionRoundsCompleted > 0)
                              Expanded(
                                child: RoundedContainer(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .snackBarBackInfo,
                                  child: Text(
                                    "Fusion rounds completed: $_fusionRoundsCompleted",
                                    style:
                                        STextStyles.w500_14(context).copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .snackBarTextInfo,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            if (_fusionRoundsCompleted > 0)
                              const SizedBox(
                                height: 20,
                              ),
                            FusionProgress(
                              walletId: widget.walletId,
                            ),
                            if (_succeeded)
                              /*Expanded(
                                child: */
                              PrimaryButton(
                                buttonHeight: ButtonHeight.m,
                                label: "Fuse again",
                                onPressed: () => _fuseAgain,
                              ),
                            // ),
                            if (_failed)
                              /*Expanded(
                                child: */
                              PrimaryButton(
                                buttonHeight: ButtonHeight.m,
                                label: "Try again",
                                onPressed: () => _fuseAgain,
                              ),
                            // ),
                            if (!_succeeded && !_failed) const Spacer(),
                            const SizedBox(
                              height: 16,
                            ),
                            SecondaryButton(
                              label: "Cancel",
                              onPressed: () async {
                                if (await _requestAndProcessCancel()) {
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

  /// Fuse again.
  void _fuseAgain() async {
    final fusionWallet = ref
        .read(walletsChangeNotifierProvider)
        .getManager(widget.walletId)
        .wallet as FusionWalletInterface;

    final fusionInfo = ref.read(prefsChangeNotifierProvider).fusionServerInfo;

    unawaited(fusionWallet.fuse(fusionInfo: fusionInfo));
  }
}
