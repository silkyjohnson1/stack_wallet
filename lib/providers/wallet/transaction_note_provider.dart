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

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../models/isar/models/transaction_note.dart';
import '../db/main_db_provider.dart';

class _TransactionNoteWatcher extends ChangeNotifier {
  final ({String walletId, String txid}) key;
  late final StreamSubscription<List<TransactionNote>> _streamSubscription;

  TransactionNote? _value;

  TransactionNote? get value => _value;

  _TransactionNoteWatcher(this._value, this.key, Isar isar) {
    _streamSubscription = isar.transactionNotes
        .where()
        .txidWalletIdEqualTo(key.txid, key.walletId)
        .watch(fireImmediately: true)
        .listen((event) {
      if (event.isEmpty) {
        _value = null;
      } else {
        _value = event.first;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}

final _wiProvider = ChangeNotifierProvider.family<_TransactionNoteWatcher,
    ({String walletId, String txid})>(
  (ref, key) {
    final isar = ref.watch(mainDBProvider).isar;

    final watcher = _TransactionNoteWatcher(
      isar.transactionNotes
          .where()
          .txidWalletIdEqualTo(key.txid, key.walletId)
          .findFirstSync(),
      key,
      isar,
    );

    ref.onDispose(() => watcher.dispose());

    return watcher;
  },
);

final pTransactionNote =
    Provider.family<TransactionNote?, ({String walletId, String txid})>(
  (ref, key) {
    return ref.watch(_wiProvider(key).select((value) => value.value));
  },
);
