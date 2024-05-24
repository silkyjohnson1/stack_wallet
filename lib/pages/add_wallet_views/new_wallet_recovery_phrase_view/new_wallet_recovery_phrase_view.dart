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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

import '../../../notifications/show_flush_bar.dart';
import '../../../pages_desktop_specific/desktop_home_view.dart';
import '../../../pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import '../../../providers/global/secure_store_provider.dart';
import '../../../providers/providers.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/clipboard_interface.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/text_styles.dart';
import '../../../utilities/util.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../wallets/wallet/wallet.dart';
import '../../../widgets/conditional_parent.dart';
import '../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../widgets/desktop/desktop_app_bar.dart';
import '../../../widgets/desktop/desktop_scaffold.dart';
import '../new_wallet_recovery_phrase_warning_view/new_wallet_recovery_phrase_warning_view.dart';
import '../verify_recovery_phrase_view/verify_recovery_phrase_view.dart';
import 'sub_widgets/mnemonic_table.dart';

class NewWalletRecoveryPhraseView extends ConsumerStatefulWidget {
  const NewWalletRecoveryPhraseView({
    Key? key,
    required this.wallet,
    required this.mnemonic,
    this.clipboardInterface = const ClipboardWrapper(),
  }) : super(key: key);

  static const routeName = "/newWalletRecoveryPhrase";

  final Wallet wallet;
  final List<String> mnemonic;

  final ClipboardInterface clipboardInterface;

  @override
  ConsumerState<NewWalletRecoveryPhraseView> createState() =>
      _NewWalletRecoveryPhraseViewState();
}

class _NewWalletRecoveryPhraseViewState
    extends ConsumerState<NewWalletRecoveryPhraseView>
