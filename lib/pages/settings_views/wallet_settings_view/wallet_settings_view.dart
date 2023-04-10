import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/epicbox_config_model.dart';
import 'package:stackwallet/notifications/show_flush_bar.dart';
import 'package:stackwallet/pages/address_book_views/address_book_view.dart';
import 'package:stackwallet/pages/home_view/home_view.dart';
import 'package:stackwallet/pages/pinpad_views/lock_screen_view.dart';
import 'package:stackwallet/pages/settings_views/global_settings_view/advanced_views/debug_view.dart';
import 'package:stackwallet/pages/settings_views/global_settings_view/syncing_preferences_views/syncing_preferences_view.dart';
import 'package:stackwallet/pages/settings_views/global_settings_view/xpub_view.dart';
import 'package:stackwallet/pages/settings_views/sub_widgets/settings_list_button.dart';
import 'package:stackwallet/pages/settings_views/wallet_settings_view/wallet_backup_views/wallet_backup_view.dart';
import 'package:stackwallet/pages/settings_views/wallet_settings_view/wallet_network_settings_view/wallet_network_settings_view.dart';
import 'package:stackwallet/pages/settings_views/wallet_settings_view/wallet_settings_wallet_settings/wallet_settings_wallet_settings_view.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/providers/ui/transaction_filter_provider.dart';
import 'package:stackwallet/route_generator.dart';
import 'package:stackwallet/services/coins/epiccash/epiccash_wallet.dart';
import 'package:stackwallet/services/event_bus/events/global/node_connection_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/events/global/wallet_sync_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/global_event_bus.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:tuple/tuple.dart';

/// [eventBus] should only be set during testing
class WalletSettingsView extends StatefulWidget {
  const WalletSettingsView({
    Key? key,
    required this.walletId,
    required this.coin,
    required this.initialSyncStatus,
    required this.initialNodeStatus,
    this.eventBus,
  }) : super(key: key);

  static const String routeName = "/walletSettings";

  final String walletId;
  final Coin coin;
  final WalletSyncStatus initialSyncStatus;
  final NodeConnectionStatus initialNodeStatus;
  final EventBus? eventBus;

  @override
  State<WalletSettingsView> createState() => _WalletSettingsViewState();
}

class _WalletSettingsViewState extends State<WalletSettingsView> {
  late final String walletId;
  late final Coin coin;
  late String xpub;
  late final bool xPubEnabled;

  late final EventBus eventBus;

  late WalletSyncStatus _currentSyncStatus;
  // late NodeConnectionStatus _currentNodeStatus;

  late StreamSubscription<dynamic> _syncStatusSubscription;
  // late StreamSubscription _nodeStatusSubscription;

