/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter_libmonero/monero/monero.dart';
import 'package:flutter_libmonero/wownero/wownero.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/db/hive/db.dart';
import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/services/coins/epiccash/epiccash_wallet.dart';
import 'package:stackwallet/services/node_service.dart';
import 'package:stackwallet/services/notifications_service.dart';
import 'package:stackwallet/services/trade_sent_from_stack_service.dart';
import 'package:stackwallet/services/transaction_notification_tracker.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/enums/sync_type_enum.dart';
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/prefs.dart';
import 'package:stackwallet/wallets/isar/models/wallet_info.dart';
import 'package:stackwallet/wallets/wallet/wallet.dart';

class Wallets {
  Wallets._private();

  static final Wallets _sharedInstance = Wallets._private();
  static Wallets get sharedInstance => _sharedInstance;

  late NodeService nodeService;
  late MainDB mainDB;

  bool get hasWallets => _wallets.isNotEmpty;

  List<Wallet> get wallets => _wallets.values.toList();

  List<({Coin coin, List<Wallet> wallets})> get walletsByCoin {
    final Map<Coin, ({Coin coin, List<Wallet> wallets})> map = {};

    for (final wallet in wallets) {
      if (map[wallet.info.coin] == null) {
        map[wallet.info.coin] = (coin: wallet.info.coin, wallets: []);
      }

      map[wallet.info.coin]!.wallets.add(wallet);
    }

    final List<({Coin coin, List<Wallet> wallets})> results = [];
    for (final coin in Coin.values) {
      if (map[coin] != null) {
        results.add(map[coin]!);
      }
    }

    return results;
  }

  static bool hasLoaded = false;

  final Map<String, Wallet> _wallets = {};

  Wallet getWallet(String walletId) => _wallets[walletId]!;

  void addWallet(Wallet wallet) {
    if (_wallets[wallet.walletId] != null) {
      throw Exception(
        "Tried to add wallet that already exists, according to it's wallet Id!",
      );
    }
    _wallets[wallet.walletId] = wallet;
  }

  Future<void> deleteWallet(
    String walletId,
    SecureStorageInterface secureStorage,
  ) async {
    Logging.instance.log(
      "deleteWallet called with walletId=$walletId",
      level: LogLevel.Warning,
    );

    final wallet = getWallet(walletId)!;

    await secureStorage.delete(key: Wallet.mnemonicKey(walletId: walletId));
    await secureStorage.delete(
        key: Wallet.mnemonicPassphraseKey(walletId: walletId));
    await secureStorage.delete(key: Wallet.privateKeyKey(walletId: walletId));

    if (wallet.info.coin == Coin.wownero) {
      final wowService =
          wownero.createWowneroWalletService(DB.instance.moneroWalletInfoBox);
      await wowService.remove(walletId);
      Logging.instance
          .log("monero wallet: $walletId deleted", level: LogLevel.Info);
    } else if (wallet.info.coin == Coin.monero) {
      final xmrService =
          monero.createMoneroWalletService(DB.instance.moneroWalletInfoBox);
      await xmrService.remove(walletId);
      Logging.instance
          .log("monero wallet: $walletId deleted", level: LogLevel.Info);
    } else if (wallet.info.coin == Coin.epicCash) {
      final deleteResult = await deleteEpicWallet(
          walletId: walletId, secureStore: secureStorage);
      Logging.instance.log(
          "epic wallet: $walletId deleted with result: $deleteResult",
          level: LogLevel.Info);
    }

    // delete wallet data in main db
    await MainDB.instance.deleteWalletBlockchainData(walletId);
    await MainDB.instance.deleteAddressLabels(walletId);
    await MainDB.instance.deleteTransactionNotes(walletId);

    // box data may currently still be read/written to if wallet was refreshing
    // when delete was requested so instead of deleting now we mark the wallet
    // as needs delete by adding it's id to a list which gets checked on app start
    await DB.instance.add<String>(
        boxName: DB.boxNameWalletsToDeleteOnStart, value: walletId);

    final lookupService = TradeSentFromStackService();
    for (final lookup in lookupService.all) {
      if (lookup.walletIds.contains(walletId)) {
        // update lookup data to reflect deleted wallet
        await lookupService.save(
          tradeWalletLookup: lookup.copyWith(
            walletIds: lookup.walletIds.where((id) => id != walletId).toList(),
          ),
        );
      }
    }

    // delete notifications tied to deleted wallet
    for (final notification in NotificationsService.instance.notifications) {
      if (notification.walletId == walletId) {
        await NotificationsService.instance.delete(notification, false);
      }
    }

    await mainDB.isar.writeTxn(() async {
      await mainDB.isar.walletInfo.deleteAllByWalletId([walletId]);
    });
  }

