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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../providers/desktop/storage_crypto_handler_provider.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../wallets/crypto_currency/crypto_currency.dart';
import '../../../../widgets/desktop/primary_button.dart';
import '../../../../widgets/desktop/secondary_button.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/stack_text_field.dart';

class DesktopAuthSend extends ConsumerStatefulWidget {
  const DesktopAuthSend({
    super.key,
    required this.coin,
  });

  final CryptoCurrency coin;

  @override
  ConsumerState<DesktopAuthSend> createState() => _DesktopAuthSendState();
}

class _DesktopAuthSendState extends ConsumerState<DesktopAuthSend> {
  late final TextEditingController passwordController;
  late final FocusNode passwordFocusNode;

  bool hidePassword = true;

  bool _confirmEnabled = false;
  bool _lock = false;

  Future<void> _confirmPressed() async {
    if (_lock) {
      return;
    }
    _lock = true;

    try {
      unawaited(
        showDialog<void>(
          context: context,
          builder: (context) => const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingIndicator(
                width: 200,
                height: 200,
              ),
            ],
          ),
        ),
      );

      await Future<void>.delayed(const Duration(seconds: 1));

      final passwordIsValid = await ref
          .read(storageCryptoHandlerProvider)
          .verifyPassphrase(passwordController.text);

      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop(passwordIsValid);
        await Future<void>.delayed(
          const Duration(
            milliseconds: 100,
          ),
        );
      }
    } finally {
      _lock = false;
    }
  }

  @override
  void initState() {
    passwordController = TextEditingController();
    passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          Assets.svg.keys,
          width: 100,
        ),
        const SizedBox(
          height: 56,
        ),
        Text(
          "Confirm transaction",
          style: STextStyles.desktopH3(context),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Enter your wallet password to send ${widget.coin.ticker.toUpperCase()}",
          style: STextStyles.desktopTextMedium(context).copyWith(
            color: Theme.of(context).extension<StackColors>()!.textDark3,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
          child: TextField(
            key: const Key("desktopLoginPasswordFieldKey"),
            focusNode: passwordFocusNode,
            controller: passwordController,
            style: STextStyles.desktopTextMedium(context).copyWith(
              height: 2,
            ),
            obscureText: hidePassword,
            enableSuggestions: false,
            autocorrect: false,
            autofocus: true,
            onSubmitted: (_) {
              if (_confirmEnabled) {
                _confirmPressed();
              }
            },
            decoration: standardInputDecoration(
              "Enter password",
              passwordFocusNode,
              context,
            ).copyWith(
              suffixIcon: UnconstrainedBox(
                child: SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        key: const Key(
                          "restoreFromFilePasswordFieldShowPasswordButtonKey",
                        ),
                        onTap: () async {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: SvgPicture.asset(
                          hidePassword ? Assets.svg.eye : Assets.svg.eyeSlash,
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textDark3,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onChanged: (newValue) {
              setState(() {
                _confirmEnabled = passwordController.text.isNotEmpty;
              });
            },
          ),
        ),
        const SizedBox(
          height: 48,
        ),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: "Cancel",
                buttonHeight: ButtonHeight.l,
                onPressed: Navigator.of(context).pop,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: PrimaryButton(
                enabled: _confirmEnabled,
                label: "Confirm",
                buttonHeight: ButtonHeight.l,
                onPressed: _confirmPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
