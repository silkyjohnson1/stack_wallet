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

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../pages/cashfusion/fusion_rounds_selection_sheet.dart';
import '../../providers/cash_fusion/fusion_progress_ui_state_provider.dart';
import '../../providers/global/prefs_provider.dart';
import '../../providers/global/wallets_provider.dart';
import '../../themes/stack_colors.dart';
import '../../utilities/assets.dart';
import '../../utilities/constants.dart';
import '../../utilities/text_styles.dart';
import '../../wallets/crypto_currency/crypto_currency.dart';
import '../../wallets/isar/providers/wallet_info_provider.dart';
import '../../wallets/wallet/wallet_mixin_interfaces/cash_fusion_interface.dart';
import '../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../widgets/custom_buttons/blue_text_button.dart';
import '../../widgets/desktop/desktop_app_bar.dart';
import '../../widgets/desktop/desktop_dialog.dart';
import '../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../widgets/desktop/desktop_scaffold.dart';
import '../../widgets/desktop/primary_button.dart';
import '../../widgets/rounded_white_container.dart';
import '../../widgets/stack_text_field.dart';
import 'sub_widgets/fusion_dialog.dart';

class DesktopCashFusionView extends ConsumerStatefulWidget {
  const DesktopCashFusionView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/desktopCashFusionView";

  final String walletId;

  @override
  ConsumerState<DesktopCashFusionView> createState() => _DesktopCashFusion();
}

class _DesktopCashFusion extends ConsumerState<DesktopCashFusionView> {
  late final TextEditingController serverController;
  late final FocusNode serverFocusNode;
  late final TextEditingController portController;
  late final FocusNode portFocusNode;
  late final TextEditingController fusionRoundController;
  late final FocusNode fusionRoundFocusNode;
  late final CryptoCurrency coin;

  bool _enableStartButton = false;
  bool _enableSSLCheckbox = false;

  FusionOption _roundType = FusionOption.continuous;

