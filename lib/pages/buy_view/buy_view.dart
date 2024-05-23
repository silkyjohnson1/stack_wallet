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
import '../../models/isar/models/ethereum/eth_contract.dart';
import 'buy_form.dart';
import '../../services/event_bus/events/global/tor_connection_status_changed_event.dart';
import '../../services/tor_service.dart';
import '../../themes/stack_colors.dart';
import '../../wallets/crypto_currency/crypto_currency.dart';
import '../../widgets/stack_dialog.dart';
import '../../widgets/tor_subscription.dart';

class BuyView extends ConsumerStatefulWidget {
  const BuyView({
    super.key,
    this.coin,
    this.tokenContract,
  });

  final CryptoCurrency? coin;
  final EthContract? tokenContract;

  static const String routeName = "/stackBuyView";

  @override
  ConsumerState<BuyView> createState() => _BuyViewState();
}

class _BuyViewState extends ConsumerState<BuyView> {
  CryptoCurrency? coin;
  EthContract? tokenContract;

  late bool torEnabled;

  @override
  void initState() {
    coin = widget.coin;
    tokenContract = widget.tokenContract;

    torEnabled =
        ref.read(pTorService).status != TorConnectionStatus.disconnected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    return TorSubscription(
      onTorStatusChanged: (status) {
        setState(() {
          torEnabled = status != TorConnectionStatus.disconnected;
        });
      },
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: BuyForm(
                coin: coin,
                tokenContract: tokenContract,
              ),
            ),
          ),
          if (torEnabled)
            Container(
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .overlay
                  .withOpacity(0.7),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const StackDialog(
                title: "Tor is enabled",
                message: "Purchasing not available while Tor is enabled",
              ),
            ),
        ],
      ),
    );
  }
}
