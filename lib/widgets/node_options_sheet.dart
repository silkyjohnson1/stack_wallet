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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solana/solana.dart';
import 'package:tuple/tuple.dart';

import '../models/node_model.dart';
import '../notifications/show_flush_bar.dart';
import '../pages/settings_views/global_settings_view/manage_nodes_views/add_edit_node_view.dart';
import '../pages/settings_views/global_settings_view/manage_nodes_views/node_details_view.dart';
import '../providers/global/active_wallet_provider.dart';
import '../providers/providers.dart';
import '../services/tor_service.dart';
import '../themes/stack_colors.dart';
import '../utilities/assets.dart';
import '../utilities/connection_check/electrum_connection_check.dart';
import '../utilities/constants.dart';
import '../utilities/default_nodes.dart';
import '../utilities/enums/sync_type_enum.dart';
import '../utilities/logger.dart';
import '../utilities/test_epic_box_connection.dart';
import '../utilities/test_eth_node_connection.dart';
import '../utilities/test_monero_node_connection.dart';
import '../utilities/text_styles.dart';
import '../wallets/crypto_currency/crypto_currency.dart';
import 'rounded_white_container.dart';

class NodeOptionsSheet extends ConsumerWidget {
  const NodeOptionsSheet({
    super.key,
    required this.nodeId,
    required this.coin,
    required this.popBackToRoute,
  });

  final String nodeId;
  final CryptoCurrency coin;
  final String popBackToRoute;

  Future<void> _notifyWalletsOfUpdatedNode(WidgetRef ref) async {
    final wallets =
        ref.read(pWallets).wallets.where((e) => e.info.coin == coin);
    final prefs = ref.read(prefsChangeNotifierProvider);

    switch (prefs.syncType) {
      case SyncingType.currentWalletOnly:
        for (final wallet in wallets) {
          if (ref.read(currentWalletIdProvider) == wallet.walletId) {
            unawaited(wallet.updateNode().then((value) => wallet.refresh()));
          } else {
            unawaited(wallet.updateNode());
          }
        }
        break;
      case SyncingType.selectedWalletsAtStartup:
        final List<String> walletIdsToSync = prefs.walletIdsSyncOnStartup;
        for (final wallet in wallets) {
          if (walletIdsToSync.contains(wallet.walletId)) {
            unawaited(wallet.updateNode().then((value) => wallet.refresh()));
          } else {
            unawaited(wallet.updateNode());
          }
        }
        break;
      case SyncingType.allWalletsOnStartup:
        for (final wallet in wallets) {
          unawaited(wallet.updateNode().then((value) => wallet.refresh()));
        }
        break;
    }
  }

