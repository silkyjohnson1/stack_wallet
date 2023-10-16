/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by sneurlax on 2023-07-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages/cashfusion/fusion_rounds_selection_sheet.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/mixins/fusion_wallet_interface.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
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

  String _serverTerm = "";
  String _portTerm = "";
  late bool enableSSLCheckbox;

  FusionOption _option = FusionOption.continuous;

  @override
  void initState() {
    serverController = TextEditingController();
    portController = TextEditingController();

    serverFocusNode = FocusNode();
    portFocusNode = FocusNode();
  }

  @override
  void dispose() {
    serverController.dispose();
    portController.dispose();

    serverFocusNode.dispose();
    portFocusNode.dispose();

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
                          Text(
                            "Server settings",
                            style: STextStyles.w500_14(context).copyWith(
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textDark3,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextField(
                              autocorrect: false,
                              enableSuggestions: false,
                              controller: serverController,
                              focusNode: serverFocusNode,
                              onChanged: (value) {
                                setState(() {
                                  _serverTerm = value;
                                });
                              },
                              style: STextStyles.field(context),
                              decoration: standardInputDecoration(
                                "Server",
                                serverFocusNode,
                                context,
                                desktopMed: true,
                              )
                              // .copyWith(labelStyle: ),
                              ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            autocorrect: false,
                            enableSuggestions: false,
                            controller: portController,
                            focusNode: portFocusNode,
                            onChanged: (value) {
                              setState(() {
                                _portTerm = value;
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
                          const SizedBox(
                            height: 10,
                          ),
                          Checkbox(
                            value: true,
                            onChanged: (_) {},
                          ), // TODO replace placholder Checkbox
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
                          const SizedBox(
                            height: 16,
                          ),

                          const Spacer(),
                          PrimaryButton(
                            label: "Start",
                            onPressed: () => {
                              (ref
                                      .read(walletsChangeNotifierProvider)
                                      .getManager(widget.walletId)
                                      .wallet as FusionWalletInterface)
                                  .fuse(
                                      serverHost: _serverTerm,
                                      serverPort: int.parse(_portTerm))
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
