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
import 'package:tuple/tuple.dart';

import '../../../app_config.dart';
import '../../../models/exchange/incomplete_exchange.dart';
import '../../../notifications/show_flush_bar.dart';
import '../../../providers/providers.dart';
import '../../../route_generator.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/amount/amount.dart';
import '../../../utilities/amount/amount_formatter.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/clipboard_interface.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/enums/fee_rate_type_enum.dart';
import '../../../utilities/text_styles.dart';
import '../../../wallets/crypto_currency/crypto_currency.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../wallets/models/tx_data.dart';
import '../../../wallets/wallet/impl/firo_wallet.dart';
import '../../../widgets/background.dart';
import '../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../widgets/desktop/secondary_button.dart';
import '../../../widgets/rounded_container.dart';
import '../../../widgets/rounded_white_container.dart';
import '../../../widgets/stack_dialog.dart';
import '../../home_view/home_view.dart';
import '../../send_view/sub_widgets/building_transaction_dialog.dart';
import '../../wallet_view/wallet_view.dart';
import '../confirm_change_now_send.dart';
import '../send_from_view.dart';
import '../sub_widgets/step_row.dart';

class Step4View extends ConsumerStatefulWidget {
  const Step4View({
    Key? key,
    required this.model,
    this.clipboard = const ClipboardWrapper(),
  }) : super(key: key);

  static const String routeName = "/exchangeStep4";

  final IncompleteExchangeModel model;
  final ClipboardInterface clipboard;

  @override
  ConsumerState<Step4View> createState() => _Step4ViewState();
}

class _Step4ViewState extends ConsumerState<Step4View> {
  late final IncompleteExchangeModel model;
  late final ClipboardInterface clipboard;

  String _statusString = "New";

  Timer? _statusTimer;

  bool _isWalletCoinAndHasWallet(String ticker, WidgetRef ref) {
    try {
      final coin = AppConfig.getCryptoCurrencyForTicker(ticker);
      return ref
          .read(pWallets)
          .wallets
          .where((e) => e.info.coin == coin)
          .isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _updateStatus() async {
    final statusResponse =
        await ref.read(efExchangeProvider).updateTrade(model.trade!);
    String status = "Waiting";
    if (statusResponse.value != null) {
      status = statusResponse.value!.status;
    }

    // extra info if status is waiting
    if (status == "Waiting") {
      status += " for deposit";
    }

    if (mounted) {
      setState(() {
        _statusString = status;
      });
    }
  }

  @override
  void initState() {
    model = widget.model;
    clipboard = widget.clipboard;

    _statusTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _updateStatus();
    });

    super.initState();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _statusTimer = null;
    super.dispose();
  }

