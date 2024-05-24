/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/isar/models/blockchain_data/v2/transaction_v2.dart';
import '../../../models/isar/models/isar_models.dart';
import '../../../models/isar/stack_theme.dart';
import '../../../providers/global/wallets_provider.dart';
import '../../../themes/theme_providers.dart';
import '../../../utilities/assets.dart';
import '../../../wallets/crypto_currency/crypto_currency.dart';

class TxIcon extends ConsumerWidget {
  const TxIcon({
    super.key,
    required this.transaction,
    required this.currentHeight,
    required this.coin,
  });

  final Object transaction;
  final int currentHeight;
  final CryptoCurrency coin;

  static const Size size = Size(32, 32);

  String _getAssetName(
    bool isCancelled,
    bool isReceived,
    bool isPending,
    TransactionSubType subType,
    TransactionType type,
    IThemeAssets assets,
  ) {
    if (subType == TransactionSubType.cashFusion) {
      return Assets.svg.txCashFusion;
    }

    if ((!isReceived && subType == TransactionSubType.mint) ||
        (subType == TransactionSubType.sparkMint &&
            type == TransactionType.sentToSelf)) {
      if (isCancelled) {
        return Assets.svg.anonymizeFailed;
      }
      if (isPending) {
        return Assets.svg.anonymizePending;
      }
      return Assets.svg.anonymize;
    }

    if (isReceived) {
      if (isCancelled) {
        return assets.receiveCancelled;
      }
      if (isPending) {
        return assets.receivePending;
      }
      return assets.receive;
    } else {
      if (isCancelled) {
        return assets.sendCancelled;
      }
      if (isPending) {
        return assets.sendPending;
      }
      return assets.send;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool txIsReceived;
    final String assetName;

    if (transaction is Transaction) {
      final tx = transaction as Transaction;
      txIsReceived = tx.type == TransactionType.incoming;
      assetName = _getAssetName(
        tx.isCancelled,
        txIsReceived,
        !tx.isConfirmed(
          currentHeight,
          ref.watch(pWallets).getWallet(tx.walletId).cryptoCurrency.minConfirms,
        ),
        tx.subType,
        tx.type,
        ref.watch(themeAssetsProvider),
      );
    } else if (transaction is TransactionV2) {
      final tx = transaction as TransactionV2;
      txIsReceived = tx.type == TransactionType.incoming;
      assetName = _getAssetName(
        false,
        txIsReceived,
        !tx.isConfirmed(
          currentHeight,
          ref.watch(pWallets).getWallet(tx.walletId).cryptoCurrency.minConfirms,
        ),
        tx.subType,
        tx.type,
        ref.watch(themeAssetsProvider),
      );
    } else {
      throw ArgumentError(
        "Unknown transaction type ${transaction.runtimeType}",
      );
    }

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Center(
        // if it starts with "assets" we assume its local
        // TODO: a more thorough check
        child: assetName.startsWith("assets")
            ? SvgPicture.asset(
                assetName,
                width: size.width,
                height: size.height,
              )
            : SvgPicture.file(
                File(
                  assetName,
                ),
                width: size.width,
                height: size.height,
              ),
      ),
    );
  }
}
