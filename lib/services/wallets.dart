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

import 'package:flutter_libmonero/monero/monero.dart';
import 'package:flutter_libmonero/wownero/wownero.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/db/hive/db.dart';
import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/services/node_service.dart';
import 'package:stackwallet/services/notifications_service.dart';
import 'package:stackwallet/services/trade_sent_from_stack_service.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/enums/sync_type_enum.dart';
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/prefs.dart';
import 'package:stackwallet/wallets/isar/models/wallet_info.dart';
import 'package:stackwallet/wallets/wallet/impl/epiccash_wallet.dart';
import 'package:stackwallet/wallets/wallet/wallet.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/cw_based_interface.dart';

class Wallets {
  Wallets._private();

  static final Wallets _sharedInstance = Wallets._private();
  static Wallets get sharedInstance => _sharedInstance;

  late NodeService nodeService;
  late MainDB mainDB;

  List<Wallet> get wallets => _wallets.values.toList();

  static bool hasLoaded = false;

  final Map<String, Wallet> _wallets = {};

  Wallet getWallet(String walletId) {
    if (_wallets[walletId] != null) {
      return _wallets[walletId]!;
    } else {
      throw Exception("Wallet with id $walletId not found");
    }
  }

  void addWallet(Wallet wallet) {
    if (_wallets[wallet.walletId] != null) {
      throw Exception(
        "Tried to add wallet that already exists, according to it's wallet Id!",
      );
    }
    _wallets[wallet.walletId] = wallet;
  }

