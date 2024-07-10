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

import '../../../../models/keys/cw_key_data.dart';
import '../../../../models/keys/key_data_interface.dart';
import '../../../../models/keys/xpriv_data.dart';
import '../../../../notifications/show_flush_bar.dart';
import '../../../../pages/add_wallet_views/new_wallet_recovery_phrase_view/sub_widgets/mnemonic_table.dart';
import '../../../../pages/settings_views/wallet_settings_view/wallet_backup_views/cn_wallet_keys.dart';
import '../../../../pages/settings_views/wallet_settings_view/wallet_backup_views/wallet_xprivs.dart';
import '../../../../pages/wallet_view/transaction_views/transaction_details_view.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/address_utils.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/clipboard_interface.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../widgets/custom_tab_view.dart';
import '../../../../widgets/desktop/desktop_dialog.dart';
import '../../../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../../../widgets/desktop/primary_button.dart';
import '../../../../widgets/desktop/secondary_button.dart';
import '../../../../widgets/rounded_white_container.dart';
import 'qr_code_desktop_popup_content.dart';

class WalletKeysDesktopPopup extends ConsumerWidget {
  const WalletKeysDesktopPopup({
    super.key,
    required this.words,
    required this.walletId,
    this.frostData,
    this.clipboardInterface = const ClipboardWrapper(),
    this.keyData,
  });

  final List<String> words;
  final String walletId;
  final ({String keys, String config})? frostData;
  final ClipboardInterface clipboardInterface;
  final KeyDataInterface? keyData;

  static const String routeName = "walletKeysDesktopPopup";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DesktopDialog(
      maxWidth: 614,
      maxHeight: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                ),
                child: Text(
                  "Wallet keys",
                  style: STextStyles.desktopH3(context),
                ),
              ),
              DesktopDialogCloseButton(
                onPressedOverride: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          frostData != null
              ? Column(
                  children: [
                    Text(
                      "Keys",
                      style: STextStyles.desktopTextMedium(context),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: RoundedWhiteContainer(
                          borderColor: Theme.of(context)
                              .extension<StackColors>()!
                              .textFieldDefaultBG,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: SelectableText(
                                  frostData!.keys,
                                  style: STextStyles.desktopTextExtraExtraSmall(
                                    context,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconCopyButton(
                                data: frostData!.keys,
                              ),
                              // TODO [prio=low: Add QR code button and dialog.
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Config",
                      style: STextStyles.desktopTextMedium(context),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: RoundedWhiteContainer(
                          borderColor: Theme.of(context)
                              .extension<StackColors>()!
                              .textFieldDefaultBG,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: SelectableText(
                                  frostData!.config,
                                  style: STextStyles.desktopTextExtraExtraSmall(
                                    context,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconCopyButton(
                                data: frostData!.config,
                              ),
                              // TODO [prio=low: Add QR code button and dialog.
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                )
              : keyData != null
                  ? CustomTabView(
                      titles: [
                        "Mnemonic",
                        if (keyData is XPrivData) "XPriv(s)",
                        if (keyData is CWKeyData) "Keys",
                      ],
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _Mnemonic(
                            words: words,
                          ),
                        ),
                        if (keyData is XPrivData)
                          WalletXPrivs(
                            xprivData: keyData as XPrivData,
                            walletId: walletId,
                          ),
                        if (keyData is CWKeyData)
                          CNWalletKeys(
                            cwKeyData: keyData as CWKeyData,
                            walletId: walletId,
                          ),
                      ],
                    )
                  : _Mnemonic(
                      words: words,
                    ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

class _Mnemonic extends StatelessWidget {
  const _Mnemonic({
    super.key,
    required this.words,
    this.clipboardInterface = const ClipboardWrapper(),
  });

  final List<String> words;
  final ClipboardInterface clipboardInterface;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Recovery phrase",
          style: STextStyles.desktopTextMedium(context),
        ),
        const SizedBox(
          height: 8,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Text(
              "Please write down your recovery phrase in the correct order and "
              "save it to keep your funds secure. You will also be asked to"
              " verify the words on the next screen.",
              style: STextStyles.desktopTextExtraExtraSmall(context),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: MnemonicTable(
            words: words,
            isDesktop: true,
            itemBorderColor:
                Theme.of(context).extension<StackColors>()!.buttonBackSecondary,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: "Copy",
                  onPressed: () async {
                    await clipboardInterface.setData(
                      ClipboardData(text: words.join(" ")),
                    );
                    if (context.mounted) {
                      unawaited(
                        showFloatingFlushBar(
                          type: FlushBarType.info,
                          message: "Copied to clipboard",
                          iconAsset: Assets.svg.copy,
                          context: context,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: PrimaryButton(
                  label: "Show QR code",
                  onPressed: () {
                    // TODO: address utils
                    final String value = AddressUtils.encodeQRSeedData(words);
                    Navigator.of(context).pushNamed(
                      QRCodeDesktopPopupContent.routeName,
                      arguments: value,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