  Future<void> _close() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future<void>.delayed(const Duration(milliseconds: 75));
    }
    if (mounted) {
      Navigator.of(context).popUntil(
        ModalRoute.withName(
          model.walletInitiated ? WalletView.routeName : HomeView.routeName,
        ),
      );
    }
  }

  Future<bool?> _showSendFromFiroBalanceSelectSheet(String walletId) async {
    final coin = ref.read(pWalletCoin(walletId));
    final balancePublic = ref.read(pWalletBalance(walletId));
    final balancePrivate = ref.read(pWalletBalanceTertiary(walletId));

    return await showModalBottomSheet<bool?>(
      context: context,
      backgroundColor:
          Theme.of(context).extension<StackColors>()!.backgroundAppBar,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Constants.size.circularBorderRadius * 3,
          ),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 32,
              ),
              Text(
                "Select Firo balance",
                style: STextStyles.pageTitleH2(context),
              ),
              const SizedBox(
                height: 32,
              ),
              SecondaryButton(
                label:
                    "${ref.watch(pAmountFormatter(coin)).format(balancePrivate.spendable)} (private)",
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(
                height: 16,
              ),
              SecondaryButton(
                label:
                    "${ref.watch(pAmountFormatter(coin)).format(balancePublic.spendable)} (public)",
                onPressed: () => Navigator.of(context).pop(true),
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmSend(Tuple2<String, CryptoCurrency> tuple) async {
    final bool firoPublicSend;
    if (tuple.item2 is Firo) {
      final result = await _showSendFromFiroBalanceSelectSheet(tuple.item1);
      if (result == null) {
        return;
      } else {
        firoPublicSend = result;
      }
    } else {
      firoPublicSend = false;
    }

    final wallet = ref.read(pWallets).getWallet(tuple.item1);

    final Amount amount = model.sendAmount.toAmount(
      fractionDigits: wallet.info.coin.fractionDigits,
    );
    final address = model.trade!.payInAddress;

    bool wasCancelled = false;
    try {
      if (!mounted) return;

      unawaited(
        showDialog<dynamic>(
          context: context,
          useSafeArea: false,
          barrierDismissible: false,
          builder: (context) {
            return BuildingTransactionDialog(
              coin: wallet.info.coin,
              isSpark: wallet is FiroWallet && !firoPublicSend,
              onCancel: () {
                wasCancelled = true;
              },
            );
          },
        ),
      );

      final time = Future<dynamic>.delayed(
        const Duration(
          milliseconds: 2500,
        ),
      );

      Future<TxData> txDataFuture;

      if (wallet is FiroWallet && !firoPublicSend) {
        txDataFuture = wallet.prepareSendSpark(
          txData: TxData(
            recipients: [
              (
                address: address,
                amount: amount,
                isChange: false,
              ),
            ],
            note: "${model.trade!.payInCurrency.toUpperCase()}/"
                "${model.trade!.payOutCurrency.toUpperCase()} exchange",
          ),
        );
      } else {
        final memo = wallet.info.coin is Stellar
            ? model.trade!.payInExtraId.isNotEmpty
                ? model.trade!.payInExtraId
                : null
            : null;
        txDataFuture = wallet.prepareSend(
          txData: TxData(
            recipients: [
              (
                address: address,
                amount: amount,
                isChange: false,
              ),
            ],
            memo: memo,
            feeRateType: FeeRateType.average,
            note: "${model.trade!.payInCurrency.toUpperCase()}/"
                "${model.trade!.payOutCurrency.toUpperCase()} exchange",
          ),
        );
      }

      final results = await Future.wait([
        txDataFuture,
        time,
      ]);

      final txData = results.first as TxData;

      if (!wasCancelled) {
        // pop building dialog

        if (mounted) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          unawaited(
            Navigator.of(context).push(
              RouteGenerator.getRoute(
                shouldUseMaterialRoute: RouteGenerator.useMaterialPageRoute,
                builder: (_) => ConfirmChangeNowSendView(
                  txData: txData,
                  walletId: tuple.item1,
                  routeOnSuccessName: HomeView.routeName,
                  trade: model.trade!,
                  shouldSendPublicFiroFunds: firoPublicSend,
                ),
                settings: const RouteSettings(
                  name: ConfirmChangeNowSendView.routeName,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && !wasCancelled) {
        // pop building dialog
        Navigator.of(context).pop();

        unawaited(
          showDialog<dynamic>(
            context: context,
            useSafeArea: false,
            barrierDismissible: true,
            builder: (context) {
              return StackDialog(
                title: "Transaction failed",
                message: e.toString(),
                rightButton: TextButton(
                  style: Theme.of(context)
                      .extension<StackColors>()!
                      .getSecondaryEnabledButtonStyle(context),
                  child: Text(
                    "Ok",
                    style: STextStyles.button(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .buttonTextSecondary,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWalletCoin =
        _isWalletCoinAndHasWallet(model.trade!.payInCurrency, ref);
    return WillPopScope(
      onWillPop: () async {
        await _close();
        return false;
      },
      child: Background(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: AppBarIconButton(
                size: 32,
                color: Theme.of(context).extension<StackColors>()!.background,
                shadows: const [],
                icon: SvgPicture.asset(
                  Assets.svg.x,
                  width: 24,
                  height: 24,
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .topNavIconPrimary,
                ),
                onPressed: _close,
              ),
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
                              current: 3,
                              width: width,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              "Send ${model.sendTicker.toUpperCase()} to the address below",
                              style: STextStyles.pageTitleH1(context),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Send ${model.sendTicker.toUpperCase()} to the address below. Once it is received, ${model.trade!.exchangeName} will send the ${model.receiveTicker.toUpperCase()} to the recipient address you provided. You can find this trade details and check its status in the list of trades.",
                              style: STextStyles.itemSubtitle(context),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            RoundedContainer(
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .warningBackground,
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      "You must send at least ${model.sendAmount.toString()} ${model.sendTicker}. ",
                                  style: STextStyles.label700(context).copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .warningForeground,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "If you send less than ${model.sendAmount.toString()} ${model.sendTicker}, your transaction may not be converted and it may not be refunded.",
                                      style:
                                          STextStyles.label(context).copyWith(
                                        color: Theme.of(context)
                                            .extension<StackColors>()!
                                            .warningForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            RoundedWhiteContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Amount",
                                        style:
                                            STextStyles.itemSubtitle(context),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final data = ClipboardData(
                                            text: model.sendAmount.toString(),
                                          );
                                          await clipboard.setData(data);
                                          if (context.mounted) {
                                            unawaited(
                                              showFloatingFlushBar(
                                                type: FlushBarType.info,
                                                message: "Copied to clipboard",
                                                context: context,
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.svg.copy,
                                              color: Theme.of(context)
                                                  .extension<StackColors>()!
                                                  .infoItemIcons,
                                              width: 10,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Copy",
                                              style: STextStyles.link2(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Send ${model.sendTicker.toUpperCase()} to this address",
                                        style:
                                            STextStyles.itemSubtitle(context),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final data = ClipboardData(
                                            text: model.trade!.payInAddress,
                                          );
                                          await clipboard.setData(data);
                                          if (context.mounted) {
                                            unawaited(
                                              showFloatingFlushBar(
                                                type: FlushBarType.info,
                                                message: "Copied to clipboard",
                                                context: context,
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.svg.copy,
                                              color: Theme.of(context)
                                                  .extension<StackColors>()!
                                                  .infoItemIcons,
                                              width: 10,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Copy",
                                              style: STextStyles.link2(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    model.trade!.payInAddress,
                                    style: STextStyles.itemSubtitle12(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            if (model.trade!.payInExtraId.isNotEmpty)
                              RoundedWhiteContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Memo",
                                          style:
                                              STextStyles.itemSubtitle(context),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final data = ClipboardData(
                                              text: model.trade!.payInExtraId,
                                            );
                                            await clipboard.setData(data);
                                            if (context.mounted) {
                                              unawaited(
                                                showFloatingFlushBar(
                                                  type: FlushBarType.info,
                                                  message:
                                                      "Copied to clipboard",
                                                  context: context,
                                                ),
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                Assets.svg.copy,
                                                color: Theme.of(context)
                                                    .extension<StackColors>()!
                                                    .infoItemIcons,
                                                width: 10,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                "Copy",
                                                style:
                                                    STextStyles.link2(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      model.trade!.payInExtraId,
                                      style:
                                          STextStyles.itemSubtitle12(context),
                                    ),
                                  ],
                                ),
                              ),
                            if (model.trade!.payInExtraId.isNotEmpty)
                              const SizedBox(
                                height: 6,
                              ),
                            RoundedWhiteContainer(
                              child: Row(
                                children: [
                                  Text(
                                    "Trade ID",
                                    style: STextStyles.itemSubtitle(context),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        model.trade!.tradeId,
                                        style:
                                            STextStyles.itemSubtitle12(context),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final data = ClipboardData(
                                            text: model.trade!.tradeId,
                                          );
                                          await clipboard.setData(data);
                                          if (context.mounted) {
                                            unawaited(
                                              showFloatingFlushBar(
                                                type: FlushBarType.info,
                                                message: "Copied to clipboard",
                                                context: context,
                                              ),
                                            );
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          Assets.svg.copy,
                                          color: Theme.of(context)
                                              .extension<StackColors>()!
                                              .infoItemIcons,
                                          width: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            RoundedWhiteContainer(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Status",
                                    style: STextStyles.itemSubtitle(context),
                                  ),
                                  Text(
                                    _statusString,
                                    style: STextStyles.itemSubtitle(context)
                                        .copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .colorForStatus(_statusString),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 12,
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog<dynamic>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) {
                                    return StackDialogBase(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Center(
                                            child: Text(
                                              "Send ${model.sendTicker} to this address",
                                              style: STextStyles.pageTitleH2(
                                                context,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Center(
                                            child: QrImageView(
                                              // TODO: grab coin uri scheme from somewhere
                                              // data: "${coin.uriScheme}:$receivingAddress",
                                              data: model.trade!.payInAddress,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              foregroundColor: Theme.of(context)
                                                  .extension<StackColors>()!
                                                  .accentColorDark,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  style: Theme.of(context)
                                                      .extension<StackColors>()!
                                                      .getSecondaryEnabledButtonStyle(
                                                        context,
                                                      ),
                                                  child: Text(
                                                    "Cancel",
                                                    style: STextStyles.button(
                                                      context,
                                                    ).copyWith(
                                                      color: Theme.of(context)
                                                          .extension<
                                                              StackColors>()!
                                                          .buttonTextSecondary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              style: Theme.of(context)
                                  .extension<StackColors>()!
                                  .getPrimaryEnabledButtonStyle(context),
                              child: Text(
                                "Show QR Code",
                                style: STextStyles.button(context),
                              ),
                            ),
                            if (isWalletCoin)
                              const SizedBox(
                                height: 12,
                              ),
                            if (isWalletCoin)
                              Builder(
                                builder: (context) {
                                  String buttonTitle =
                                      "Send from ${AppConfig.appName}";

                                  final tuple = ref
                                      .read(
                                        exchangeSendFromWalletIdStateProvider
                                            .state,
                                      )
                                      .state;
                                  if (tuple != null &&
                                      model.sendTicker.toLowerCase() ==
                                          tuple.item2.ticker.toLowerCase()) {
                                    final walletName = ref
                                        .read(pWallets)
                                        .getWallet(tuple.item1)
                                        .info
                                        .name;
                                    buttonTitle = "Send from $walletName";
                                  }

                                  return TextButton(
                                    onPressed: tuple != null &&
                                            model.sendTicker.toLowerCase() ==
                                                tuple.item2.ticker.toLowerCase()
                                        ? () async {
                                            await _confirmSend(tuple);
                                          }
                                        : () {
                                            Navigator.of(context).push(
                                              RouteGenerator.getRoute(
                                                shouldUseMaterialRoute:
                                                    RouteGenerator
                                                        .useMaterialPageRoute,
                                                builder:
                                                    (BuildContext context) {
                                                  final coin = AppConfig.coins
                                                      .firstWhere(
                                                    (e) =>
                                                        e.ticker
                                                            .toLowerCase() ==
                                                        model.trade!
                                                            .payInCurrency
                                                            .toLowerCase(),
                                                  );

                                                  return SendFromView(
                                                    coin: coin,
                                                    amount: model.sendAmount
                                                        .toAmount(
                                                      fractionDigits:
                                                          coin.fractionDigits,
                                                    ),
                                                    address: model
                                                        .trade!.payInAddress,
                                                    trade: model.trade!,
                                                  );
                                                },
                                                settings: const RouteSettings(
                                                  name: SendFromView.routeName,
                                                ),
                                              ),
                                            );
                                          },
                                    style: Theme.of(context)
                                        .extension<StackColors>()!
                                        .getSecondaryEnabledButtonStyle(
                                          context,
                                        ),
                                    child: Text(
                                      buttonTitle,
                                      style:
                                          STextStyles.button(context).copyWith(
                                        color: Theme.of(context)
                                            .extension<StackColors>()!
                                            .buttonTextSecondary,
                                      ),
                                    ),
                                  );
                                },
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
      ),
    );
  }
}