// with WidgetsBindingObserver
{
  late Wallet _wallet;
  late List<String> _mnemonic;
  late ClipboardInterface _clipboardInterface;
  late final bool isDesktop;

  @override
  void initState() {
    _wallet = widget.wallet;
    _mnemonic = widget.mnemonic;
    _clipboardInterface = widget.clipboardInterface;
    isDesktop = Util.isDesktop;
    super.initState();
  }

  Future<bool> onWillPop() async {
    await delete();
    return true;
  }

  Future<void> delete() async {
    await _wallet.exit();
    await ref
        .read(pWallets)
        .deleteWallet(_wallet.info, ref.read(secureStoreProvider));
  }

  Future<void> _copy() async {
    final words = _mnemonic;
    await _clipboardInterface.setData(ClipboardData(text: words.join(" ")));
    unawaited(showFloatingFlushBar(
      type: FlushBarType.info,
      message: "Copied to clipboard",
      iconAsset: Assets.svg.copy,
      context: context,
    ));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return WillPopScope(
      onWillPop: onWillPop,
      child: MasterScaffold(
        isDesktop: isDesktop,
        appBar: isDesktop
            ? DesktopAppBar(
                isCompactHeight: false,
                leading: AppBarBackButton(
                  onPressed: () async {
                    await delete();

                    if (mounted) {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(
                          NewWalletRecoveryPhraseWarningView.routeName,
                        ),
                      );
                    }
                    // Navigator.of(context).pop();
                  },
                ),
                trailing: ExitToMyStackButton(
                  onPressed: () async {
                    await delete();
                    if (mounted) {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(DesktopHomeView.routeName),
                      );
                    }
                  },
                ),
              )
            : AppBar(
                leading: AppBarBackButton(
                  onPressed: () async {
                    await delete();

                    if (mounted) {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(
                          NewWalletRecoveryPhraseWarningView.routeName,
                        ),
                      );
                    }
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: AppBarIconButton(
                        semanticsLabel:
                            "Copy Button. Copies The Recovery Phrase To Clipboard.",
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .background,
                        shadows: const [],
                        icon: SvgPicture.asset(
                          Assets.svg.copy,
                          width: 24,
                          height: 24,
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .topNavIconPrimary,
                        ),
                        onPressed: () async {
                          await _copy();
                        },
                      ),
                    ),
                  ),
                ],
              ),
        body: Container(
          color: Theme.of(context).extension<StackColors>()!.background,
          width: isDesktop ? 600 : null,
          child: Padding(
            padding:
                isDesktop ? const EdgeInsets.all(0) : const EdgeInsets.all(16),
            child: ConditionalParent(
              condition: Util.isDesktop,
              builder: (child) => LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: child,
                      ),
                    ),
                  );
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isDesktop)
                    const Spacer(
                      flex: 10,
                    ),
                  if (!isDesktop)
                    const SizedBox(
                      height: 4,
                    ),
                  if (!isDesktop)
                    Text(
                      ref.watch(pWalletName(_wallet.walletId)),
                      textAlign: TextAlign.center,
                      style: STextStyles.label(context).copyWith(
                        fontSize: 12,
                      ),
                    ),
                  SizedBox(
                    height: isDesktop ? 24 : 4,
                  ),
                  Text(
                    "Recovery Phrase",
                    textAlign: TextAlign.center,
                    style: isDesktop
                        ? STextStyles.desktopH2(context)
                        : STextStyles.pageTitleH1(context),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDesktop
                          ? Theme.of(context)
                              .extension<StackColors>()!
                              .background
                          : Theme.of(context).extension<StackColors>()!.popupBG,
                      borderRadius: BorderRadius.circular(
                          Constants.size.circularBorderRadius),
                    ),
                    child: Padding(
                      padding: isDesktop
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(12),
                      child: Text(
                        "Please write down your recovery phrase in the correct order and save it to keep your funds secure. You will also be asked to verify the words on the next screen.",
                        textAlign: TextAlign.center,
                        style: isDesktop
                            ? STextStyles.desktopSubtitleH2(context)
                            : STextStyles.label(context).copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .accentColorDark),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isDesktop ? 21 : 8,
                  ),
                  if (!isDesktop)
                    Expanded(
                      child: SingleChildScrollView(
                        child: MnemonicTable(
                          words: _mnemonic,
                          isDesktop: isDesktop,
                        ),
                      ),
                    ),
                  if (isDesktop)
                    MnemonicTable(
                      words: _mnemonic,
                      isDesktop: isDesktop,
                    ),
                  SizedBox(
                    height: isDesktop ? 24 : 16,
                  ),
                  if (isDesktop)
                    SizedBox(
                      height: 70,
                      child: TextButton(
                        onPressed: () async {
                          await _copy();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.copy,
                              width: 20,
                              height: 20,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .buttonTextSecondary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Copy to clipboard",
                              style: STextStyles.desktopButtonSecondaryEnabled(
                                  context),
                            )
                          ],
                        ),
                      ),
                    ),
                  if (isDesktop)
                    const SizedBox(
                      height: 16,
                    ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: isDesktop ? 70 : 0,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final int next = Random().nextInt(_mnemonic.length);
                        ref
                            .read(verifyMnemonicWordIndexStateProvider.state)
                            .update((state) => next);

                        ref
                            .read(verifyMnemonicCorrectWordStateProvider.state)
                            .update((state) => _mnemonic[next]);

                        unawaited(Navigator.of(context).pushNamed(
                          VerifyRecoveryPhraseView.routeName,
                          arguments: Tuple2(_wallet, _mnemonic),
                        ));
                      },
                      style: Theme.of(context)
                          .extension<StackColors>()!
                          .getPrimaryEnabledButtonStyle(context),
                      child: Text(
                        "I saved my recovery phrase",
                        style: isDesktop
                            ? STextStyles.desktopButtonEnabled(context)
                            : STextStyles.button(context),
                      ),
                    ),
                  ),
                  if (isDesktop)
                    const Spacer(
                      flex: 15,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
