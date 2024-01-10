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
import 'package:stackwallet/models/isar/models/ethereum/eth_contract.dart';
import 'package:stackwallet/pages/token_view/token_view.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/desktop_token_view.dart';
import 'package:stackwallet/providers/db/main_db_provider.dart';
import 'package:stackwallet/providers/global/secure_store_provider.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/services/ethereum/cached_eth_token_balance.dart';
import 'package:stackwallet/services/ethereum/ethereum_token_service.dart';
import 'package:stackwallet/services/transaction_notification_tracker.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/amount/amount_formatter.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/show_loading.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/wallets/isar/providers/eth/token_balance_provider.dart';
import 'package:stackwallet/wallets/isar/providers/wallet_info_provider.dart';
import 'package:stackwallet/wallets/wallet/impl/ethereum_wallet.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/dialogs/basic_dialog.dart';
import 'package:stackwallet/widgets/icon_widgets/eth_token_icon.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class MyTokenSelectItem extends ConsumerStatefulWidget {
  const MyTokenSelectItem({
    Key? key,
    required this.walletId,
    required this.token,
  }) : super(key: key);

  final String walletId;
  final EthContract token;

  @override
  ConsumerState<MyTokenSelectItem> createState() => _MyTokenSelectItemState();
}

class _MyTokenSelectItemState extends ConsumerState<MyTokenSelectItem> {
  final bool isDesktop = Util.isDesktop;

  late final CachedEthTokenBalance cachedBalance;

  Future<bool> _loadTokenWallet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ref.read(tokenServiceProvider)!.initialize();
      return true;
    } catch (_) {
      await showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => BasicDialog(
          title: "Failed to load token data",
          desktopHeight: double.infinity,
          desktopWidth: 450,
          rightButton: PrimaryButton(
            label: "OK",
            onPressed: () {
              Navigator.of(context).pop();
              if (!isDesktop) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      );
      return false;
    }
  }

  void _onPressed() async {
    ref.read(tokenServiceStateProvider.state).state = EthTokenWallet(
      token: widget.token,
      secureStore: ref.read(secureStoreProvider),
      ethWallet:
          ref.read(pWallets).getWallet(widget.walletId) as EthereumWallet,
      tracker: TransactionNotificationTracker(
        walletId: widget.walletId,
      ),
    );

    final success = await showLoading<bool>(
      whileFuture: _loadTokenWallet(context, ref),
      context: context,
      isDesktop: isDesktop,
      message: "Loading ${widget.token.name}",
    );

    if (!success!) {
      return;
    }

    if (mounted) {
      await Navigator.of(context).pushNamed(
        isDesktop ? DesktopTokenView.routeName : TokenView.routeName,
        arguments: widget.walletId,
      );
    }
  }

  @override
  void initState() {
    cachedBalance = CachedEthTokenBalance(widget.walletId, widget.token);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final address = ref.read(pWalletReceivingAddress(widget.walletId));
        await cachedBalance.fetchAndUpdateCachedBalance(
            address, ref.read(mainDBProvider));
        if (mounted) {
          setState(() {});
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteContainer(
      padding: const EdgeInsets.all(0),
      child: MaterialButton(
        key: Key("walletListItemButtonKey_${widget.token.symbol}"),
        padding: isDesktop
            ? const EdgeInsets.symmetric(horizontal: 28, vertical: 24)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(Constants.size.circularBorderRadius),
        ),
        onPressed: _onPressed,
        child: Row(
          children: [
            EthTokenIcon(
              contractAddress: widget.token.address,
              size: isDesktop ? 32 : 28,
            ),
            SizedBox(
              width: isDesktop ? 12 : 10,
            ),
            Expanded(
              child: Consumer(
                builder: (_, ref, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.token.name,
                            style: isDesktop
                                ? STextStyles.desktopTextExtraSmall(context)
                                    .copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textDark,
                                  )
                                : STextStyles.titleBold12(context),
                          ),
                          const Spacer(),
                          Text(
                            ref.watch(pAmountFormatter(Coin.ethereum)).format(
                                  ref
                                      .watch(pTokenBalance(
                                        (
                                          walletId: widget.walletId,
                                          contractAddress: widget.token.address
                                        ),
                                      ))
                                      .total,
                                  ethContract: widget.token,
                                ),
                            style: isDesktop
                                ? STextStyles.desktopTextExtraSmall(context)
                                    .copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textDark,
                                  )
                                : STextStyles.itemSubtitle(context),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.token.symbol,
                            style: isDesktop
                                ? STextStyles.desktopTextExtraExtraSmall(
                                    context)
                                : STextStyles.itemSubtitle(context),
                          ),
                          const Spacer(),
                          Text(
                            "${ref.watch(
                              priceAnd24hChangeNotifierProvider.select(
                                (value) => value
                                    .getTokenPrice(widget.token.address)
                                    .item1
                                    .toStringAsFixed(2),
                              ),
                            )} "
                            "${ref.watch(
                              prefsChangeNotifierProvider.select(
                                (value) => value.currency,
                              ),
                            )}",
                            style: isDesktop
                                ? STextStyles.desktopTextExtraExtraSmall(
                                    context)
                                : STextStyles.itemSubtitle(context),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