  Future<bool> _testConnection(
    NodeModel node,
    BuildContext context,
    WidgetRef ref,
  ) async {
    bool testPassed = false;

    switch (coin.runtimeType) {
      case const (Epiccash):
        try {
          testPassed = await testEpicNodeConnection(
                NodeFormData()
                  ..host = node.host
                  ..useSSL = node.useSSL
                  ..port = node.port,
              ) !=
              null;
        } catch (e, s) {
          Logging.instance.log("$e\n$s", level: LogLevel.Warning);
        }
        break;

      case const (Monero):
      case const (Wownero):
        try {
          final uri = Uri.parse(node.host);
          if (uri.scheme.startsWith("http")) {
            final String path = uri.path.isEmpty ? "/json_rpc" : uri.path;

            final String uriString =
                "${uri.scheme}://${uri.host}:${node.port}$path";

            final response = await testMoneroNodeConnection(
              Uri.parse(uriString),
              false,
              proxyInfo: ref.read(prefsChangeNotifierProvider).useTor
                  ? ref.read(pTorService).getProxyInfo()
                  : null,
            );

            if (response.cert != null && context.mounted) {
              // if (mounted) {
              final shouldAllowBadCert = await showBadX509CertificateDialog(
                response.cert!,
                response.url!,
                response.port!,
                context,
              );

              if (shouldAllowBadCert) {
                final response = await testMoneroNodeConnection(
                  Uri.parse(uriString),
                  true,
                  proxyInfo: ref.read(prefsChangeNotifierProvider).useTor
                      ? ref.read(pTorService).getProxyInfo()
                      : null,
                );
                testPassed = response.success;
              }
              // }
            } else {
              testPassed = response.success;
            }
          }
        } catch (e, s) {
          Logging.instance.log("$e\n$s", level: LogLevel.Warning);
        }

        break;

      case const (Bitcoin):
      case const (Litecoin):
      case const (Dogecoin):
      case const (Firo):
      case const (Particl):
      case const (Bitcoincash):
      case const (Namecoin):
      case const (Ecash):
      case const (BitcoinFrost):
      case const (Peercoin):
        try {
          testPassed = await checkElectrumServer(
            host: node.host,
            port: node.port,
            useSSL: node.useSSL,
            overridePrefs: ref.read(prefsChangeNotifierProvider),
            overrideTorService: ref.read(pTorService),
          );
        } catch (_) {
          testPassed = false;
        }

        break;

      case const (Ethereum):
        try {
          testPassed = await testEthNodeConnection(node.host);
        } catch (_) {
          testPassed = false;
        }
        break;

      case const (Nano):
      case const (Banano):
      case const (Tezos):
      case const (Stellar):
        throw UnimplementedError();
      //TODO: check network/node

      case const (Solana):
        try {
          RpcClient rpcClient;
          if (node.host.startsWith("http") || node.host.startsWith("https")) {
            rpcClient = RpcClient("${node.host}:${node.port}");
          } else {
            rpcClient = RpcClient("http://${node.host}:${node.port}");
          }
          await rpcClient.getEpochInfo().then((value) => testPassed = true);
        } catch (_) {
          testPassed = false;
        }
        break;
    }

    if (testPassed) {
      // showFloatingFlushBar(
      //   type: FlushBarType.success,
      //   message: "Server ping success",
      //   context: context,
      // );
    } else {
      unawaited(
        showFloatingFlushBar(
          type: FlushBarType.warning,
          iconAsset: Assets.svg.circleAlert,
          message: "Could not connect to node",
          context: context,
        ),
      );
    }

    return testPassed;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxHeight = MediaQuery.of(context).size.height * 0.60;
    final node = ref.watch(
      nodeServiceChangeNotifierProvider
          .select((value) => value.getNodeById(id: nodeId)),
    )!;

    final status = ref
                .watch(
                  nodeServiceChangeNotifierProvider.select(
                    (value) => value.getPrimaryNodeFor(currency: coin),
                  ),
                )
                ?.id !=
            nodeId
        ? "Disconnected"
        : "Connected";

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<StackColors>()!.popupBG,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: LimitedBox(
        maxHeight: maxHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 10,
            bottom: 0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldDefaultBG,
                      borderRadius: BorderRadius.circular(
                        Constants.size.circularBorderRadius,
                      ),
                    ),
                    width: 60,
                    height: 4,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Text(
                  "Node options",
                  style: STextStyles.pageTitleH2(context),
                  textAlign: TextAlign.left,
                ),
                RoundedWhiteContainer(
                  padding: const EdgeInsets.symmetric(vertical: 38),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: node.id
                                  .startsWith(DefaultNodes.defaultNodeIdPrefix)
                              ? Theme.of(context)
                                  .extension<StackColors>()!
                                  .textSubtitle4
                              : Theme.of(context)
                                  .extension<StackColors>()!
                                  .infoItemIcons
                                  .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.svg.node,
                            height: 15,
                            width: 19,
                            color: node.id.startsWith(
                              DefaultNodes.defaultNodeIdPrefix,
                            )
                                ? Theme.of(context)
                                    .extension<StackColors>()!
                                    .accentColorDark
                                : Theme.of(context)
                                    .extension<StackColors>()!
                                    .infoItemIcons,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            node.name,
                            style: STextStyles.titleBold12(context),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            status,
                            style: STextStyles.label(context),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        Assets.svg.network,
                        color: status == "Connected"
                            ? Theme.of(context)
                                .extension<StackColors>()!
                                .accentColorGreen
                            : Theme.of(context)
                                .extension<StackColors>()!
                                .buttonBackSecondary,
                        width: 18,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // if (!node.id.startsWith("default"))
                    Expanded(
                      child: TextButton(
                        style: Theme.of(context)
                            .extension<StackColors>()!
                            .getSecondaryEnabledButtonStyle(context),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed(
                            NodeDetailsView.routeName,
                            arguments: Tuple3(
                              coin,
                              node.id,
                              popBackToRoute,
                            ),
                          );
                        },
                        child: Text(
                          "Details",
                          style: STextStyles.button(context).copyWith(
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .accentColorDark,
                          ),
                        ),
                      ),
                    ),
                    // if (!node.id.startsWith("default"))
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextButton(
                        style: status == "Connected"
                            ? Theme.of(context)
                                .extension<StackColors>()!
                                .getPrimaryDisabledButtonStyle(context)
                            : Theme.of(context)
                                .extension<StackColors>()!
                                .getPrimaryEnabledButtonStyle(context),
                        onPressed: status == "Connected"
                            ? null
                            : () async {
                                final canConnect =
                                    await _testConnection(node, context, ref);
                                if (!canConnect) {
                                  return;
                                }

                                await ref
                                    .read(nodeServiceChangeNotifierProvider)
                                    .setPrimaryNodeFor(
                                      coin: coin,
                                      node: node,
                                      shouldNotifyListeners: true,
                                    );

                                await _notifyWalletsOfUpdatedNode(ref);
                              },
                        child: Text(
                          // status == "Connected" ? "Disconnect" : "Connect",
                          "Connect",
                          style: STextStyles.button(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
