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
import 'package:event_bus/event_bus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages_desktop_specific/cashfusion/sub_widgets/fusion_dialog.dart';
import 'package:stackwallet/pages_desktop_specific/desktop_menu.dart';
import 'package:stackwallet/pages_desktop_specific/settings/settings_menu.dart';
import 'package:stackwallet/providers/cash_fusion/fusion_progress_ui_state_provider.dart';
import 'package:stackwallet/providers/desktop/current_desktop_menu_item.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/providers/ui/check_box_state_provider.dart';
import 'package:stackwallet/services/event_bus/events/global/tor_connection_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/global_event_bus.dart';
import 'package:stackwallet/services/mixins/fusion_wallet_interface.dart';
import 'package:stackwallet/services/tor_service.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_app_bar.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_scaffold.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';

enum FusionRounds {
  Continuous,
  Custom;
}

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

  String _serverTerm = "";
  String _portTerm = "";
  String _fusionRoundTerm = "";

  bool _useSSL = false;
  bool _trusted = false;
  int? port;
  late bool enableSSLCheckbox;
  late final bool enableAuthFields;

  FusionRounds _roundType = FusionRounds.Continuous;

  /// The global event bus.
  late final EventBus eventBus;

  /// The subscription to the TorConnectionStatusChangedEvent.
  late final StreamSubscription<TorConnectionStatusChangedEvent>
      _torConnectionStatusSubscription;

  /// The current status of the Tor connection.
  late TorConnectionStatus _torConnectionStatus =
      TorConnectionStatus.disconnected;

  /// Build the connect/disconnect button
  /// pushes to Tor settings
  Widget _buildConnectButton(TorConnectionStatus status) {
    switch (status) {
      case TorConnectionStatus.disconnected:
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              ref.read(currentDesktopMenuItemProvider.state).state =
                  DesktopMenuItemId.settings;
              ref.watch(selectedSettingsMenuItemStateProvider.state).state = 4;
            },
            child: Text(
              "Connect",
              style: STextStyles.richLink(context).copyWith(
                fontSize: 14,
              ),
            ),
          ),
        );
      case TorConnectionStatus.connecting:
        return AbsorbPointer(
          child: Text(
            "Connecting",
            style: STextStyles.richLink(context).copyWith(
              fontSize: 14,
            ),
          ),
        );
      case TorConnectionStatus.connected:
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              ref.read(currentDesktopMenuItemProvider.state).state =
                  DesktopMenuItemId.settings;
              ref.watch(selectedSettingsMenuItemStateProvider.state).state = 4;
            },
            child: Text(
              "Disconnect",
              style: STextStyles.richLink(context).copyWith(
                fontSize: 14,
              ),
            ),
          ),
        );
    }
  }

  @override
  void initState() {
    serverController = TextEditingController();
    portController = TextEditingController();
    fusionRoundController = TextEditingController();

    serverFocusNode = FocusNode();
    portFocusNode = FocusNode();
    fusionRoundFocusNode = FocusNode();

    enableSSLCheckbox = true;

    // Initialize the global event bus.
    eventBus = GlobalEventBus.instance;

    // Initialize the TorConnectionStatus.
    _torConnectionStatus = ref.read(pTorService).status;

    // Subscribe to the TorConnectionStatusChangedEvent.
    _torConnectionStatusSubscription =
        eventBus.on<TorConnectionStatusChangedEvent>().listen(
      (event) async {
        // Rebuild the widget.
        setState(() {
          _torConnectionStatus = event.newStatus;
        });
      },
    );

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
                      "CashFusion",
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
                            text: "What is CashFusion?",
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
                                                  "What is CashFusion?",
                                                  style: STextStyles.desktopH2(
                                                      context),
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
                                                          context)
                                                      .copyWith(
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
                          "CashFusion allows you to anonymize your BCH coins."
                          "\nYou must be connected to the Tor network.",
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
                        Text(
                          "Server settings",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
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
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            final value =
                                ref.read(checkBoxStateProvider.state).state;
                            ref.read(checkBoxStateProvider.state).state =
                                !value;
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    // fillColor: enableSSLCheckbox
                                    //     ? null
                                    //     : MaterialStateProperty.all(
                                    //         Theme.of(context)
                                    //             .extension<StackColors>()!
                                    //             .checkboxBGDisabled),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: ref
                                        .watch(checkBoxStateProvider.state)
                                        .state,
                                    onChanged: (newValue) {
                                      ref
                                          .watch(checkBoxStateProvider.state)
                                          .state = newValue!;
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
                          child: DropdownButton2<FusionRounds>(
                            value: _roundType,
                            items: [
                              ...FusionRounds.values.map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.name,
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
                              if (value is FusionRounds) {
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
                        if (_roundType == FusionRounds.Custom)
                          const SizedBox(
                            height: 10,
                          ),
                        if (_roundType == FusionRounds.Custom)
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
                                      onChanged: (value) {
                                        setState(() {
                                          _fusionRoundTerm = value;
                                        });
                                      },
                                      style: STextStyles.field(context),
                                      decoration: standardInputDecoration(
                                        "",
                                        fusionRoundFocusNode,
                                        context,
                                        desktopMed: true,
                                      ).copyWith(
                                          labelText:
                                              "Enter number of fusions.."),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tor status",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                  context),
                            ),
                            _buildConnectButton(_torConnectionStatus),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RoundedWhiteContainer(
                          borderColor: Theme.of(context)
                              .extension<StackColors>()!
                              .shadow,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.svg.circleTor,
                                width: 48,
                                height: 48,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tor Network",
                                    style: STextStyles.itemSubtitle12(context),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(_torConnectionStatus.name.capitalize(),
                                      style: STextStyles
                                          .desktopTextExtraExtraSmall(context)),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryButton(
                          label: "Start",
                          onPressed: () async {
                            final fusionWallet = ref
                                .read(walletsChangeNotifierProvider)
                                .getManager(widget.walletId)
                                .wallet as FusionWalletInterface;

                            try {
                              fusionWallet.uiState = ref.read(
                                fusionProgressUIStateProvider(widget.walletId),
                              );
                            } catch (e) {
                              if (!e.toString().contains(
                                  "FusionProgressUIState was already set for ${widget.walletId}")) {
                                rethrow;
                              }
                            }

                            unawaited(fusionWallet.fuse());

                            await showDialog<void>(
                              context: context,
                              builder: (context) {
                                return FusionDialog(
                                  walletId: widget.walletId,
                                );
                              },
                            );
                          },
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
