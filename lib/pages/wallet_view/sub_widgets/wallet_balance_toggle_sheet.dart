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
import 'package:stackwallet/models/balance.dart';
import 'package:stackwallet/providers/wallet/public_private_balance_state_provider.dart';
import 'package:stackwallet/providers/wallet/wallet_balance_toggle_state_provider.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/amount/amount_formatter.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/enums/wallet_balance_toggle_state.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/wallets/isar/providers/wallet_info_provider.dart';

enum _BalanceType {
  available,
  full,
  lelantusAvailable,
  lelantusFull,
  sparkAvailable,
  sparkFull;
}

class WalletBalanceToggleSheet extends ConsumerWidget {
  const WalletBalanceToggleSheet({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxHeight = MediaQuery.of(context).size.height * 0.90;

    final coin = ref.watch(pWalletCoin(walletId));
    final isFiro = coin == Coin.firo || coin == Coin.firoTestNet;

    final balance = ref.watch(pWalletBalance(walletId));

    _BalanceType _bal =
        ref.watch(walletBalanceToggleStateProvider.state).state ==
                WalletBalanceToggleState.available
            ? _BalanceType.available
            : _BalanceType.full;

    Balance? balanceSecondary;
    Balance? balanceTertiary;
    if (isFiro) {
      balanceSecondary = ref.watch(pWalletBalanceSecondary(walletId));
      balanceTertiary = ref.watch(pWalletBalanceTertiary(walletId));

      switch (ref.watch(publicPrivateBalanceStateProvider.state).state) {
        case FiroType.spark:
          _bal = _bal == _BalanceType.available
              ? _BalanceType.sparkAvailable
              : _BalanceType.sparkFull;
          break;

        case FiroType.lelantus:
          _bal = _bal == _BalanceType.available
              ? _BalanceType.lelantusAvailable
              : _BalanceType.lelantusFull;
          break;

        case FiroType.public:
          // already set above
          break;
      }

      // hack to not show lelantus balance in ui if zero
      if (balanceSecondary?.spendable.raw == BigInt.zero) {
        balanceSecondary = null;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<StackColors>()!.popupBG,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: LimitedBox(
        maxHeight: maxHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textFieldDefaultBG,
                    borderRadius: BorderRadius.circular(
                      Constants.size.circularBorderRadius,
                    ),
                  ),
                  width: 60,
                  height: 4,
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Wallet balance",
                  style: STextStyles.pageTitleH2(context),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              BalanceSelector(
                title: "Available${isFiro ? " public" : ""} balance",
                coin: coin,
                balance: balance.spendable,
                onPressed: () {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.available;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      FiroType.public;
                  Navigator.of(context).pop();
                },
                onChanged: (_) {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.available;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      FiroType.public;
                  Navigator.of(context).pop();
                },
                value: _BalanceType.available,
                groupValue: _bal,
              ),
              const SizedBox(
                height: 12,
              ),
              BalanceSelector(
                title: "Full${isFiro ? " public" : ""} balance",
                coin: coin,
                balance: balance.total,
                onPressed: () {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.full;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      FiroType.public;
                  Navigator.of(context).pop();
                },
                onChanged: (_) {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.full;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      FiroType.public;
                  Navigator.of(context).pop();
                },
                value: _BalanceType.full,
                groupValue: _bal,
              ),
              if (balanceSecondary != null)
                const SizedBox(
                  height: 12,
                ),
              if (balanceSecondary != null)
                BalanceSelector(
                  title: "Available Lelantus balance",
                  coin: coin,
                  balance: balanceSecondary.spendable,
                  onPressed: () {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.available;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.lelantus;
                    Navigator.of(context).pop();
                  },
                  onChanged: (_) {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.available;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.lelantus;
                    Navigator.of(context).pop();
                  },
                  value: _BalanceType.lelantusAvailable,
                  groupValue: _bal,
                ),
              if (balanceSecondary != null)
                const SizedBox(
                  height: 12,
                ),
              if (balanceSecondary != null)
                BalanceSelector(
                  title: "Full Lelantus balance",
                  coin: coin,
                  balance: balanceSecondary.total,
                  onPressed: () {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.full;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.lelantus;
                    Navigator.of(context).pop();
                  },
                  onChanged: (_) {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.full;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.lelantus;
                    Navigator.of(context).pop();
                  },
                  value: _BalanceType.lelantusFull,
                  groupValue: _bal,
                ),
              if (balanceTertiary != null)
                const SizedBox(
                  height: 12,
                ),
              if (balanceTertiary != null)
                BalanceSelector(
                  title: "Available Spark balance",
                  coin: coin,
                  balance: balanceTertiary.spendable,
                  onPressed: () {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.available;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.spark;
                    Navigator.of(context).pop();
                  },
                  onChanged: (_) {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.available;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.spark;
                    Navigator.of(context).pop();
                  },
                  value: _BalanceType.sparkAvailable,
                  groupValue: _bal,
                ),
              if (balanceTertiary != null)
                const SizedBox(
                  height: 12,
                ),
              if (balanceTertiary != null)
                BalanceSelector(
                  title: "Full Spark balance",
                  coin: coin,
                  balance: balanceTertiary.total,
                  onPressed: () {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.full;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.spark;
                    Navigator.of(context).pop();
                  },
                  onChanged: (_) {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.full;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        FiroType.spark;
                    Navigator.of(context).pop();
                  },
                  value: _BalanceType.sparkFull,
                  groupValue: _bal,
                ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceSelector<T> extends ConsumerWidget {
  const BalanceSelector({
    super.key,
    required this.title,
    required this.coin,
    required this.balance,
    required this.onPressed,
    required this.onChanged,
    required this.value,
    required this.groupValue,
  });

  final String title;
  final Coin coin;
  final Amount balance;
  final VoidCallback onPressed;
  final void Function(T?) onChanged;
  final T value;
  final T? groupValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Constants.size.circularBorderRadius,
        ),
      ),
      onPressed: onPressed,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Radio(
                activeColor: Theme.of(context)
                    .extension<StackColors>()!
                    .radioButtonIconEnabled,
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: STextStyles.titleBold12(context),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  ref.watch(pAmountFormatter(coin)).format(balance),
                  style: STextStyles.itemSubtitle12(context).copyWith(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textSubtitle1,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
