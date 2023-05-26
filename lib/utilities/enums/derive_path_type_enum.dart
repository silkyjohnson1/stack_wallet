
/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackwallet/utilities/enums/coin_enum.dart';

enum DerivePathType {
  bip44,
  bch44,
  bip49,
  bip84,
  eth,
  eCash44,
}

extension DerivePathTypeExt on DerivePathType {
  static DerivePathType primaryFor(Coin coin) {
    switch (coin) {
      case Coin.bitcoincash:
      case Coin.bitcoincashTestnet:
      case Coin.dogecoin:
      case Coin.dogecoinTestNet:
      case Coin.firo:
      case Coin.firoTestNet:
        return DerivePathType.bip44;

      case Coin.bitcoin:
      case Coin.bitcoinTestNet:
      case Coin.litecoin:
      case Coin.litecoinTestNet:
      case Coin.namecoin:
      case Coin.particl:
        return DerivePathType.bip84;

      case Coin.eCash:
        return DerivePathType.eCash44;

      case Coin.ethereum: // TODO: do we need something here?
        return DerivePathType.eth;

      case Coin.epicCash:
      case Coin.monero:
      case Coin.wownero:
      case Coin.nano:
        throw UnsupportedError(
            "$coin does not use bitcoin style derivation paths");
    }
  }
}
