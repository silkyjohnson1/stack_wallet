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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/isar/models/ethereum/eth_contract.dart';
import 'package:stackwallet/pages/token_view/token_view.dart';
import 'package:stackwallet/pages/wallet_view/wallet_view.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/desktop_token_view.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/desktop_wallet_view.dart';
import 'package:stackwallet/providers/db/main_db_provider.dart';
import 'package:stackwallet/providers/global/secure_store_provider.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/services/coins/ethereum/ethereum_wallet.dart';
import 'package:stackwallet/services/ethereum/ethereum_token_service.dart';
import 'package:stackwallet/services/transaction_notification_tracker.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/show_loading.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/wallets/wallet/wallet.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/dialogs/basic_dialog.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/wallet_info_row/wallet_info_row.dart';

class SimpleWalletCard extends ConsumerWidget {
  const SimpleWalletCard({
    Key? key,
    required this.walletId,
    this.contractAddress,
    this.popPrevious = false,
    this.desktopNavigatorState,
  }) : super(key: key);

  final String walletId;
  final String? contractAddress;
  final bool popPrevious;
  final NavigatorState? desktopNavigatorState;

  Future<bool> _loadTokenWallet(
    BuildContext context,
    WidgetRef ref,
    Wallet wallet,
    EthContract contract,
  ) async {
    ref.read(tokenServiceStateProvider.state).state = EthTokenWallet(
      token: contract,
      secureStore: ref.read(secureStoreProvider),
      // TODO: [prio=high] FIX THIS BAD as CAST
      ethWallet: wallet as EthereumWallet,
      tracker: TransactionNotificationTracker(
        walletId: walletId,
      ),
    );

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
              Navigator.of(context).pop();
              if (desktopNavigatorState == null) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      );
      return false;
    }
  }

  void _openWallet(BuildContext context, WidgetRef ref) async {
    final nav = Navigator.of(context);

    final wallet = ref.read(pWallets).getWallet(walletId);
    if (wallet.info.coin == Coin.monero || wallet.info.coin == Coin.wownero) {
      await wallet.init();
    }
    if (context.mounted) {
      if (popPrevious) nav.pop();

      if (desktopNavigatorState != null) {
        unawaited(
          desktopNavigatorState!.pushNamed(
            DesktopWalletView.routeName,
            arguments: walletId,
          ),
        );
      } else {
        unawaited(
          nav.pushNamed(
            WalletView.routeName,
            arguments: walletId,
          ),
        );
      }

      if (contractAddress != null) {
        final contract =
            ref.read(mainDBProvider).getEthContractSync(contractAddress!)!;

        final success = await showLoading<bool>(
          whileFuture: _loadTokenWallet(
              desktopNavigatorState?.context ?? context, ref, wallet, contract),
          context: desktopNavigatorState?.context ?? context,
          opaqueBG: true,
          message: "Loading ${contract.name}",
          isDesktop: Util.isDesktop,
        );

        if (!success!) {
          // TODO: show error dialog here?
          Logging.instance.log(
            "Failed to load token wallet for $contract",
            level: LogLevel.Error,
          );
          return;
        }

        if (desktopNavigatorState != null) {
          await desktopNavigatorState!.pushNamed(
            DesktopTokenView.routeName,
            arguments: walletId,
          );
        } else {
          await nav.pushNamed(
            TokenView.routeName,
            arguments: (walletId: walletId, popPrevious: !Util.isDesktop),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConditionalParent(
      condition: !Util.isDesktop,
      builder: (child) => RoundedWhiteContainer(
        padding: const EdgeInsets.all(0),
        child: MaterialButton(
          // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
          key: Key("walletsSheetItemButtonKey_$walletId"),
          padding: const EdgeInsets.all(10),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
          ),
          onPressed: () => _openWallet(context, ref),
          child: child,
        ),
      ),
      child: WalletInfoRow(
        walletId: walletId,
        contractAddress: contractAddress,
        onPressedDesktop:
            Util.isDesktop ? () => _openWallet(context, ref) : null,
      ),
    );
  }
}
