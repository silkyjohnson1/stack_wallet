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
import 'package:flutter_svg/svg.dart';
import '../../../providers/providers.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/amount/amount.dart';
import '../../../utilities/amount/amount_formatter.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/text_styles.dart';
import '../../../wallets/crypto_currency/coins/firo.dart';
import '../../../wallets/crypto_currency/crypto_currency.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../widgets/custom_buttons/blue_text_button.dart';
import '../../../widgets/desktop/secondary_button.dart';
import '../../../widgets/icon_widgets/x_icon.dart';
import '../../../widgets/rounded_white_container.dart';
import '../../../widgets/stack_text_field.dart';
import '../../../widgets/textfield_icon_button.dart';
import '../../../widgets/wallet_info_row/sub_widgets/wallet_info_row_coin_icon.dart';
import 'package:tuple/tuple.dart';

class DesktopChooseFromStack extends ConsumerStatefulWidget {
  const DesktopChooseFromStack({
    super.key,
    required this.coin,
  });

  final CryptoCurrency coin;

  @override
  ConsumerState<DesktopChooseFromStack> createState() =>
      _DesktopChooseFromStackState();
}

class _DesktopChooseFromStackState
    extends ConsumerState<DesktopChooseFromStack> {
  late final TextEditingController _searchController;
  late final FocusNode searchFieldFocusNode;

  String _searchTerm = "";

  List<String> filter(List<String> walletIds, String searchTerm) {
    if (searchTerm.isEmpty) {
      return walletIds;
    }

    final List<String> result = [];
    for (final walletId in walletIds) {
      final name = ref.read(pWalletName(walletId));

      if (name.toLowerCase().contains(searchTerm.toLowerCase())) {
        result.add(walletId);
      }
    }

    return result;
  }

  @override
  void initState() {
    searchFieldFocusNode = FocusNode();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose from Stack",
          style: STextStyles.desktopH3(context),
        ),
        const SizedBox(
          height: 28,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
          child: TextField(
            autocorrect: false,
            enableSuggestions: false,
            controller: _searchController,
            focusNode: searchFieldFocusNode,
            onChanged: (value) {
              setState(() {
                _searchTerm = value;
              });
            },
            style: STextStyles.desktopTextExtraSmall(context).copyWith(
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .textFieldActiveText,
              height: 1.8,
            ),
            decoration: standardInputDecoration(
              "Search",
              searchFieldFocusNode,
              context,
              desktopMed: true,
            ).copyWith(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
                child: SvgPicture.asset(
                  Assets.svg.search,
                  width: 20,
                  height: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: UnconstrainedBox(
                        child: Row(
                          children: [
                            TextFieldIconButton(
                              child: const XIcon(),
                              onTap: () async {
                                setState(() {
                                  _searchController.text = "";
                                  _searchTerm = "";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Flexible(
          child: Builder(
            builder: (context) {
              final wallets = ref
                  .watch(pWallets)
                  .wallets
                  .where((e) => e.info.coin == widget.coin);

              if (wallets.isEmpty) {
                return Column(
                  children: [
                    RoundedWhiteContainer(
                      borderColor: Theme.of(context)
                          .extension<StackColors>()!
                          .background,
                      child: Center(
                        child: Text(
                          "No ${widget.coin.ticker.toUpperCase()} wallets",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                        ),
                      ),
                    ),
                  ],
                );
              }

              List<String> walletIds = wallets.map((e) => e.walletId).toList();

              walletIds = filter(walletIds, _searchTerm);

              return ListView.separated(
                primary: false,
                itemCount: walletIds.length,
                separatorBuilder: (_, __) => const SizedBox(
                  height: 5,
                ),
                itemBuilder: (context, index) {
                  final wallet = ref.watch(pWallets
                      .select((value) => value.getWallet(walletIds[index])));

                  return RoundedWhiteContainer(
                    borderColor:
                        Theme.of(context).extension<StackColors>()!.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            WalletInfoCoinIcon(coin: widget.coin),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              wallet.info.name,
                              style: STextStyles.desktopTextExtraExtraSmall(
                                      context)
                                  .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        _BalanceDisplay(
                          walletId: walletIds[index],
                        ),
                        const SizedBox(
                          width: 80,
                        ),
                        CustomTextButton(
                          text: "Select wallet",
                          onTap: () async {
                            final address =
                                (await wallet.getCurrentReceivingAddress())
                                        ?.value ??
                                    wallet.info.cachedReceivingAddress;

                            if (mounted) {
                              Navigator.of(context).pop(
                                Tuple2(
                                  wallet.info.name,
                                  address,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Spacer(),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: SecondaryButton(
                label: "Cancel",
                buttonHeight: ButtonHeight.l,
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _BalanceDisplay extends ConsumerWidget {
  const _BalanceDisplay({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coin = ref.watch(pWalletCoin(walletId));
    Amount total = ref.watch(pWalletBalance(walletId)).total;
    if (coin is Firo) {
      total += ref.watch(pWalletBalanceSecondary(walletId)).total;
      total += ref.watch(pWalletBalanceTertiary(walletId)).total;
    }

    return Text(
      ref.watch(pAmountFormatter(coin)).format(total),
      style: STextStyles.desktopTextExtraSmall(context).copyWith(
        color: Theme.of(context).extension<StackColors>()!.textSubtitle1,
      ),
      textAlign: TextAlign.right,
    );
  }
}
