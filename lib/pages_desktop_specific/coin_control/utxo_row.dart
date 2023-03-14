import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/db/main_db.dart';
import 'package:stackwallet/models/isar/models/isar_models.dart';
import 'package:stackwallet/pages/coin_control/utxo_details_view.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/format.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/icon_widgets/utxo_status_icon.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class UtxoRowData {
  UtxoRowData(this.utxo, this.selected);

  UTXO utxo;
  bool selected;

  @override
  String toString() {
    return "selected=$selected: $utxo";
  }

  @override
  bool operator ==(Object other) {
    return other is UtxoRowData && other.utxo == utxo;
  }

  @override
  int get hashCode => Object.hashAll([utxo.hashCode]);
}

class UtxoRow extends ConsumerStatefulWidget {
  const UtxoRow({
    Key? key,
    required this.data,
    required this.walletId,
    this.onSelectionChanged,
  }) : super(key: key);

  final String walletId;
  final UtxoRowData data;
  final void Function(UtxoRowData)? onSelectionChanged;

  @override
  ConsumerState<UtxoRow> createState() => _UtxoRowState();
}

class _UtxoRowState extends ConsumerState<UtxoRow> {
  late Stream<UTXO?> stream;
  late UTXO utxo;

  @override
  void initState() {
    utxo = widget.data.utxo;

    stream = MainDB.instance.watchUTXO(id: utxo.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final coin = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(widget.walletId).coin));

    final currentChainHeight = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(widget.walletId).currentHeight));

    return StreamBuilder<UTXO?>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          utxo = snapshot.data!;
        }

        return RoundedWhiteContainer(
          boxShadow: widget.data.selected
              ? [
                  Theme.of(context).extension<StackColors>()!.standardBoxShadow,
                ]
              : null,
          child: Row(
            children: [
              Checkbox(
                value: widget.data.selected,
                onChanged: (value) {
                  setState(() {
                    widget.data.selected = value!;
                  });
                  widget.onSelectionChanged?.call(widget.data);
                },
              ),
              const SizedBox(
                width: 10,
              ),
              UTXOStatusIcon(
                blocked: utxo.isBlocked,
                status: utxo.isConfirmed(
                  currentChainHeight,
                  coin.requiredConfirmations,
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
              Text(
                "${Format.satoshisToAmount(
                  utxo.value,
                  coin: coin,
                ).toStringAsFixed(coin.decimals)} ${coin.ticker}",
                textAlign: TextAlign.right,
                style: STextStyles.w600_14(context),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 13,
                child: Text(
                  utxo.name.isNotEmpty ? utxo.name : utxo.address ?? utxo.txid,
                  textAlign: TextAlign.center,
                  style: STextStyles.w500_12(context).copyWith(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textSubtitle1,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SecondaryButton(
                width: 120,
                buttonHeight: ButtonHeight.xs,
                label: "Details",
                onPressed: () async {
                  await showDialog<String?>(
                    context: context,
                    builder: (context) => UtxoDetailsView(
                      utxoId: utxo.id,
                      walletId: widget.walletId,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
