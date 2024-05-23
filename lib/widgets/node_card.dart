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
import '../notifications/show_flush_bar.dart';
import '../pages/settings_views/global_settings_view/manage_nodes_views/add_edit_node_view.dart';
import '../pages/settings_views/global_settings_view/manage_nodes_views/node_details_view.dart';
import '../providers/global/active_wallet_provider.dart';
import '../providers/global/secure_store_provider.dart';
import '../providers/providers.dart';
import '../themes/stack_colors.dart';
import '../utilities/assets.dart';
import '../utilities/constants.dart';
import '../utilities/default_nodes.dart';
import '../utilities/enums/sync_type_enum.dart';
import '../utilities/test_node_connection.dart';
import '../utilities/text_styles.dart';
import '../utilities/util.dart';
import '../wallets/crypto_currency/crypto_currency.dart';
import 'conditional_parent.dart';
import 'custom_buttons/blue_text_button.dart';
import 'expandable.dart';
import 'node_options_sheet.dart';
import 'rounded_white_container.dart';
import 'package:tuple/tuple.dart';

class NodeCard extends ConsumerStatefulWidget {
  const NodeCard({
    super.key,
    required this.nodeId,
    required this.coin,
    required this.popBackToRoute,
  });

  final CryptoCurrency coin;
  final String nodeId;
  final String popBackToRoute;

  @override
  ConsumerState<NodeCard> createState() => _NodeCardState();
}

class _NodeCardState extends ConsumerState<NodeCard> {
  String _status = "Disconnected";
  late final String nodeId;
  bool _advancedIsExpanded = false;

  Future<void> _notifyWalletsOfUpdatedNode(WidgetRef ref) async {
    final wallets =
        ref.read(pWallets).wallets.where((e) => e.info.coin == widget.coin);
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

  @override
  void initState() {
    nodeId = widget.nodeId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = ref.watch(
      nodeServiceChangeNotifierProvider
          .select((value) => value.getPrimaryNodeFor(currency: widget.coin)),
    );
    final _node = ref.watch(
      nodeServiceChangeNotifierProvider
          .select((value) => value.getNodeById(id: nodeId)),
    )!;

    if (node?.name == _node.name) {
      _status = "Connected";
    } else {
      _status = "Disconnected";
    }

    final isDesktop = Util.isDesktop;

    return RoundedWhiteContainer(
      padding: const EdgeInsets.all(0),
      borderColor: isDesktop
          ? Theme.of(context).extension<StackColors>()!.background
          : null,
      child: ConditionalParent(
        condition: !isDesktop,
        builder: (child) {
          return RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => NodeOptionsSheet(
                  nodeId: nodeId,
                  coin: widget.coin,
                  popBackToRoute: widget.popBackToRoute,
                ),
              );
            },
            child: child,
          );
        },
        child: ConditionalParent(
          condition: isDesktop,
          builder: (child) {
            return Expandable(
              onExpandChanged: (state) {
                setState(() {
                  _advancedIsExpanded = state == ExpandableState.expanded;
                });
              },
              header: child,
              body: Padding(
                padding: const EdgeInsets.only(
                  bottom: 24,
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 66,
                    ),
                    CustomTextButton(
                      text: "Connect",
                      enabled: _status == "Disconnected",
                      onTap: () async {
                        final nodeFormData = NodeFormData()
                          ..useSSL = _node.useSSL
                          ..trusted = _node.trusted
                          ..name = _node.name
                          ..host = _node.host
                          ..login = _node.loginName
                          ..port = _node.port
                          ..isFailover = _node.isFailover;
                        nodeFormData.password = await _node.getPassword(
                          ref.read(secureStoreProvider),
                        );

                        if (context.mounted) {
                          final canConnect = await testNodeConnection(
                            context: context,
                            nodeFormData: nodeFormData,
                            cryptoCurrency: widget.coin,
                            ref: ref,
                          );

                          if (!canConnect) {
                            if (context.mounted) {
                              unawaited(
                                showFloatingFlushBar(
                                  type: FlushBarType.warning,
                                  iconAsset: Assets.svg.circleAlert,
                                  message: "Could not connect to node",
                                  context: context,
                                ),
                              );
                            }
                            return;
                          }

                          await ref
                              .read(nodeServiceChangeNotifierProvider)
                              .setPrimaryNodeFor(
                                coin: widget.coin,
                                node: _node,
                                shouldNotifyListeners: true,
                              );

                          await _notifyWalletsOfUpdatedNode(ref);
                        }
                      },
                    ),
                    const SizedBox(
                      width: 48,
                    ),
                    CustomTextButton(
                      text: "Details",
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          NodeDetailsView.routeName,
                          arguments: Tuple3(
                            widget.coin,
                            widget.nodeId,
                            widget.popBackToRoute,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 16 : 12),
            child: Row(
              children: [
                Container(
                  width: isDesktop ? 40 : 24,
                  height: isDesktop ? 40 : 24,
                  decoration: BoxDecoration(
                    color: _node.id.startsWith(DefaultNodes.defaultNodeIdPrefix)
                        ? Theme.of(context)
                            .extension<StackColors>()!
                            .buttonBackSecondary
                        : Theme.of(context)
                            .extension<StackColors>()!
                            .infoItemIcons
                            .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.svg.node,
                      height: isDesktop ? 18 : 11,
                      width: isDesktop ? 20 : 14,
                      color:
                          _node.id.startsWith(DefaultNodes.defaultNodeIdPrefix)
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
                      _node.name,
                      style: STextStyles.titleBold12(context),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      _status,
                      style: STextStyles.label(context),
                    ),
                  ],
                ),
                const Spacer(),
                if (!isDesktop)
                  SvgPicture.asset(
                    Assets.svg.network,
                    color: _status == "Connected"
                        ? Theme.of(context)
                            .extension<StackColors>()!
                            .accentColorGreen
                        : Theme.of(context)
                            .extension<StackColors>()!
                            .buttonBackSecondary,
                    width: 20,
                    height: 20,
                  ),
                if (isDesktop)
                  SvgPicture.asset(
                    _advancedIsExpanded
                        ? Assets.svg.chevronUp
                        : Assets.svg.chevronDown,
                    width: 12,
                    height: 6,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textSubtitle1,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
