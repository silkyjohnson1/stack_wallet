/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

abstract class Bip32Utils {
  // =============================== get root ==================================
  static bip32.BIP32 getBip32RootSync(
    String mnemonic,
    String mnemonicPassphrase,
    bip32.NetworkType networkType,
  ) {
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: mnemonicPassphrase);
    final root = bip32.BIP32.fromSeed(seed, networkType);
    return root;
  }

  static Future<bip32.BIP32> getBip32Root(
    String mnemonic,
    String mnemonicPassphrase,
    bip32.NetworkType networkType,
  ) async {
    final root = await compute(
      _getBip32RootWrapper,
      Tuple3(
        mnemonic,
        mnemonicPassphrase,
        networkType,
      ),
    );
    return root;
  }

  /// wrapper for compute()
  static bip32.BIP32 _getBip32RootWrapper(
    Tuple3<String, String, bip32.NetworkType> args,
  ) {
    return getBip32RootSync(
      args.item1,
      args.item2,
      args.item3,
    );
  }

  // =========================== get node from root ============================
  static bip32.BIP32 getBip32NodeFromRootSync(
    bip32.BIP32 root,
    String derivePath,
  ) {
    return root.derivePath(derivePath);
  }

  static Future<bip32.BIP32> getBip32NodeFromRoot(
    bip32.BIP32 root,
    String derivePath,
  ) async {
    final node = await compute(
      _getBip32NodeFromRootWrapper,
      Tuple2(
        root,
        derivePath,
      ),
    );
    return node;
  }

  /// wrapper for compute()
  static bip32.BIP32 _getBip32NodeFromRootWrapper(
    Tuple2<bip32.BIP32, String> args,
  ) {
    return getBip32NodeFromRootSync(
      args.item1,
      args.item2,
    );
  }

  // =============================== get node ==================================
  static bip32.BIP32 getBip32NodeSync(
    String mnemonic,
    String mnemonicPassphrase,
    bip32.NetworkType network,
    String derivePath,
  ) {
    final root = getBip32RootSync(mnemonic, mnemonicPassphrase, network);

    final node = getBip32NodeFromRootSync(root, derivePath);
    return node;
  }

  static Future<bip32.BIP32> getBip32Node(
    String mnemonic,
    String mnemonicPassphrase,
    bip32.NetworkType networkType,
    String derivePath,
  ) async {
    final node = await compute(
      _getBip32NodeWrapper,
      Tuple4(
        mnemonic,
        mnemonicPassphrase,
        networkType,
        derivePath,
      ),
    );
    return node;
  }

  /// wrapper for compute()
  static bip32.BIP32 _getBip32NodeWrapper(
    Tuple4<String, String, bip32.NetworkType, String> args,
  ) {
    return getBip32NodeSync(
      args.item1,
      args.item2,
      args.item3,
      args.item4,
    );
  }
}