  Future<void> deleteWallet(
    WalletInfo info,
    SecureStorageInterface secureStorage,
  ) async {
    final walletId = info.walletId;
    Logging.instance.log(
      "deleteWallet called with walletId=$walletId",
      level: LogLevel.Warning,
    );

    final wallet = _wallets[walletId];
    _wallets.remove(walletId);
    await wallet?.exit();

    await secureStorage.delete(key: Wallet.mnemonicKey(walletId: walletId));
    await secureStorage.delete(
        key: Wallet.mnemonicPassphraseKey(walletId: walletId));
    await secureStorage.delete(key: Wallet.privateKeyKey(walletId: walletId));

    if (info.coin == Coin.wownero) {
      final wowService =
          wownero.createWowneroWalletService(DB.instance.moneroWalletInfoBox);
      await wowService.remove(walletId);
      Logging.instance
          .log("monero wallet: $walletId deleted", level: LogLevel.Info);
    } else if (info.coin == Coin.monero) {
      final xmrService =
          monero.createMoneroWalletService(DB.instance.moneroWalletInfoBox);
      await xmrService.remove(walletId);
      Logging.instance
          .log("monero wallet: $walletId deleted", level: LogLevel.Info);
    } else if (info.coin == Coin.epicCash) {
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
      await mainDB.isar.walletInfo.deleteByWalletId(walletId);
    });
  }

  Future<void> load(Prefs prefs, MainDB mainDB) async {
    // return await _loadV1(prefs, mainDB);
    // return await _loadV2(prefs, mainDB);
    return await _loadV3(prefs, mainDB);
  }

  Future<void> _loadV1(Prefs prefs, MainDB mainDB) async {
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

    final List<Future<void>> walletInitFutures = [];
    final List<({Wallet wallet, bool shouldAutoSync})> walletsToInitLinearly =
        [];

    final List<String> walletIdsToEnableAutoSync = [];
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
        final isVerified = await walletInfo.isMnemonicVerified(mainDB.isar);
        Logging.instance.log(
          "LOADING WALLET: ${walletInfo.name}:${walletInfo.walletId} "
          "IS VERIFIED: $isVerified",
          level: LogLevel.Info,
        );

        if (isVerified) {
          // TODO: integrate this into the new wallets somehow?
          // requires some thinking
          // final txTracker =
          //     TransactionNotificationTracker(walletId: walletInfo.walletId);

          final wallet = await Wallet.load(
            walletId: walletInfo.walletId,
            mainDB: mainDB,
            secureStorageInterface: nodeService.secureStorageInterface,
            nodeService: nodeService,
            prefs: prefs,
          );

          final shouldSetAutoSync = shouldAutoSyncAll ||
              walletIdsToEnableAutoSync.contains(walletInfo.walletId);

          if (wallet is CwBasedInterface) {
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

  /// should be fastest but big ui performance hit
  Future<void> _loadV2(Prefs prefs, MainDB mainDB) async {
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

    final List<Future<String>> walletIDInitFutures = [];
    final List<Future<void>> deleteFutures = [];
    final List<({Wallet wallet, bool shouldAutoSync})> walletsToInitLinearly =
        [];

    final List<String> walletIdsToEnableAutoSync = [];
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
        final isVerified = await walletInfo.isMnemonicVerified(mainDB.isar);
        Logging.instance.log(
          "LOADING WALLET: ${walletInfo.name}:${walletInfo.walletId} "
          "IS VERIFIED: $isVerified",
          level: LogLevel.Info,
        );

        if (isVerified) {
          // TODO: integrate this into the new wallets somehow?
          // requires some thinking
          // final txTracker =
          //     TransactionNotificationTracker(walletId: walletInfo.walletId);

          final walletIdCompleter = Completer<String>();

          walletIDInitFutures.add(walletIdCompleter.future);

          await Wallet.load(
            walletId: walletInfo.walletId,
            mainDB: mainDB,
            secureStorageInterface: nodeService.secureStorageInterface,
            nodeService: nodeService,
            prefs: prefs,
          ).then((wallet) {
            if (wallet is CwBasedInterface) {
              // walletsToInitLinearly.add(Tuple2(manager, shouldSetAutoSync));

              walletIdCompleter.complete("dummy_ignore");
            } else {
              walletIdCompleter.complete(wallet.walletId);
            }

            _wallets[wallet.walletId] = wallet;
          });
        } else {
          // wallet creation was not completed by user so we remove it completely
          deleteFutures.add(_deleteWallet(walletInfo.walletId));
        }
      } catch (e, s) {
        Logging.instance.log("$e $s", level: LogLevel.Fatal);
        continue;
      }
    }

    final asyncWalletIds = await Future.wait(walletIDInitFutures);
    asyncWalletIds.removeWhere((e) => e == "dummy_ignore");

    final List<Future<void>> walletInitFutures = asyncWalletIds
        .map(
          (id) => _wallets[id]!.init().then(
            (_) {
              if (shouldAutoSyncAll || walletIdsToEnableAutoSync.contains(id)) {
                _wallets[id]!.shouldAutoSync = true;
              }
            },
          ),
        )
        .toList();

    if (walletInitFutures.isNotEmpty && walletsToInitLinearly.isNotEmpty) {
      unawaited(Future.wait([
        _initLinearly(walletsToInitLinearly),
        ...walletInitFutures,
      ]));
    } else if (walletInitFutures.isNotEmpty) {
      unawaited(Future.wait(walletInitFutures));
    } else if (walletsToInitLinearly.isNotEmpty) {
      unawaited(_initLinearly(walletsToInitLinearly));
    }

    // finally await any deletions that haven't completed yet
    await Future.wait(deleteFutures);
  }

  /// should be best performance
  Future<void> _loadV3(Prefs prefs, MainDB mainDB) async {
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

    final List<Future<String>> walletIDInitFutures = [];
    final List<Future<void>> deleteFutures = [];
    final List<({Wallet wallet, bool shouldAutoSync})> walletsToInitLinearly =
        [];

    final List<String> walletIdsToSyncOnceOnStartup = [];
    bool shouldSyncAllOnceOnStartup = false;
    switch (prefs.syncType) {
      case SyncingType.currentWalletOnly:
        // do nothing as this will be set when going into a wallet from the main screen
        break;
      case SyncingType.selectedWalletsAtStartup:
        walletIdsToSyncOnceOnStartup.addAll(prefs.walletIdsSyncOnStartup);
        break;
      case SyncingType.allWalletsOnStartup:
        shouldSyncAllOnceOnStartup = true;
        break;
    }

    for (final walletInfo in walletInfoList) {
      try {
        final isVerified = await walletInfo.isMnemonicVerified(mainDB.isar);
        Logging.instance.log(
          "LOADING WALLET: ${walletInfo.name}:${walletInfo.walletId} "
          "IS VERIFIED: $isVerified",
          level: LogLevel.Info,
        );

        if (isVerified) {
          // TODO: integrate this into the new wallets somehow?
          // requires some thinking
          // final txTracker =
          //     TransactionNotificationTracker(walletId: walletInfo.walletId);

          final walletIdCompleter = Completer<String>();

          walletIDInitFutures.add(walletIdCompleter.future);

          await Wallet.load(
            walletId: walletInfo.walletId,
            mainDB: mainDB,
            secureStorageInterface: nodeService.secureStorageInterface,
            nodeService: nodeService,
            prefs: prefs,
          ).then((wallet) {
            if (wallet is CwBasedInterface) {
              // walletsToInitLinearly.add(Tuple2(manager, shouldSetAutoSync));

              walletIdCompleter.complete("dummy_ignore");
            } else {
              walletIdCompleter.complete(wallet.walletId);
            }

            _wallets[wallet.walletId] = wallet;
          });
        } else {
          // wallet creation was not completed by user so we remove it completely
          deleteFutures.add(_deleteWallet(walletInfo.walletId));
        }
      } catch (e, s) {
        Logging.instance.log("$e $s", level: LogLevel.Fatal);
        continue;
      }
    }

    final asyncWalletIds = await Future.wait(walletIDInitFutures);
    asyncWalletIds.removeWhere((e) => e == "dummy_ignore");

    final List<String> idsToRefresh = [];
    final List<Future<void>> walletInitFutures = asyncWalletIds
        .map(
          (id) => _wallets[id]!.init().then(
            (_) {
              if (shouldSyncAllOnceOnStartup ||
                  walletIdsToSyncOnceOnStartup.contains(id)) {
                idsToRefresh.add(id);
              }
            },
          ),
        )
        .toList();

    Future<void> _refreshFutures(List<String> idsToRefresh) async {
      final start = DateTime.now();
      Logging.instance.log(
        "Initial refresh start: ${start.toUtc()}",
        level: LogLevel.Warning,
      );
      const groupCount = 3;
      for (int i = 0; i < idsToRefresh.length; i += groupCount) {
        final List<Future<void>> futures = [];
        for (int j = 0; j < groupCount; j++) {
          if (i + j >= idsToRefresh.length) {
            break;
          }
          futures.add(
            _wallets[idsToRefresh[i + j]]!.refresh(),
          );
        }
        await Future.wait(futures);
      }
      Logging.instance.log(
        "Initial refresh duration: ${DateTime.now().difference(start)}",
        level: LogLevel.Warning,
      );
    }

    if (walletInitFutures.isNotEmpty && walletsToInitLinearly.isNotEmpty) {
      unawaited(
        Future.wait([
          _initLinearly(walletsToInitLinearly),
          ...walletInitFutures,
        ]).then(
          (value) => _refreshFutures(idsToRefresh),
        ),
      );
    } else if (walletInitFutures.isNotEmpty) {
      unawaited(
        Future.wait(walletInitFutures).then(
          (value) => _refreshFutures(idsToRefresh),
        ),
      );
    } else if (walletsToInitLinearly.isNotEmpty) {
      unawaited(_initLinearly(walletsToInitLinearly));
    }

    // finally await any deletions that haven't completed yet
    await Future.wait(deleteFutures);
  }

  Future<void> loadAfterStackRestore(
    Prefs prefs,
    List<Wallet> wallets,
    bool isDesktop,
  ) async {
    final List<Future<void>> walletInitFutures = [];
    final List<({Wallet wallet, bool shouldAutoSync})> walletsToInitLinearly =
        [];

    final List<String> walletIdsToEnableAutoSync = [];
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
      final isVerified = await wallet.info.isMnemonicVerified(mainDB.isar);
      Logging.instance.log(
        "LOADING WALLET: ${wallet.info.name}:${wallet.walletId} IS VERIFIED: $isVerified",
        level: LogLevel.Info,
      );

      if (isVerified) {
        final shouldSetAutoSync = shouldAutoSyncAll ||
            walletIdsToEnableAutoSync.contains(wallet.walletId);

        if (isDesktop) {
          if (wallet is CwBasedInterface) {
            // walletsToInitLinearly.add(Tuple2(manager, shouldSetAutoSync));
          } else {
            walletInitFutures.add(wallet.init().then((_) {
              // if (shouldSetAutoSync) {
              //   wallet.shouldAutoSync = true;
              // }
            }));
          }
        }

        _wallets[wallet.walletId] = wallet;
      } else {
        // wallet creation was not completed by user so we remove it completely
        await _deleteWallet(wallet.walletId);
        // await walletsService.deleteWallet(walletInfo.name, false);
      }
    }

    if (isDesktop) {
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
    await mainDB.isar.writeTxn(
        () async => await mainDB.isar.walletInfo.deleteByWalletId(walletId));
  }
}
