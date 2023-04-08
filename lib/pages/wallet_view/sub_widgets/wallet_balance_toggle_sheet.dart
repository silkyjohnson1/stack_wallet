import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/balance.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/providers/wallet/public_private_balance_state_provider.dart';
import 'package:stackwallet/providers/wallet/wallet_balance_toggle_state_provider.dart';
import 'package:stackwallet/services/coins/firo/firo_wallet.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/enums/wallet_balance_toggle_state.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';

enum _BalanceType {
  available,
  full,
  privateAvailable,
  privateFull;
}

class WalletBalanceToggleSheet extends ConsumerWidget {
  const WalletBalanceToggleSheet({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxHeight = MediaQuery.of(context).size.height * 0.60;

    final coin = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(walletId).coin));

    final balance = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(walletId).balance));

    _BalanceType _bal =
        ref.watch(walletBalanceToggleStateProvider.state).state ==
                WalletBalanceToggleState.available
            ? _BalanceType.available
            : _BalanceType.full;

    Balance? balanceSecondary;
    if (coin == Coin.firo || coin == Coin.firoTestNet) {
      balanceSecondary = ref
          .watch(
            walletsChangeNotifierProvider.select(
              (value) => value.getManager(walletId).wallet as FiroWallet?,
            ),
          )
          ?.balancePrivate;

      if (ref.watch(publicPrivateBalanceStateProvider.state).state ==
          "Private") {
        _bal = _bal == _BalanceType.available
            ? _BalanceType.privateAvailable
            : _BalanceType.privateFull;
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
                title: "Available balance",
                coin: coin,
                balance: balance.spendable,
                onPressed: () {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.available;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      "Public";
                  Navigator.of(context).pop();
                },
                onChanged: (_) {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.available;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      "Public";
                  Navigator.of(context).pop();
                },
                value: _BalanceType.available,
                groupValue: _bal,
              ),
              if (balanceSecondary != null)
                const SizedBox(
                  height: 12,
                ),
              if (balanceSecondary != null)
                BalanceSelector(
                  title: "Available private balance",
                  coin: coin,
                  balance: balanceSecondary.spendable,
                  onPressed: () {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.available;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        "Private";
                    Navigator.of(context).pop();
                  },
                  onChanged: (_) {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.available;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        "Private";
                    Navigator.of(context).pop();
                  },
                  value: _BalanceType.privateAvailable,
                  groupValue: _bal,
                ),
              const SizedBox(
                height: 12,
              ),
              BalanceSelector(
                title: "Full balance",
                coin: coin,
                balance: balance.total,
                onPressed: () {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.full;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      "Public";
                  Navigator.of(context).pop();
                },
                onChanged: (_) {
                  ref.read(walletBalanceToggleStateProvider.state).state =
                      WalletBalanceToggleState.full;
                  ref.read(publicPrivateBalanceStateProvider.state).state =
                      "Public";
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
                  title: "Full private balance",
                  coin: coin,
                  balance: balanceSecondary.total,
                  onPressed: () {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.full;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        "Private";
                    Navigator.of(context).pop();
                  },
                  onChanged: (_) {
                    ref.read(walletBalanceToggleStateProvider.state).state =
                        WalletBalanceToggleState.full;
                    ref.read(publicPrivateBalanceStateProvider.state).state =
                        "Private";
                    Navigator.of(context).pop();
                  },
                  value: _BalanceType.privateFull,
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
    Key? key,
    required this.title,
    required this.coin,
    required this.balance,
    required this.onPressed,
    required this.onChanged,
    required this.value,
    required this.groupValue,
  }) : super(key: key);

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
                  "${balance.localizedStringAsFixed(
                    locale: ref.watch(
                      localeServiceChangeNotifierProvider.select(
                        (value) => value.locale,
                      ),
                    ),
                  )} ${coin.ticker}",
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
