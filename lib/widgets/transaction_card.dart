import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/isar/models/isar_models.dart';
import 'package:stackwallet/notifications/show_flush_bar.dart';
import 'package:stackwallet/pages/wallet_view/sub_widgets/tx_icon.dart';
import 'package:stackwallet/pages/wallet_view/transaction_views/transaction_details_view.dart';
import 'package:stackwallet/providers/db/main_db_provider.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/utilities/amount.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/format.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:tuple/tuple.dart';

class TransactionCard extends ConsumerStatefulWidget {
  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.walletId,
  }) : super(key: key);

  final Transaction transaction;
  final String walletId;

  @override
  ConsumerState<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends ConsumerState<TransactionCard> {
  late final Transaction _transaction;
  late final String walletId;
  late final bool isTokenTx;
  late final String prefix;
  late final String unit;
  late final Coin coin;

  String whatIsIt(
    TransactionType type,
    Coin coin,
    int currentHeight,
  ) {
    if (coin == Coin.epicCash && _transaction.slateId == null) {
      return "Restored Funds";
    }

    final confirmedStatus = _transaction.isConfirmed(
      currentHeight,
      coin.requiredConfirmations,
    );

    if (type != TransactionType.incoming &&
        _transaction.subType == TransactionSubType.mint) {
      // if (type == "Received") {
      if (confirmedStatus) {
        return "Anonymized";
      } else {
        return "Anonymizing";
      }
      // } else if (type == "Sent") {
      //   if (_transaction.confirmedStatus) {
      //     return "Sent MINT";
      //   } else {
      //     return "Sending MINT";
      //   }
      // } else {
      //   return type;
      // }
    }

    if (type == TransactionType.incoming) {
      // if (_transaction.isMinting) {
      //   return "Minting";
      // } else
      if (confirmedStatus) {
        return "Received";
      } else {
        return "Receiving";
      }
    } else if (type == TransactionType.outgoing) {
      if (confirmedStatus) {
        return "Sent";
      } else {
        return "Sending";
      }
    } else if (type == TransactionType.sentToSelf) {
      return "Sent to self";
    } else {
      return type.name;
    }
  }

  @override
  void initState() {
    walletId = widget.walletId;
    _transaction = widget.transaction;
    isTokenTx = _transaction.subType == TransactionSubType.ethToken;
    if (Util.isDesktop) {
      if (_transaction.type == TransactionType.outgoing) {
        prefix = "-";
      } else if (_transaction.type == TransactionType.incoming) {
        prefix = "+";
      } else {
        prefix = "";
      }
    } else {
      prefix = "";
    }
    coin = ref
        .read(walletsChangeNotifierProvider)
        .getManager(widget.walletId)
        .coin;

    unit = isTokenTx
        ? ref
            .read(mainDBProvider)
            .getEthContractSync(_transaction.otherData!)!
            .symbol
        : coin.ticker;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(
        localeServiceChangeNotifierProvider.select((value) => value.locale));

    final baseCurrency = ref
        .watch(prefsChangeNotifierProvider.select((value) => value.currency));

    final price = ref
        .watch(priceAnd24hChangeNotifierProvider.select((value) => isTokenTx
            ? value.getTokenPrice(_transaction.otherData!)
            : value.getPrice(coin)))
        .item1;

    final currentHeight = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(walletId).currentHeight));

    return Material(
      color: Theme.of(context).extension<StackColors>()!.popupBG,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(Constants.size.circularBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
          ),
          onPressed: () async {
            if (coin == Coin.epicCash && _transaction.slateId == null) {
              unawaited(showFloatingFlushBar(
                context: context,
                message:
                    "Restored Epic funds from your Seed have no Data.\nUse Stack Backup to keep your transaction history.",
                type: FlushBarType.warning,
                duration: const Duration(seconds: 5),
              ));
              return;
            }
            if (Util.isDesktop) {
              await showDialog<void>(
                context: context,
                builder: (context) => DesktopDialog(
                  maxHeight: MediaQuery.of(context).size.height - 64,
                  maxWidth: 580,
                  child: TransactionDetailsView(
                    transaction: _transaction,
                    coin: coin,
                    walletId: walletId,
                  ),
                ),
              );
            } else {
              unawaited(
                Navigator.of(context).pushNamed(
                  TransactionDetailsView.routeName,
                  arguments: Tuple3(
                    _transaction,
                    coin,
                    walletId,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                TxIcon(
                  transaction: _transaction,
                  coin: coin,
                  currentHeight: currentHeight,
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _transaction.isCancelled
                                    ? "Cancelled"
                                    : whatIsIt(
                                        _transaction.type,
                                        coin,
                                        currentHeight,
                                      ),
                                style: STextStyles.itemSubtitle12(context),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Builder(
                                builder: (_) {
                                  final amount = _transaction.realAmount;

                                  return Text(
                                    "$prefix${amount.localizedStringAsFixed(
                                      locale: locale,
                                    )} $unit",
                                    style: STextStyles.itemSubtitle12(context),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                Format.extractDateFrom(_transaction.timestamp),
                                style: STextStyles.label(context),
                              ),
                            ),
                          ),
                          if (ref.watch(prefsChangeNotifierProvider
                              .select((value) => value.externalCalls)))
                            const SizedBox(
                              width: 10,
                            ),
                          if (ref.watch(prefsChangeNotifierProvider
                              .select((value) => value.externalCalls)))
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Builder(
                                  builder: (_) {
                                    final amount = _transaction.realAmount;

                                    return Text(
                                      "$prefix${Amount.fromDecimal(
                                        amount.decimal * price,
                                        fractionDigits: 2,
                                      ).localizedStringAsFixed(
                                        locale: locale,
                                        decimalPlaces: 2,
                                      )} $baseCurrency",
                                      style: STextStyles.label(context),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