  Future<void> load(Prefs prefs, MainDB mainDB) async {
    if (hasLoaded) {
      return;
    }
    hasLoaded = true;

    // clear out any wallet hive boxes where the wallet was deleted in previous app run
    for (final walletId in DB.instance
        .values<String>(boxName: DB.boxNameWalletsToDeleteOnStart)) {
      await mainDB.isar.writeTxn(() async => await mainDB.isar.walletInfo
          .where()
          .walletIdEqualTo(walletId)
          .deleteAll());
    }
    // clear list
    await DB.instance
        .deleteAll<String>(boxName: DB.boxNameWalletsToDeleteOnStart);

    final walletInfoList = await mainDB.isar.walletInfo.where().findAll();
    if (walletInfoList.isEmpty) {
      return;
    }

    List<Future<void>> walletInitFutures = [];
    List<({Wallet wallet, bool shouldAutoSync})> walletsToInitLinearly = [];

    List<String> walletIdsToEnableAutoSync = [];
    bool shouldAutoSyncAll = false;
    switch (prefs.syncType) {
      case SyncingType.currentWalletOnly:
        // do nothing as this will be set when going into a wallet from the main screen
        break;
      case SyncingType.selectedWalletsAtStartup:
        walletIdsToEnableAutoSync.addAll(prefs.walletIdsSyncOnStartup);
        break;
      case SyncingType.allWalletsOnStartup:
        shouldAutoSyncAll = true;
        break;
    }

    for (final walletInfo in walletInfoList) {
      try {
        Logging.instance.log(
          "LOADING WALLET: ${walletInfo.name}:${walletInfo.walletId} "
          "IS VERIFIED: ${walletInfo.isMnemonicVerified}",
          level: LogLevel.Info,
        );

        if (walletInfo.isMnemonicVerified) {
          // TODO: integrate this into the new wallets somehow?
          // requires some thinking
          final txTracker =
              TransactionNotificationTracker(walletId: walletInfo.walletId);

          final wallet = await Wallet.load(
            walletId: walletInfo.walletId,
            mainDB: mainDB,
            secureStorageInterface: nodeService.secureStorageInterface,
            nodeService: nodeService,
            prefs: prefs,
          );

          final shouldSetAutoSync = shouldAutoSyncAll ||
              walletIdsToEnableAutoSync.contains(walletInfo.walletId);

          if (walletInfo.coin == Coin.monero ||
              walletInfo.coin == Coin.wownero) {
            // walletsToInitLinearly.add(Tuple2(manager, shouldSetAutoSync));
          } else {
            walletInitFutures.add(wallet.init().then((_) {
              if (shouldSetAutoSync) {
                wallet.shouldAutoSync = true;
              }
            }));
          }

          _wallets[wallet.walletId] = wallet;
        } else {
          // wallet creation was not completed by user so we remove it completely
          await _deleteWallet(walletInfo.walletId);
          // await walletsService.deleteWallet(walletInfo.name, false);
        }
      } catch (e, s) {
        Logging.instance.log("$e $s", level: LogLevel.Fatal);
        continue;
      }
    }

    if (walletInitFutures.isNotEmpty && walletsToInitLinearly.isNotEmpty) {
      await Future.wait([
        _initLinearly(walletsToInitLinearly),
        ...walletInitFutures,
      ]);
    } else if (walletInitFutures.isNotEmpty) {
      await Future.wait(walletInitFutures);
    } else if (walletsToInitLinearly.isNotEmpty) {
      await _initLinearly(walletsToInitLinearly);
    }
  }

  Future<void> loadAfterStackRestore(
    Prefs prefs,
    List<Wallet> wallets,
  ) async {
    List<Future<void>> walletInitFutures = [];
    List<({Wallet wallet, bool shouldAutoSync})> walletsToInitLinearly = [];

    List<String> walletIdsToEnableAutoSync = [];
    bool shouldAutoSyncAll = false;
    switch (prefs.syncType) {
      case SyncingType.currentWalletOnly:
        // do nothing as this will be set when going into a wallet from the main screen
        break;
      case SyncingType.selectedWalletsAtStartup:
        walletIdsToEnableAutoSync.addAll(prefs.walletIdsSyncOnStartup);
        break;
      case SyncingType.allWalletsOnStartup:
        shouldAutoSyncAll = true;
        break;
    }

    for (final wallet in wallets) {
      Logging.instance.log(
        "LOADING WALLET: ${wallet.info.name}:${wallet.walletId} IS VERIFIED: ${wallet.info.isMnemonicVerified}",
        level: LogLevel.Info,
      );

      if (wallet.info.isMnemonicVerified) {
        final shouldSetAutoSync = shouldAutoSyncAll ||
            walletIdsToEnableAutoSync.contains(wallet.walletId);

        if (wallet.info.coin == Coin.monero ||
            wallet.info.coin == Coin.wownero) {
          // walletsToInitLinearly.add(Tuple2(manager, shouldSetAutoSync));
        } else {
          walletInitFutures.add(wallet.init().then((value) {
            if (shouldSetAutoSync) {
              wallet.shouldAutoSync = true;
            }
          }));
        }

        _wallets[wallet.walletId] = wallet;
      } else {
        // wallet creation was not completed by user so we remove it completely
        await _deleteWallet(wallet.walletId);
        // await walletsService.deleteWallet(walletInfo.name, false);
      }
    }

    if (walletInitFutures.isNotEmpty && walletsToInitLinearly.isNotEmpty) {
      await Future.wait([
        _initLinearly(walletsToInitLinearly),
        ...walletInitFutures,
      ]);
    } else if (walletInitFutures.isNotEmpty) {
      await Future.wait(walletInitFutures);
    } else if (walletsToInitLinearly.isNotEmpty) {
      await _initLinearly(walletsToInitLinearly);
    }
  }

  Future<void> _initLinearly(
    List<({Wallet wallet, bool shouldAutoSync})> dataList,
  ) async {
    for (final data in dataList) {
      await data.wallet.init();
      if (data.shouldAutoSync && !data.wallet.shouldAutoSync) {
        data.wallet.shouldAutoSync = true;
      }
    }
  }

  Future<void> _deleteWallet(String walletId) async {
    // TODO proper clean up of other wallet data in addition to the following
    await mainDB.isar.writeTxn(() async => await mainDB.isar.walletInfo
        .where()
        .walletIdEqualTo(walletId)
        .deleteAll());
  }
}
