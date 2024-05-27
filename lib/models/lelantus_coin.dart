/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:hive/hive.dart';

part 'type_adaptors/lelantus_coin.g.dart';

@Deprecated("Use Isar object instead")
// @HiveType(typeId: 9)
class LelantusCoin {
  // @HiveField(0)
  int index;
  // @HiveField(1)
  int value;
  // @HiveField(2)
  String publicCoin;
  // @HiveField(3)
  String txId;
  // @HiveField(4)
  int anonymitySetId;
  // @HiveField(5)
  bool isUsed;

  @Deprecated("Use Isar object instead")
  LelantusCoin(
    this.index,
    this.value,
    this.publicCoin,
    this.txId,
    this.anonymitySetId,
    this.isUsed,
  );

  @override
  String toString() {
    final String coin =
        "{index: $index, value: $value, publicCoin: $publicCoin, txId: $txId, anonymitySetId: $anonymitySetId, isUsed: $isUsed}";
    return coin;
  }
}
