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
import 'package:isar/isar.dart';
import '../../models/isar/exchange_cache/currency.dart';
import '../../services/exchange/exchange_data_loading_service.dart';
import '../../themes/coin_icon_provider.dart';
import '../../wallets/crypto_currency/coins/ethereum.dart';
import '../../wallets/crypto_currency/crypto_currency.dart';

class EthTokenIcon extends ConsumerStatefulWidget {
  const EthTokenIcon({
    super.key,
    required this.contractAddress,
    this.size = 22,
  });

  final String contractAddress;
  final double size;

  @override
  ConsumerState<EthTokenIcon> createState() => _EthTokenIconState();
}

class _EthTokenIconState extends ConsumerState<EthTokenIcon> {
  late final String? imageUrl;

  @override
  void initState() {
    imageUrl = ExchangeDataLoadingService.instance.isar.currencies
        .where()
        .filter()
        .tokenContractEqualTo(widget.contractAddress, caseSensitive: false)
        .findFirstSync()
        ?.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return SvgPicture.asset(
        ref.watch(coinIconProvider(Ethereum(CryptoCurrencyNetwork.main))),
        width: widget.size,
        height: widget.size,
      );
    } else {
      return SvgPicture.network(
        imageUrl!,
        width: widget.size,
        height: widget.size,
      );
    }
  }
}
