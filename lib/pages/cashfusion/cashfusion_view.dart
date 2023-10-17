/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by sneurlax on 2023-07-26
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages/cashfusion/fusion_progress_view.dart';
import 'package:stackwallet/pages/cashfusion/fusion_rounds_selection_sheet.dart';
import 'package:stackwallet/providers/cash_fusion/fusion_progress_ui_state_provider.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/mixins/fusion_wallet_interface.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/rounded_container.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';

class CashFusionView extends ConsumerStatefulWidget {
  const CashFusionView({
    super.key,
    required this.walletId,
  });

  static const routeName = "/cashFusionView";

  final String walletId;

  @override
  ConsumerState<CashFusionView> createState() => _CashFusionViewState();
}

class _CashFusionViewState extends ConsumerState<CashFusionView> {
  late final TextEditingController serverController;
  late final FocusNode serverFocusNode;
  late final TextEditingController portController;
  late final FocusNode portFocusNode;
  late final TextEditingController fusionRoundController;
  late final FocusNode fusionRoundFocusNode;

  bool _enableSSLCheckbox = false;
  bool _enableStartButton = false;

  FusionOption _option = FusionOption.continuous;

  @override
  void initState() {
    serverController = TextEditingController();
    portController = TextEditingController();
    fusionRoundController = TextEditingController();

    serverFocusNode = FocusNode();
    portFocusNode = FocusNode();
    fusionRoundFocusNode = FocusNode();

    final info = ref.read(prefsChangeNotifierProvider).fusionServerInfo;
    serverController.text = info.host;
    portController.text = info.port.toString();
    _enableSSLCheckbox = info.ssl;
    _option = info.rounds == 0 ? FusionOption.continuous : FusionOption.custom;
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
    return Background(
      child: SafeArea(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const AppBarBackButton(),
            title: Text(
              "CashFusion",
              style: STextStyles.navBarTitle(context),
            ),
            titleSpacing: 0,
            actions: [
              AspectRatio(
                aspectRatio: 1,
                child: AppBarIconButton(
                  size: 36,
                  icon: SvgPicture.asset(
                    Assets.svg.circleQuestion,
                    width: 20,
                    height: 20,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .topNavIconPrimary,
                  ),
                  onPressed: () async {
                    //' TODO show about?
                  },
                ),
              ),
            ],
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RoundedWhiteContainer(
                            child: Text(
                              "CashFusion allows you to anonymize your BCH coins."
                              " You must be connected to the Tor network.",
                              style: STextStyles.w500_12(context).copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textSubtitle1,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Server settings",
                                style: STextStyles.w500_14(context).copyWith(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textDark3,
                                ),
                              ),
                              CustomTextButton(
                                text: "Default",
                                onTap: () {
                                  const def = FusionInfo.DEFAULTS;
                                  serverController.text = def.host;
                                  portController.text = def.port.toString();
                                  fusionRoundController.text =
                                      def.rounds.toString();
                                  _option = FusionOption.continuous;
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
                            height: 10,
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
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
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
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
                            height: 16,
                          ),
                          Text(
                            "Rounds of fusion",
                            style: STextStyles.w500_14(context).copyWith(
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textDark3,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          RoundedContainer(
                            onPressed: () async {
                              final option =
                                  await showModalBottomSheet<FusionOption?>(
                                backgroundColor: Colors.transparent,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) {
                                  return FusionRoundCountSelectSheet(
                                    currentOption: _option,
                                  );
                                },
                              );
                              if (option != null) {
                                setState(() {
                                  _option = option;
                                });
                              }
                            },
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textFieldActiveBG,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _option.name.capitalize(),
                                    style: STextStyles.w500_12(context),
                                  ),
                                  SvgPicture.asset(
                                    Assets.svg.chevronDown,
                                    width: 12,
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textSubtitle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_option == FusionOption.custom)
                            const SizedBox(
                              height: 10,
                            ),
                          if (_option == FusionOption.custom)
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
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _enableStartButton = value.isNotEmpty &&
                                        serverController.text.isNotEmpty &&
                                        portController.text.isNotEmpty;
                                  });
                                },
                                style: STextStyles.field(context),
                                decoration: standardInputDecoration(
                                  "Number of fusions",
                                  fusionRoundFocusNode,
                                  context,
                                ).copyWith(
                                    labelText: "Enter number of fusions.."),
                              ),
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Spacer(),
                          PrimaryButton(
                            label: "Start",
                            enabled: _enableStartButton,
                            onPressed: () async {
                              final fusionWallet = ref
                                  .read(walletsChangeNotifierProvider)
                                  .getManager(widget.walletId)
                                  .wallet as FusionWalletInterface;

                              try {
                                fusionWallet.uiState = ref.read(
                                  fusionProgressUIStateProvider(
                                      widget.walletId),
                                );
                              } catch (e) {
                                if (!e.toString().contains(
                                    "FusionProgressUIState was already set for ${widget.walletId}")) {
                                  rethrow;
                                }
                              }

                              final int rounds =
                                  _option == FusionOption.continuous
                                      ? 0
                                      : int.parse(fusionRoundController.text);

                              final newInfo = FusionInfo(
                                host: serverController.text,
                                port: int.parse(portController.text),
                                ssl: _enableSSLCheckbox,
                                rounds: rounds,
                              );

                              // update user prefs (persistent)
                              ref
                                  .read(prefsChangeNotifierProvider)
                                  .fusionServerInfo = newInfo;

                              unawaited(
                                fusionWallet.fuse(
                                  fusionInfo: newInfo,
                                ),
                              );

                              await Navigator.of(context).pushNamed(
                                FusionProgressView.routeName,
                                arguments: widget.walletId,
                              );
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
    );
  }
}
