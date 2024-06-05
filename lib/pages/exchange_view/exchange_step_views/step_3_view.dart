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

import '../../../models/exchange/incomplete_exchange.dart';
import '../../../models/exchange/response_objects/trade.dart';
import '../../../providers/global/trades_service_provider.dart';
import '../../../providers/providers.dart';
import '../../../services/exchange/exchange_response.dart';
import '../../../services/exchange/majestic_bank/majestic_bank_exchange.dart';
import '../../../services/notifications_api.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/clipboard_interface.dart';
import '../../../utilities/enums/exchange_rate_type_enum.dart';
import '../../../utilities/text_styles.dart';
import '../../../widgets/background.dart';
import '../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../widgets/custom_loading_overlay.dart';
import '../../../widgets/rounded_white_container.dart';
import '../../../widgets/stack_dialog.dart';
import '../sub_widgets/step_row.dart';
import 'step_4_view.dart';

class Step3View extends ConsumerStatefulWidget {
  const Step3View({
    super.key,
    required this.model,
    this.clipboard = const ClipboardWrapper(),
  });

  static const String routeName = "/exchangeStep3";

  final IncompleteExchangeModel model;
  final ClipboardInterface clipboard;

  @override
  ConsumerState<Step3View> createState() => _Step3ViewState();
}

class _Step3ViewState extends ConsumerState<Step3View> {
  late final IncompleteExchangeModel model;
  late final ClipboardInterface clipboard;

  @override
  void initState() {
    model = widget.model;
    clipboard = widget.clipboard;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final supportsRefund =
        ref.watch(efExchangeProvider).name != MajesticBankExchange.exchangeName;

    return Background(
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<StackColors>()!.background,
        appBar: AppBar(
          leading: AppBarBackButton(
            onPressed: () async {
              if (FocusScope.of(context).hasFocus) {
                FocusScope.of(context).unfocus();
                await Future<void>.delayed(const Duration(milliseconds: 75));
              }
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            "Swap",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = MediaQuery.of(context).size.width - 32;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 24,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StepRow(
                            count: 4,
                            current: 2,
                            width: width,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Confirm exchange details",
                            style: STextStyles.pageTitleH1(context),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          RoundedWhiteContainer(
                            child: Row(
                              children: [
                                Text(
                                  "You send",
                                  style: STextStyles.itemSubtitle(context),
                                ),
                                const Spacer(),
                                Text(
                                  "${model.sendAmount.toString()} ${model.sendTicker.toUpperCase()}",
                                  style: STextStyles.itemSubtitle12(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RoundedWhiteContainer(
                            child: Row(
                              children: [
                                Text(
                                  "You receive",
                                  style: STextStyles.itemSubtitle(context),
                                ),
                                const Spacer(),
                                Text(
                                  "${model.receiveAmount.toString()} ${model.receiveTicker.toUpperCase()}",
                                  style: STextStyles.itemSubtitle12(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RoundedWhiteContainer(
                            child: Row(
                              children: [
                                Text(
                                  "Estimated rate",
                                  style: STextStyles.itemSubtitle(context),
                                ),
                                const Spacer(),
                                Text(
                                  model.rateInfo,
                                  style: STextStyles.itemSubtitle12(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RoundedWhiteContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recipient ${model.receiveTicker.toUpperCase()} address",
                                  style: STextStyles.itemSubtitle(context),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  model.recipientAddress!,
                                  style: STextStyles.itemSubtitle12(context),
                                ),
                              ],
                            ),
                          ),
                          if (supportsRefund)
                            const SizedBox(
                              height: 8,
                            ),
                          if (supportsRefund)
                            RoundedWhiteContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Refund ${model.sendTicker.toUpperCase()} address",
                                    style: STextStyles.itemSubtitle(context),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    model.refundAddress!,
                                    style: STextStyles.itemSubtitle12(context),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: Theme.of(context)
                                      .extension<StackColors>()!
                                      .getSecondaryEnabledButtonStyle(context),
                                  child: Text(
                                    "Back",
                                    style: STextStyles.button(context).copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .buttonTextSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    unawaited(
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => WillPopScope(
                                          onWillPop: () async => false,
                                          child: Container(
                                            color: Theme.of(context)
                                                .extension<StackColors>()!
                                                .overlay
                                                .withOpacity(0.6),
                                            child: const CustomLoadingOverlay(
                                              message: "Creating a trade",
                                              eventBus: null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );

                                    final ExchangeResponse<Trade> response =
                                        await ref
                                            .read(efExchangeProvider)
                                            .createTrade(
                                              from: model.sendTicker,
                                              to: model.receiveTicker,
                                              fixedRate: model.rateType !=
                                                  ExchangeRateType.estimated,
                                              amount: model.reversed
                                                  ? model.receiveAmount
                                                  : model.sendAmount,
                                              addressTo:
                                                  model.recipientAddress!,
                                              extraId: null,
                                              addressRefund: supportsRefund
                                                  ? model.refundAddress!
                                                  : "",
                                              refundExtraId: "",
                                              estimate: model.estimate,
                                              reversed: model.reversed,
                                            );

                                    if (response.value == null) {
                                      if (mounted) {
                                        Navigator.of(context).pop();

                                        unawaited(
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (_) => StackDialog(
                                              title: "Failed to create trade",
                                              message: response.exception
                                                  ?.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                      return;
                                    }

                                    // save trade to hive
                                    await ref.read(tradesServiceProvider).add(
                                          trade: response.value!,
                                          shouldNotifyListeners: true,
                                        );

                                    String status = response.value!.status;

                                    model.trade = response.value!;

                                    // extra info if status is waiting
                                    if (status == "Waiting") {
                                      status += " for deposit";
                                    }

                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }

                                    unawaited(
                                      NotificationApi.showNotification(
                                        changeNowId: model.trade!.tradeId,
                                        title: status,
                                        body:
                                            "Trade ID ${model.trade!.tradeId}",
                                        walletId: "",
                                        iconAssetName: Assets.svg.arrowRotate,
                                        date: model.trade!.timestamp,
                                        shouldWatchForUpdates: true,
                                        coinName: "coinName",
                                      ),
                                    );

                                    if (mounted) {
                                      unawaited(
                                        Navigator.of(context).pushNamed(
                                          Step4View.routeName,
                                          arguments: model,
                                        ),
                                      );
                                    }
                                  },
                                  style: Theme.of(context)
                                      .extension<StackColors>()!
                                      .getPrimaryEnabledButtonStyle(context),
                                  child: Text(
                                    "Next",
                                    style: STextStyles.button(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
