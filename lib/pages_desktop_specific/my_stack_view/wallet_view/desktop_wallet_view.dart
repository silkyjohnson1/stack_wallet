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
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';

import '../../../models/isar/models/blockchain_data/v2/transaction_v2.dart';
import '../../../models/isar/models/isar_models.dart';
import '../../../pages/add_wallet_views/add_token_view/edit_wallet_tokens_view.dart';
import '../../../pages/token_view/my_tokens_view.dart';
import '../../../pages/wallet_view/sub_widgets/transactions_list.dart';
import '../../../pages/wallet_view/transaction_views/all_transactions_view.dart';
import '../../../pages/wallet_view/transaction_views/tx_v2/all_transactions_v2_view.dart';
import '../../../pages/wallet_view/transaction_views/tx_v2/transaction_v2_list.dart';
import '../../../providers/db/main_db_provider.dart';
import '../../../providers/global/active_wallet_provider.dart';
import '../../../providers/global/auto_swb_service_provider.dart';
import '../../../providers/providers.dart';
import '../../../providers/ui/transaction_filter_provider.dart';
import '../../../services/event_bus/events/global/wallet_sync_status_changed_event.dart';
import '../../../services/event_bus/global_event_bus.dart';
import '../../../themes/coin_icon_provider.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/enums/backup_frequency_type.dart';
import '../../../utilities/enums/sync_type_enum.dart';
import '../../../utilities/text_styles.dart';
import '../../../utilities/wallet_tools.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../wallets/wallet/impl/banano_wallet.dart';
import '../../../wallets/wallet/impl/firo_wallet.dart';
import '../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../widgets/custom_buttons/blue_text_button.dart';
import '../../../widgets/desktop/desktop_app_bar.dart';
import '../../../widgets/desktop/desktop_scaffold.dart';
import '../../../widgets/hover_text_field.dart';
import '../../../widgets/rounded_white_container.dart';
import '../../coin_control/desktop_coin_control_use_dialog.dart';
import 'sub_widgets/desktop_wallet_features.dart';
import 'sub_widgets/desktop_wallet_summary.dart';
import 'sub_widgets/my_wallet.dart';
import 'sub_widgets/network_info_button.dart';
import 'sub_widgets/wallet_keys_button.dart';
import 'sub_widgets/wallet_options_button.dart';

/// [eventBus] should only be set during testing
class DesktopWalletView extends ConsumerStatefulWidget {
  const DesktopWalletView({
    super.key,
    required this.walletId,
    this.eventBus,
  });

  static const String routeName = "/desktopWalletView";

  final String walletId;
  final EventBus? eventBus;

  @override
  ConsumerState<DesktopWalletView> createState() => _DesktopWalletViewState();
}

class _DesktopWalletViewState extends ConsumerState<DesktopWalletView> {
  static const double sendReceiveColumnWidth = 460;

  late final TextEditingController controller;
  late final EventBus eventBus;

  // late final bool _shouldDisableAutoSyncOnLogOut;

  Future<void> onBackPressed() async {
    await _logout();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _logout() async {
    final wallet = ref.read(pWallets).getWallet(widget.walletId);
    // if (_shouldDisableAutoSyncOnLogOut) {
    //   // disable auto sync if it was enabled only when loading wallet
    wallet.shouldAutoSync = false;
    // }
    ref.read(transactionFilterProvider.state).state = null;
    if (ref.read(prefsChangeNotifierProvider).isAutoBackupEnabled &&
        ref.read(prefsChangeNotifierProvider).backupFrequencyType ==
            BackupFrequencyType.afterClosingAWallet) {
      unawaited(ref.read(autoSWBServiceProvider).doBackup());
    }

    // Close the wallet according to syncing preferences.
    switch (ref.read(prefsChangeNotifierProvider).syncType) {
      case SyncingType.currentWalletOnly:
        // Close the wallet.
        unawaited(wallet.exit());
      // unawaited so we don't lag the UI.
      case SyncingType.selectedWalletsAtStartup:
        // Close if this wallet is not in the list to be synced.
        if (!ref
            .read(prefsChangeNotifierProvider)
            .walletIdsSyncOnStartup
            .contains(widget.walletId)) {
          unawaited(wallet.exit());
          // unawaited so we don't lag the UI.
        }
      case SyncingType.allWalletsOnStartup:
        // Do nothing.
        break;
    }

    ref.read(currentWalletIdProvider.notifier).state = null;
  }

  @override
  void initState() {
    controller = TextEditingController();
    final wallet = ref.read(pWallets).getWallet(widget.walletId);

    controller.text = wallet.info.name;

    eventBus =
        widget.eventBus != null ? widget.eventBus! : GlobalEventBus.instance;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(currentWalletIdProvider.notifier).state = wallet.walletId;
        ref.read(desktopUseUTXOs.notifier).state = {};
      },
    );

    if (!wallet.shouldAutoSync) {
      //   // enable auto sync if it wasn't enabled when loading wallet
      wallet.shouldAutoSync = true;
      //   _shouldDisableAutoSyncOnLogOut = true;
      // } else {
      //   _shouldDisableAutoSyncOnLogOut = false;
    }

