/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackwallet/db/hive/db.dart';

mixin FiroHive {
  late final String _walletId;

  void initFiroHive(String walletId) {
    _walletId = walletId;
  }

  // jindex
  List? firoGetJIndex() {
    return DB.instance.get<dynamic>(boxName: _walletId, key: "jindex") as List?;
  }

  Future<void> firoUpdateJIndex(List jIndex) async {
    await DB.instance.put<dynamic>(
      boxName: _walletId,
      key: "jindex",
      value: jIndex,
    );
  }

  // // _lelantus_coins
  // List? firoGetLelantusCoins() {
  //   return DB.instance.get<dynamic>(boxName: _walletId, key: "_lelantus_coins")
  //       as List?;
  // }
  //
  // Future<void> firoUpdateLelantusCoins(List lelantusCoins) async {
  //   await DB.instance.put<dynamic>(
  //     boxName: _walletId,
  //     key: "_lelantus_coins",
  //     value: lelantusCoins,
  //   );
  // }

  // mintIndex
  int firoGetMintIndex() {
    return DB.instance.get<dynamic>(boxName: _walletId, key: "mintIndex")
            as int? ??
        0;
  }

  Future<void> firoUpdateMintIndex(int mintIndex) async {
    await DB.instance.put<dynamic>(
      boxName: _walletId,
      key: "mintIndex",
      value: mintIndex,
    );
  }
}