  Future<void> _startFusion() async {
    final fusionWallet =
        ref.read(pWallets).getWallet(widget.walletId) as CashFusionInterface;

    try {
      fusionWallet.uiState = ref.read(
        fusionProgressUIStateProvider(widget.walletId),
      );
    } catch (e) {
      if (!e.toString().contains(
            "FusionProgressUIState was already set for ${widget.walletId}",
          )) {
        rethrow;
      }
    }

    final int rounds = _roundType == FusionOption.continuous
        ? 0
        : int.parse(fusionRoundController.text);

    final newInfo = FusionInfo(
      host: serverController.text,
      port: int.parse(portController.text),
      ssl: _enableSSLCheckbox,
      rounds: rounds,
    );

    // update user prefs (persistent)

    ref.read(prefsChangeNotifierProvider).setFusionServerInfo(coin, newInfo);

    unawaited(
      fusionWallet.fuse(
        fusionInfo: newInfo,
      ),
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FusionDialogView(
          walletId: widget.walletId,
        );
      },
    );
  }

  @override
  void initState() {
    serverController = TextEditingController();
    portController = TextEditingController();
    fusionRoundController = TextEditingController();

    serverFocusNode = FocusNode();
    portFocusNode = FocusNode();
    fusionRoundFocusNode = FocusNode();

    coin = ref.read(pWalletCoin(widget.walletId));

    final info =
        ref.read(prefsChangeNotifierProvider).getFusionServerInfo(coin);

    serverController.text = info.host;
    portController.text = info.port.toString();
    _enableSSLCheckbox = info.ssl;
    _roundType =
        info.rounds == 0 ? FusionOption.continuous : FusionOption.custom;
    fusionRoundController.text = info.rounds.toString();

    _enableStartButton =
        serverController.text.isNotEmpty && portController.text.isNotEmpty;

    super.initState();
  }

  @override
  void dispose() {
    serverController.dispose();
    portController.dispose();
    fusionRoundController.dispose();

    serverFocusNode.dispose();
    portFocusNode.dispose();
    fusionRoundFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    return DesktopScaffold(
      appBar: DesktopAppBar(
        background: Theme.of(context).extension<StackColors>()!.popupBG,
        isCompactHeight: true,
        useSpacers: false,
        leading: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // const SizedBox(
                    //   width: 32,
                    // ),
                    AppBarIconButton(
                      size: 32,
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldDefaultBG,
                      shadows: const [],
                      icon: SvgPicture.asset(
                        Assets.svg.arrowLeft,
                        width: 18,
                        height: 18,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .topNavIconPrimary,
                      ),
                      onPressed: Navigator.of(context).pop,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SvgPicture.asset(
                      Assets.svg.cashFusion,
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Fusion",
                      style: STextStyles.desktopH3(context),
                    ),
                  ],
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svg.circleQuestion,
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .radioButtonIconBorder,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "What is Fusion?",
                            style: STextStyles.richLink(context).copyWith(
                              fontSize: 16,
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                          bottom: 20,
                                          right: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "What is Fusion?",
                                                  style: STextStyles.desktopH2(
                                                    context,
                                                  ),
                                                ),
                                                DesktopDialogCloseButton(
                                                  onPressedOverride: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Text(
                                              "A fully decentralized privacy protocol that allows "
                                              "anyone to create multi-party transactions with other "
                                              "network participants. This process obscures your real "
                                              "spending and makes it difficult for chain-analysis "
                                              "companies to track your coins.",
                                              style:
                                                  STextStyles.desktopTextMedium(
                                                context,
                                              ).copyWith(
                                                color: Theme.of(context)
                                                    .extension<StackColors>()!
                                                    .textDark3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 460,
                  child: RoundedWhiteContainer(
                    child: Row(
                      children: [
                        Text(
                          "Fusion helps anonymize your coins by mixing them.",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: 460,
                  child: RoundedWhiteContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Server settings",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                context,
                              ),
                            ),
                            CustomTextButton(
                              text: "Default",
                              onTap: () {
                                final def = kFusionServerInfoDefaults[coin]!;
                                serverController.text = def.host;
                                portController.text = def.port.toString();
                                fusionRoundController.text =
                                    def.rounds.toString();
                                _roundType = FusionOption.continuous;
                                setState(() {
                                  _enableSSLCheckbox = def.ssl;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Constants.size.circularBorderRadius,
                          ),
                          child: TextField(
                            autocorrect: false,
                            enableSuggestions: false,
                            controller: serverController,
                            focusNode: serverFocusNode,
                            onChanged: (value) {
                              setState(() {
                                _enableStartButton = value.isNotEmpty &&
                                    portController.text.isNotEmpty &&
                                    fusionRoundController.text.isNotEmpty;
                              });
                            },
                            style: STextStyles.field(context),
                            decoration: standardInputDecoration(
                              "Server",
                              serverFocusNode,
                              context,
                              desktopMed: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Constants.size.circularBorderRadius,
                          ),
                          child: TextField(
                            autocorrect: false,
                            enableSuggestions: false,
                            controller: portController,
                            focusNode: portFocusNode,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              setState(() {
                                _enableStartButton = value.isNotEmpty &&
                                    serverController.text.isNotEmpty &&
                                    fusionRoundController.text.isNotEmpty;
                              });
                            },
                            style: STextStyles.field(context),
                            decoration: standardInputDecoration(
                              "Port",
                              portFocusNode,
                              context,
                              desktopMed: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _enableSSLCheckbox = !_enableSSLCheckbox;
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: _enableSSLCheckbox,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          _enableSSLCheckbox =
                                              !_enableSSLCheckbox;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Use SSL",
                                  style: STextStyles.itemSubtitle12(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Rounds of fusion",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<FusionOption>(
                            value: _roundType,
                            items: [
                              ...FusionOption.values.map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.name.capitalize(),
                                    style: STextStyles.smallMed14(context)
                                        .copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .textDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value is FusionOption) {
                                setState(() {
                                  _roundType = value;
                                });
                              }
                            },
                            isExpanded: true,
                            iconStyleData: IconStyleData(
                              icon: SvgPicture.asset(
                                Assets.svg.chevronDown,
                                width: 12,
                                height: 6,
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textFieldActiveSearchIconRight,
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              offset: const Offset(0, -10),
                              elevation: 0,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textFieldActiveBG,
                                borderRadius: BorderRadius.circular(
                                  Constants.size.circularBorderRadius,
                                ),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        if (_roundType == FusionOption.custom)
                          const SizedBox(
                            height: 10,
                          ),
                        if (_roundType == FusionOption.custom)
                          SizedBox(
                            width: 460,
                            child: RoundedWhiteContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Constants.size.circularBorderRadius,
                                    ),
                                    child: TextField(
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      controller: fusionRoundController,
                                      focusNode: fusionRoundFocusNode,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _enableStartButton = value
                                                  .isNotEmpty &&
                                              serverController
                                                  .text.isNotEmpty &&
                                              portController.text.isNotEmpty;
                                        });
                                      },
                                      style: STextStyles.field(context),
                                      decoration: standardInputDecoration(
                                        "Number of fusions",
                                        fusionRoundFocusNode,
                                        context,
                                        desktopMed: true,
                                      ).copyWith(
                                        labelText: "Enter number of fusions..",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryButton(
                          label: "Start",
                          enabled: _enableStartButton,
                          onPressed: _startFusion,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