    wallet.refresh();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(pWallets).getWallet(widget.walletId);

    final monke = wallet is BananoWallet ? wallet.getMonkeyImageBytes() : null;

    return DesktopScaffold(
      appBar: DesktopAppBar(
        background: Theme.of(context).extension<StackColors>()!.popupBG,
        leading: Expanded(
          child: Row(
            children: [
              const SizedBox(
                width: 32,
              ),
              AppBarIconButton(
                size: 32,
                color: Theme.of(context)
                    .extension<StackColors>()!
                    .textFieldDefaultBG,
                shadows: const [],
                icon: SvgPicture.asset(
                  Assets.svg.arrowLeft,
                  width: 18,
                  height: 18,
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .topNavIconPrimary,
                ),
                onPressed: onBackPressed,
              ),
              const SizedBox(
                width: 15,
              ),
              SvgPicture.file(
                File(
                  ref.watch(coinIconProvider(wallet.info.coin)),
                ),
                width: 32,
                height: 32,
              ),
              const SizedBox(
                width: 12,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 48,
                ),
                child: IntrinsicWidth(
                  child: DesktopWalletNameField(
                    walletId: widget.walletId,
                  ),
                ),
              ),
              if (kDebugMode) const Spacer(),
              if (kDebugMode)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "dbgHeight: ",
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          ref
                              .watch(pWalletChainHeight(widget.walletId))
                              .toString(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "dbgTxCount: ",
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          wallet.isarTransactionVersion == 2
                              ? ref
                                  .watch(mainDBProvider)
                                  .isar
                                  .transactionV2s
                                  .where()
                                  .walletIdEqualTo(widget.walletId)
                                  .countSync()
                                  .toString()
                              : ref
                                  .watch(mainDBProvider)
                                  .isar
                                  .transactions
                                  .where()
                                  .walletIdEqualTo(widget.walletId)
                                  .countSync()
                                  .toString(),
                        ),
                      ],
                    ),
                    if (wallet.isarTransactionVersion == 2 &&
                        wallet is FiroWallet)
                      Row(
                        children: [
                          const Text(
                            "dbgBal: ",
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            WalletDevTools.checkFiroTransactionTally(
                              widget.walletId,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              const Spacer(),
              Row(
                children: [
                  NetworkInfoButton(
                    walletId: widget.walletId,
                    eventBus: eventBus,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  WalletKeysButton(
                    walletId: widget.walletId,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  WalletOptionsButton(
                    walletId: widget.walletId,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
        useSpacers: false,
        isCompactHeight: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            RoundedWhiteContainer(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (monke != null)
                    SvgPicture.memory(
                      Uint8List.fromList(monke!),
                      width: 60,
                      height: 60,
                    ),
                  if (monke == null)
                    SvgPicture.file(
                      File(
                        ref.watch(coinIconProvider(wallet.info.coin)),
                      ),
                      width: 40,
                      height: 40,
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  DesktopWalletSummary(
                    walletId: widget.walletId,
                    initialSyncStatus: wallet.refreshMutex.isLocked
                        ? WalletSyncStatus.syncing
                        : WalletSyncStatus.synced,
                  ),
                  const Spacer(),
                  DesktopWalletFeatures(
                    walletId: widget.walletId,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                SizedBox(
                  width: sendReceiveColumnWidth,
                  child: Text(
                    "My wallet",
                    style: STextStyles.desktopTextExtraSmall(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldActiveSearchIconLeft,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        wallet.cryptoCurrency.hasTokenSupport
                            ? "Tokens"
                            : "Recent activity",
                        style:
                            STextStyles.desktopTextExtraSmall(context).copyWith(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textFieldActiveSearchIconLeft,
                        ),
                      ),
                      CustomTextButton(
                        text: wallet.cryptoCurrency.hasTokenSupport
                            ? "Edit"
                            : "See all",
                        onTap: () async {
                          if (wallet.cryptoCurrency.hasTokenSupport) {
                            final result = await showDialog<int?>(
                              context: context,
                              builder: (context) => EditWalletTokensView(
                                walletId: widget.walletId,
                                isDesktopPopup: true,
                              ),
                            );

                            if (result == 42) {
                              // wallet tokens were edited so update ui
                              setState(() {});
                            }
                          } else {
                            await Navigator.of(context).pushNamed(
                              wallet.isarTransactionVersion == 2
                                  ? AllTransactionsV2View.routeName
                                  : AllTransactionsView.routeName,
                              arguments: widget.walletId,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: sendReceiveColumnWidth,
                    child: MyWallet(
                      walletId: widget.walletId,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: wallet.cryptoCurrency.hasTokenSupport
                        ? MyTokensView(
                            walletId: widget.walletId,
                          )
                        : wallet.isarTransactionVersion == 2
                            ? TransactionsV2List(
                                walletId: widget.walletId,
                              )
                            : TransactionsList(
                                walletId: widget.walletId,
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