  @override
  void initState() {
    walletId = widget.walletId;
    coin = widget.coin;
    xPubEnabled =
        coin != Coin.monero && coin != Coin.wownero && coin != Coin.epicCash;
    xpub = "";

    _currentSyncStatus = widget.initialSyncStatus;
    // _currentNodeStatus = widget.initialNodeStatus;

    eventBus =
        widget.eventBus != null ? widget.eventBus! : GlobalEventBus.instance;

    _syncStatusSubscription =
        eventBus.on<WalletSyncStatusChangedEvent>().listen(
      (event) async {
        if (event.walletId == walletId) {
          switch (event.newStatus) {
            case WalletSyncStatus.unableToSync:
              // TODO: Handle this case.
              break;
            case WalletSyncStatus.synced:
              // TODO: Handle this case.
              break;
            case WalletSyncStatus.syncing:
              // TODO: Handle this case.
              break;
          }
          setState(() {
            _currentSyncStatus = event.newStatus;
          });
        }
      },
    );

    // _nodeStatusSubscription =
    //     eventBus.on<NodeConnectionStatusChangedEvent>().listen(
    //   (event) async {
    //     if (event.walletId == widget.walletId) {
    //       switch (event.newStatus) {
    //         case NodeConnectionStatus.disconnected:
    //           // TODO: Handle this case.
    //           break;
    //         case NodeConnectionStatus.connected:
    //           // TODO: Handle this case.
    //           break;
    //         case NodeConnectionStatus.connecting:
    //           // TODO: Handle this case.
    //           break;
    //       }
    //       setState(() {
    //         _currentNodeStatus = event.newStatus;
    //       });
    //     }
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    // _nodeStatusSubscription.cancel();
    _syncStatusSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return Background(
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<StackColors>()!.background,
        appBar: AppBar(
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Settings",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: LayoutBuilder(
          builder: (builderContext, constraints) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 12,
                right: 12,
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 24,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RoundedWhiteContainer(
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              children: [
                                SettingsListButton(
                                  iconAssetName: Assets.svg.addressBook,
                                  iconSize: 16,
                                  title: "Address book",
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      AddressBookView.routeName,
                                      arguments: coin,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SettingsListButton(
                                  iconAssetName: Assets.svg.node,
                                  iconSize: 16,
                                  title: "Network",
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      WalletNetworkSettingsView.routeName,
                                      arguments: Tuple3(
                                        walletId,
                                        _currentSyncStatus,
                                        widget.initialNodeStatus,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Consumer(
                                  builder: (_, ref, __) {
                                    return SettingsListButton(
                                      iconAssetName: Assets.svg.lock,
                                      iconSize: 16,
                                      title: "Wallet backup",
                                      onPressed: () async {
                                        final mnemonic = await ref
                                            .read(walletsChangeNotifierProvider)
                                            .getManager(walletId)
                                            .mnemonic;

                                        if (mounted) {
                                          Navigator.push(
                                            context,
                                            RouteGenerator.getRoute(
                                              shouldUseMaterialRoute:
                                                  RouteGenerator
                                                      .useMaterialPageRoute,
                                              builder: (_) => LockscreenView(
                                                routeOnSuccessArguments:
                                                    Tuple2(walletId, mnemonic),
                                                showBackButton: true,
                                                routeOnSuccess:
                                                    WalletBackupView.routeName,
                                                biometricsCancelButtonString:
                                                    "CANCEL",
                                                biometricsLocalizedReason:
                                                    "Authenticate to view recovery phrase",
                                                biometricsAuthenticationTitle:
                                                    "View recovery phrase",
                                              ),
                                              settings: const RouteSettings(
                                                  name:
                                                      "/viewRecoverPhraseLockscreen"),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SettingsListButton(
                                  iconAssetName: Assets.svg.downloadFolder,
                                  title: "Wallet settings",
                                  iconSize: 16,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      WalletSettingsWalletSettingsView
                                          .routeName,
                                      arguments: walletId,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SettingsListButton(
                                  iconAssetName: Assets.svg.arrowRotate3,
                                  title: "Syncing preferences",
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        SyncingPreferencesView.routeName);
                                  },
                                ),
                                if (xPubEnabled)
                                  const SizedBox(
                                    height: 8,
                                  ),
                                if (xPubEnabled)
                                  Consumer(
                                    builder: (_, ref, __) {
                                      return SettingsListButton(
                                        iconAssetName: Assets.svg.eye,
                                        title: "Wallet xPub",
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            XPubView.routeName,
                                            arguments: widget.walletId,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SettingsListButton(
                                  iconAssetName: Assets.svg.ellipsis,
                                  title: "Debug Info",
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(DebugView.routeName);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Spacer(),
                          Consumer(
                            builder: (_, ref, __) {
                              return TextButton(
                                onPressed: () {
                                  ref
                                      .read(walletsChangeNotifierProvider)
                                      .getManager(walletId)
                                      .isActiveWallet = false;
                                  ref
                                      .read(transactionFilterProvider.state)
                                      .state = null;

                                  Navigator.of(context).popUntil(
                                    ModalRoute.withName(HomeView.routeName),
                                  );
                                },
                                style: Theme.of(context)
                                    .extension<StackColors>()!
                                    .getSecondaryEnabledButtonStyle(context),
                                child: Text(
                                  "Log out",
                                  style: STextStyles.button(context).copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .accentColorDark),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EpicBoxInfoForm extends ConsumerStatefulWidget {
  const EpicBoxInfoForm({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  final String walletId;

  @override
  ConsumerState<EpicBoxInfoForm> createState() => _EpiBoxInfoFormState();
}

class _EpiBoxInfoFormState extends ConsumerState<EpicBoxInfoForm> {
  final hostController = TextEditingController();
  final portController = TextEditingController();

  late EpicCashWallet wallet;

  @override
  void initState() {
    wallet = ref
        .read(walletsChangeNotifierProvider)
        .getManager(widget.walletId)
        .wallet as EpicCashWallet;

    wallet.getEpicBoxConfig().then((EpicBoxConfigModel epicBoxConfig) {
      hostController.text = epicBoxConfig.host;
      portController.text = "${epicBoxConfig.port ?? 443}";
    });
    super.initState();
  }

  @override
  void dispose() {
    hostController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            autocorrect: Util.isDesktop ? false : true,
            enableSuggestions: Util.isDesktop ? false : true,
            controller: hostController,
            decoration: const InputDecoration(hintText: "Host"),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            autocorrect: Util.isDesktop ? false : true,
            enableSuggestions: Util.isDesktop ? false : true,
            controller: portController,
            decoration: const InputDecoration(hintText: "Port"),
            keyboardType:
                Util.isDesktop ? null : const TextInputType.numberWithOptions(),
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () async {
              try {
                wallet.updateEpicboxConfig(
                  hostController.text,
                  int.parse(portController.text),
                );
                showFloatingFlushBar(
                  context: context,
                  message: "Epicbox info saved!",
                  type: FlushBarType.success,
                );
                wallet.refresh();
              } catch (e) {
                showFloatingFlushBar(
                  context: context,
                  message: "Failed to save epicbox info: $e",
                  type: FlushBarType.warning,
                );
              }
            },
            child: Text(
              "Save",
              style: STextStyles.button(context).copyWith(
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .accentColorDark),
            ),
          ),
        ],
      ),
    );
  }
}
