/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackwallet/notifications/show_flush_bar.dart';
import 'package:stackwallet/pages/add_wallet_views/new_wallet_recovery_phrase_view/sub_widgets/mnemonic_table.dart';
import 'package:stackwallet/pages/wallet_view/transaction_views/transaction_details_view.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/address_utils.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/clipboard_interface.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/wallets/isar/providers/wallet_info_provider.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/simple_copy_button.dart';
import 'package:stackwallet/widgets/detail_item.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

class WalletBackupView extends ConsumerWidget {
  const WalletBackupView({
    Key? key,
    required this.walletId,
    required this.mnemonic,
    this.frostWalletData,
    this.clipboardInterface = const ClipboardWrapper(),
  }) : super(key: key);

  static const String routeName = "/walletBackup";

  final String walletId;
  final List<String> mnemonic;
  final ({
    String myName,
    String config,
    String keys,
    ({String config, String keys})? prevGen,
  })? frostWalletData;
  final ClipboardInterface clipboardInterface;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("BUILD: $runtimeType");

    final bool frost = frostWalletData != null;
    final prevGen = frostWalletData?.prevGen != null;

    return Background(
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<StackColors>()!.background,
        appBar: AppBar(
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Wallet backup",
            style: STextStyles.navBarTitle(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 1,
                child: AppBarIconButton(
                  color: Theme.of(context).extension<StackColors>()!.background,
                  shadows: const [],
                  icon: SvgPicture.asset(
                    Assets.svg.copy,
                    width: 20,
                    height: 20,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .topNavIconPrimary,
                  ),
                  onPressed: () async {
                    await clipboardInterface
                        .setData(ClipboardData(text: mnemonic.join(" ")));
                    unawaited(showFloatingFlushBar(
                      type: FlushBarType.info,
                      message: "Copied to clipboard",
                      iconAsset: Assets.svg.copy,
                      context: context,
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: frost
              ? LayoutBuilder(
                  builder: (builderContext, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 24,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RoundedWhiteContainer(
                                child: Text(
                                  "Please write down your backup data. Keep it safe and "
                                  "never share it with anyone. "
                                  "Your backup data is the only way you can access your "
                                  "funds if you forget your PIN, lose your phone, etc."
                                  "\n\n"
                                  "Stack Wallet does not keep nor is able to restore "
                                  "your backup data. "
                                  "Only you have access to your wallet.",
                                  style: STextStyles.label(context),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              // DetailItem(
                              //   title: "My name",
                              //   detail: frostWalletData!.myName,
                              //   button: Util.isDesktop
                              //       ? IconCopyButton(
                              //           data: frostWalletData!.myName,
                              //         )
                              //       : SimpleCopyButton(
                              //           data: frostWalletData!.myName,
                              //         ),
                              // ),
                              // const SizedBox(
                              //   height: 16,
                              // ),
                              DetailItem(
                                title: "Multisig config",
                                detail: frostWalletData!.config,
                                button: Util.isDesktop
                                    ? IconCopyButton(
                                        data: frostWalletData!.config,
                                      )
                                    : SimpleCopyButton(
                                        data: frostWalletData!.config,
                                      ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              DetailItem(
                                title: "Keys",
                                detail: frostWalletData!.keys,
                                button: Util.isDesktop
                                    ? IconCopyButton(
                                        data: frostWalletData!.keys,
                                      )
                                    : SimpleCopyButton(
                                        data: frostWalletData!.keys,
                                      ),
                              ),
                              if (prevGen)
                                const SizedBox(
                                  height: 24,
                                ),
                              if (prevGen)
                                RoundedWhiteContainer(
                                  child: Text(
                                    "Previous generation info",
                                    style: STextStyles.label(context),
                                  ),
                                ),
                              if (prevGen)
                                const SizedBox(
                                  height: 12,
                                ),
                              if (prevGen)
                                DetailItem(
                                  title: "Previous multisig config",
                                  detail: frostWalletData!.prevGen!.config,
                                  button: Util.isDesktop
                                      ? IconCopyButton(
                                          data:
                                              frostWalletData!.prevGen!.config,
                                        )
                                      : SimpleCopyButton(
                                          data:
                                              frostWalletData!.prevGen!.config,
                                        ),
                                ),
                              if (prevGen)
                                const SizedBox(
                                  height: 16,
                                ),
                              if (prevGen)
                                DetailItem(
                                  title: "Previous keys",
                                  detail: frostWalletData!.prevGen!.keys,
                                  button: Util.isDesktop
                                      ? IconCopyButton(
                                          data: frostWalletData!.prevGen!.keys,
                                        )
                                      : SimpleCopyButton(
                                          data: frostWalletData!.prevGen!.keys,
                                        ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      ref.watch(pWalletName(walletId)),
                      textAlign: TextAlign.center,
                      style: STextStyles.label(context).copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Recovery Phrase",
                      textAlign: TextAlign.center,
                      style: STextStyles.pageTitleH1(context),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).extension<StackColors>()!.popupBG,
                        borderRadius: BorderRadius.circular(
                            Constants.size.circularBorderRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "Please write down your backup key. Keep it safe and never share it with anyone. Your backup key is the only way you can access your funds if you forget your PIN, lose your phone, etc.\n\nStack Wallet does not keep nor is able to restore your backup key. Only you have access to your wallet.",
                          style: STextStyles.label(context),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: MnemonicTable(
                          words: mnemonic,
                          isDesktop: false,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextButton(
                      style: Theme.of(context)
                          .extension<StackColors>()!
                          .getPrimaryEnabledButtonStyle(context),
                      onPressed: () {
                        String data = AddressUtils.encodeQRSeedData(mnemonic);

                        showDialog<dynamic>(
                          context: context,
                          useSafeArea: false,
                          barrierDismissible: true,
                          builder: (_) {
                            final width = MediaQuery.of(context).size.width / 2;
                            return StackDialogBase(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Text(
                                      "Recovery phrase QR code",
                                      style: STextStyles.pageTitleH2(context),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Center(
                                    child: RepaintBoundary(
                                      // key: _qrKey,
                                      child: SizedBox(
                                        width: width + 20,
                                        height: width + 20,
                                        child: QrImageView(
                                            data: data,
                                            size: width,
                                            backgroundColor: Theme.of(context)
                                                .extension<StackColors>()!
                                                .popupBG,
                                            foregroundColor: Theme.of(context)
                                                .extension<StackColors>()!
                                                .accentColorDark),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: width,
                                      child: TextButton(
                                        onPressed: () async {
                                          // await _capturePng(true);
                                          Navigator.of(context).pop();
                                        },
                                        style: Theme.of(context)
                                            .extension<StackColors>()!
                                            .getSecondaryEnabledButtonStyle(
                                                context),
                                        child: Text(
                                          "Cancel",
                                          style: STextStyles.button(context)
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .extension<StackColors>()!
                                                      .accentColorDark),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Show QR Code",
                        style: STextStyles.button(context),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
