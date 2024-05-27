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
import '../../../../frost_route_generator.dart';
import '../../../../pages/send_view/frost_ms/frost_send_view.dart';
import '../../../../pages/wallet_view/transaction_views/tx_v2/transaction_v2_list.dart';
import '../../my_stack_view.dart';
import 'desktop_receive.dart';
import 'desktop_send.dart';
import 'desktop_token_send.dart';
import '../../../../providers/global/wallets_provider.dart';
import '../../../../wallets/crypto_currency/crypto_currency.dart';
import '../../../../wallets/wallet/impl/bitcoin_frost_wallet.dart';
import '../../../../widgets/custom_tab_view.dart';
import '../../../../widgets/desktop/secondary_button.dart';
import '../../../../widgets/frost_scaffold.dart';
import '../../../../widgets/rounded_white_container.dart';

class MyWallet extends ConsumerStatefulWidget {
  const MyWallet({
    super.key,
    required this.walletId,
    this.contractAddress,
  });

  final String walletId;
  final String? contractAddress;

  @override
  ConsumerState<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends ConsumerState<MyWallet> {
  final titles = [
    "Send",
    "Receive",
  ];

  late final bool isEth;
  late final CryptoCurrency coin;
  late final bool isFrost;

  @override
  void initState() {
    final wallet = ref.read(pWallets).getWallet(widget.walletId);
    coin = wallet.info.coin;
    isFrost = wallet is BitcoinFrostWallet;
    isEth = coin is Ethereum;

    if (isEth && widget.contractAddress == null) {
      titles.add("Transactions");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      children: [
        RoundedWhiteContainer(
          padding: EdgeInsets.zero,
          child: CustomTabView(
            titles: titles,
            children: [
              widget.contractAddress == null
                  ? isFrost
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: SecondaryButton(
                                    width: 200,
                                    buttonHeight: ButtonHeight.l,
                                    label: "Import sign config",
                                    onPressed: () async {
                                      final wallet = ref
                                              .read(pWallets)
                                              .getWallet(widget.walletId)
                                          as BitcoinFrostWallet;
                                      ref.read(pFrostScaffoldArgs.state).state =
                                          (
                                        info: (
                                          walletName: wallet.info.name,
                                          frostCurrency: wallet.cryptoCurrency,
                                        ),
                                        walletId: widget.walletId,
                                        stepRoutes: FrostRouteGenerator
                                            .signFrostTxStepRoutes,
                                        parentNav: Navigator.of(context),
                                        frostInterruptionDialogType:
                                            FrostInterruptionDialogType
                                                .transactionCreation,
                                        callerRouteName: MyStackView.routeName,
                                      );

                                      await Navigator.of(context).pushNamed(
                                        FrostStepScaffold.routeName,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            FrostSendView(
                              walletId: widget.walletId,
                              coin: coin,
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20),
                          child: DesktopSend(
                            walletId: widget.walletId,
                          ),
                        )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: DesktopTokenSend(
                        walletId: widget.walletId,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: DesktopReceive(
                  walletId: widget.walletId,
                  contractAddress: widget.contractAddress,
                ),
              ),
              if (isEth && widget.contractAddress == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 362,
                    ),
                    child: TransactionsV2List(
                      walletId: widget.walletId,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
