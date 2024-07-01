/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/amount/amount.dart';
import '../../wallets/crypto_currency/crypto_currency.dart';
import '../wallet/public_private_balance_state_provider.dart';

final pSendAmount = StateProvider.autoDispose<Amount?>((_) => null);
final pValidSendToAddress = StateProvider.autoDispose<bool>((_) => false);
final pValidSparkSendToAddress = StateProvider.autoDispose<bool>((_) => false);

final pIsExchangeAddress = StateProvider<bool>((_) => false);

final pPreviewTxButtonEnabled =
    Provider.autoDispose.family<bool, CryptoCurrency>((ref, coin) {
  final amount = ref.watch(pSendAmount) ?? Amount.zero;

  if (coin is Firo) {
    final firoType = ref.watch(publicPrivateBalanceStateProvider);
    switch (firoType) {
      case FiroType.lelantus:
        return ref.watch(pValidSendToAddress) &&
            !ref.watch(pValidSparkSendToAddress) &&
            amount > Amount.zero;

      case FiroType.spark:
        return (ref.watch(pValidSendToAddress) ||
                ref.watch(pValidSparkSendToAddress)) &&
            !ref.watch(pIsExchangeAddress) &&
            amount > Amount.zero;

      case FiroType.public:
        return ref.watch(pValidSendToAddress) && amount > Amount.zero;
    }
  } else {
    return ref.watch(pValidSendToAddress) && amount > Amount.zero;
  }
});

final previewTokenTxButtonStateProvider = StateProvider.autoDispose<bool>((_) {
  return false;
});
