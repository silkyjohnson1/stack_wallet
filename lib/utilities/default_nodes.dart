/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackwallet/models/node_model.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

abstract class DefaultNodes {
  static const String defaultNodeIdPrefix = "default_";
  static String buildId(Coin coin) => "$defaultNodeIdPrefix${coin.name}";
  static const String defaultName = "Stack Default";

  @Deprecated("old and decrepit")
  static List<NodeModel> get all => Coin.values
      .map((e) => DefaultNodes.getNodeFor(e))
      .toList(growable: false);

  static NodeModel get bitcoin => NodeModel(
        host: "bitcoin.stackwallet.com",
        port: 50002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.bitcoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get litecoin => NodeModel(
        host: "litecoin.stackwallet.com",
        port: 20063,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.litecoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.litecoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get litecoinTestNet => NodeModel(
        host: "litecoin.stackwallet.com",
        port: 51002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.litecoinTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.litecoinTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get bitcoincash => NodeModel(
        host: "bitcoincash.stackwallet.com",
        port: 50002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.bitcoincash),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoincash.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get dogecoin => NodeModel(
        host: "dogecoin.stackwallet.com",
        port: 50022,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.dogecoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.dogecoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get firo => NodeModel(
        host: "firo.stackwallet.com",
        port: 50002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.firo),
        useSSL: true,
        enabled: true,
        coinName: Coin.firo.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get monero => NodeModel(
        host: "https://monero.stackwallet.com",
        port: 18081,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.monero),
        useSSL: true,
        enabled: true,
        coinName: Coin.monero.name,
        isFailover: true,
        isDown: false,
        trusted: true,
      );

  static NodeModel get wownero => NodeModel(
        host: "https://wownero.stackwallet.com",
        port: 34568,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.wownero),
        useSSL: true,
        enabled: true,
        coinName: Coin.wownero.name,
        isFailover: true,
        isDown: false,
        trusted: true,
      );

  static NodeModel get epicCash => NodeModel(
        host: "http://epiccash.stackwallet.com",
        port: 3413,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.epicCash),
        useSSL: false,
        enabled: true,
        coinName: Coin.epicCash.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get ethereum => NodeModel(
        host: "https://eth.stackwallet.com",
        port: 443,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.ethereum),
        useSSL: true,
        enabled: true,
        coinName: Coin.ethereum.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get namecoin => NodeModel(
        host: "namecoin.stackwallet.com",
        port: 57002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.namecoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.namecoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get particl => NodeModel(
        host: "particl.stackwallet.com",
        port: 58002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.particl),
        useSSL: true,
        enabled: true,
        coinName: Coin.particl.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get peercoin => NodeModel(
        host: "electrum.peercoinexplorer.net",
        port: 50002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.peercoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.peercoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get solana => NodeModel(
        host:
            "https://api.mainnet-beta.solana.com", // TODO: Change this to stack wallet one
        port: 443,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.solana),
        useSSL: true,
        enabled: true,
        coinName: Coin.solana.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get stellar => NodeModel(
        host: "https://horizon.stellar.org",
        port: 443,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.stellar),
        useSSL: false,
        enabled: true,
        coinName: Coin.stellar.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get tezos => NodeModel(
        // TODO: Change this to stack wallet one
        host: "https://mainnet.api.tez.ie",
        port: 443,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.tezos),
        useSSL: true,
        enabled: true,
        coinName: Coin.tezos.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get nano => NodeModel(
        host: "https://rainstorm.city/api",
        port: 443,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.nano),
        useSSL: true,
        enabled: true,
        coinName: Coin.nano.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get banano => NodeModel(
        host: "https://kaliumapi.appditto.com/api",
        port: 443,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.banano),
        useSSL: true,
        enabled: true,
        coinName: Coin.banano.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get bitcoinTestnet => NodeModel(
        host: "bitcoin-testnet.stackwallet.com",
        port: 51002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.bitcoinTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoinTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get firoTestnet => NodeModel(
        host: "firo-testnet.stackwallet.com",
        port: 50002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.firoTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.firoTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get dogecoinTestnet => NodeModel(
        host: "dogecoin-testnet.stackwallet.com",
        port: 50022,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.dogecoinTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.dogecoinTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get bitcoincashTestnet => NodeModel(
        host: "bitcoincash-testnet.stackwallet.com",
        port: 60002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.bitcoincashTestnet),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoincashTestnet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get eCash => NodeModel(
        host: "ecash.stackwallet.com",
        port: 59002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.eCash),
        useSSL: true,
        enabled: true,
        coinName: Coin.eCash.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get peercoinTestNet => NodeModel(
        host: "testnet-electrum.peercoinexplorer.net",
        port: 50002,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.peercoinTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.peercoinTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get stellarTestnet => NodeModel(
        host: "https://horizon-testnet.stellar.org/",
        port: 50022,
        name: DefaultNodes.defaultName,
        id: DefaultNodes.buildId(Coin.stellarTestnet),
        useSSL: true,
        enabled: true,
        coinName: Coin.stellarTestnet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel getNodeFor(Coin coin) {
    switch (coin) {
      case Coin.bitcoin:
      case Coin.bitcoinFrost:
        return bitcoin;

      case Coin.litecoin:
        return litecoin;

      case Coin.bitcoincash:
        return bitcoincash;

      case Coin.dogecoin:
        return dogecoin;

      case Coin.eCash:
        return eCash;

      case Coin.epicCash:
        return epicCash;

      case Coin.ethereum:
        return ethereum;

      case Coin.firo:
        return firo;

      case Coin.monero:
        return monero;

      case Coin.wownero:
        return wownero;

      case Coin.namecoin:
        return namecoin;

      case Coin.particl:
        return particl;

      case Coin.peercoin:
        return peercoin;

      case Coin.peercoinTestNet:
        return peercoinTestNet;

      case Coin.solana:
        return solana;

      case Coin.stellar:
        return stellar;

      case Coin.nano:
        return nano;

      case Coin.banano:
        return banano;

      case Coin.tezos:
        return tezos;

      case Coin.bitcoinTestNet:
      case Coin.bitcoinFrostTestNet:
        return bitcoinTestnet;

      case Coin.litecoinTestNet:
        return litecoinTestNet;

      case Coin.bitcoincashTestnet:
        return bitcoincashTestnet;

      case Coin.firoTestNet:
        return firoTestnet;

      case Coin.dogecoinTestNet:
        return dogecoinTestnet;

      case Coin.stellarTestnet:
        return stellarTestnet;
    }
  }
}
