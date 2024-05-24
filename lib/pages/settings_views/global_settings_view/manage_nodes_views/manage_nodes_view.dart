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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'coin_nodes_view.dart';
import '../../../../providers/providers.dart';
import '../../../../app_config.dart';
import '../../../../themes/coin_icon_provider.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../wallets/crypto_currency/crypto_currency.dart';
import '../../../../widgets/background.dart';
import '../../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../../widgets/rounded_white_container.dart';

class ManageNodesView extends ConsumerStatefulWidget {
  const ManageNodesView({
    super.key,
  });

  static const String routeName = "/manageNodes";

  @override
  ConsumerState<ManageNodesView> createState() => _ManageNodesViewState();
}

class _ManageNodesViewState extends ConsumerState<ManageNodesView> {
  List<CryptoCurrency> _coins = [...AppConfig.coins];

  @override
  void initState() {
    _coins = _coins.toList();
    _coins.removeWhere(
      (e) => e is Firo && e.network == CryptoCurrencyNetwork.test,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showTestNet = ref.watch(
      prefsChangeNotifierProvider.select((value) => value.showTestNetCoins),
    );

    final coins = showTestNet
        ? _coins
        : _coins.where((e) => e.network != CryptoCurrencyNetwork.test).toList();

    return Background(
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<StackColors>()!.background,
        appBar: AppBar(
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Manage nodes",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...coins.map(
                  (coin) {
                    final count = ref
                        .watch(nodeServiceChangeNotifierProvider
                            .select((value) => value.getNodesFor(coin)))
                        .length;

                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: RoundedWhiteContainer(
                        padding: const EdgeInsets.all(0),
                        child: RawMaterialButton(
                          // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Constants.size.circularBorderRadius,
                            ),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              CoinNodesView.routeName,
                              arguments: coin,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                SvgPicture.file(
                                  File(
                                    ref.watch(
                                      coinIconProvider(coin),
                                    ),
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${coin.prettyName} nodes",
                                      style: STextStyles.titleBold12(context),
                                    ),
                                    Text(
                                      count > 1 ? "$count nodes" : "Default",
                                      style: STextStyles.label(context),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
