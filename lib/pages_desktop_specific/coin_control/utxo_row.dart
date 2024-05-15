/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/models/isar/models/isar_models.dart';
import 'package:stackwallet/pages/coin_control/utxo_details_view.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/amount/amount_formatter.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/wallets/isar/providers/wallet_info_provider.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/icon_widgets/utxo_status_icon.dart';
import 'package:stackwallet/widgets/rounded_container.dart';

class UtxoRowData {
  UtxoRowData(this.utxoId, this.selected);

  Id utxoId;
  bool selected;

  @override
  String toString() {
    return "selected=$selected: $utxoId";
  }

  @override
  bool operator ==(Object other) {
    return other is UtxoRowData && other.utxoId == utxoId;
  }

  @override
  int get hashCode => Object.hashAll([utxoId.hashCode]);
}

class UtxoRow extends ConsumerStatefulWidget {
  const UtxoRow({
    Key? key,
    required this.data,
    required this.walletId,
    this.onSelectionChanged,
    this.compact = false,
    this.compactWithBorder = true,
    this.raiseOnSelected = true,
  }) : super(key: key);

  final String walletId;
  final UtxoRowData data;
  final void Function(UtxoRowData)? onSelectionChanged;
  final bool compact;
  final bool compactWithBorder;
  final bool raiseOnSelected;

  @override
  ConsumerState<UtxoRow> createState() => _UtxoRowState();
}

class _UtxoRowState extends ConsumerState<UtxoRow> {
  late Stream<UTXO?> stream;
  late UTXO utxo;

  void _details() async {
    await showDialog<String?>(
      context: context,
      builder: (context) => UtxoDetailsView(
        utxoId: utxo.id,
        walletId: widget.walletId,
      ),
    );
  }

  @override
  void initState() {
    utxo = MainDB.instance.isar.utxos
        .where()
        .idEqualTo(widget.data.utxoId)
        .findFirstSync()!;

    stream = MainDB.instance.watchUTXO(id: utxo.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final coin = ref.watch(pWalletCoin(widget.walletId));

    return StreamBuilder<UTXO?>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          utxo = snapshot.data!;
        }

        return RoundedContainer(
          borderColor: widget.compact && widget.compactWithBorder
              ? Theme.of(context).extension<StackColors>()!.textFieldDefaultBG
              : null,
          color: Theme.of(context).extension<StackColors>()!.popupBG,
          boxShadow: widget.data.selected && widget.raiseOnSelected
              ? [
                  Theme.of(context).extension<StackColors>()!.standardBoxShadow,
                ]
              : null,
          child: Row(
            children: [
              if (!(widget.compact && utxo.isBlocked))
                Checkbox(
                  value: widget.data.selected,
                  onChanged: (value) {
                    setState(() {
                      widget.data.selected = value!;
                    });
                    widget.onSelectionChanged?.call(widget.data);
                  },
                ),
              if (!(widget.compact && utxo.isBlocked))
                const SizedBox(
                  width: 10,
                ),
              UTXOStatusIcon(
                blocked: utxo.isBlocked,
                status: utxo.isConfirmed(
                  ref.watch(pWalletChainHeight(widget.walletId)),
                  ref
                      .watch(pWallets)
                      .getWallet(widget.walletId)
                      .cryptoCurrency
                      .minConfirms,
                )
                    ? UTXOStatusIconStatus.confirmed
                    : UTXOStatusIconStatus.unconfirmed,
                background: Theme.of(context).extension<StackColors>()!.popupBG,
                selected: false,
                width: 32,
                height: 32,
              ),
              const SizedBox(
                width: 10,
              ),
              if (!widget.compact)
                Text(
                  ref.watch(pAmountFormatter(coin)).format(
                        Amount(
                          rawValue: BigInt.from(utxo.value),
                          fractionDigits: coin.fractionDigits,
                        ),
                      ),
                  textAlign: TextAlign.right,
                  style: STextStyles.w600_14(context),
                ),
              if (!widget.compact)
                const SizedBox(
                  width: 10,
                ),
              Expanded(
                child: ConditionalParent(
                  condition: widget.compact,
                  builder: (child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ref.watch(pAmountFormatter(coin)).format(
                                Amount(
                                  rawValue: BigInt.from(utxo.value),
                                  fractionDigits: coin.fractionDigits,
                                ),
                              ),
                          textAlign: TextAlign.right,
                          style: STextStyles.w600_14(context),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        child,
                      ],
                    );
                  },
                  child: Text(
                    utxo.name.isNotEmpty
                        ? utxo.name
                        : utxo.address ?? utxo.txid,
                    textAlign:
                        widget.compact ? TextAlign.left : TextAlign.center,
                    style: STextStyles.w500_12(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textSubtitle1,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              widget.compact
                  ? CustomTextButton(
                      text: "Details",
                      onTap: _details,
                    )
                  : SecondaryButton(
                      width: 120,
                      buttonHeight: ButtonHeight.xs,
                      label: "Details",
                      onPressed: _details,
                    ),
            ],
          ),
        );
      },
    );
  }
}
