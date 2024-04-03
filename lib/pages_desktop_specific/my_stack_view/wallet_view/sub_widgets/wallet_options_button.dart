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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages/settings_views/wallet_settings_view/frost_ms/frost_ms_options_view.dart';
import 'package:stackwallet/pages/settings_views/wallet_settings_view/wallet_settings_wallet_settings/change_representative_view.dart';
import 'package:stackwallet/pages/settings_views/wallet_settings_view/wallet_settings_wallet_settings/xpub_view.dart';
import 'package:stackwallet/pages_desktop_specific/addresses/desktop_wallet_addresses_view.dart';
import 'package:stackwallet/pages_desktop_specific/lelantus_coins/lelantus_coins_view.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/desktop_delete_wallet_dialog.dart';
import 'package:stackwallet/pages_desktop_specific/spark_coins/spark_coins_view.dart';
import 'package:stackwallet/route_generator.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/wallets/isar/providers/wallet_info_provider.dart';

enum _WalletOptions {
  addressList,
  deleteWallet,
  changeRepresentative,
  showXpub,
  lelantusCoins,
  sparkCoins,
  frostOptions;

  String get prettyName {
    switch (this) {
      case _WalletOptions.addressList:
        return "Address list";
      case _WalletOptions.deleteWallet:
        return "Delete wallet";
      case _WalletOptions.changeRepresentative:
        return "Change representative";
      case _WalletOptions.showXpub:
        return "Show xPub";
      case _WalletOptions.lelantusCoins:
        return "Lelantus Coins";
      case _WalletOptions.sparkCoins:
        return "Spark Coins";
      case _WalletOptions.frostOptions:
        return "FROST settings";
    }
  }
}

class WalletOptionsButton extends StatelessWidget {
  const WalletOptionsButton({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  final String walletId;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        minHeight: 32,
        minWidth: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
      onPressed: () async {
        final func = await showDialog<_WalletOptions?>(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) {
            return WalletOptionsPopupMenu(
              onDeletePressed: () async {
                Navigator.of(context).pop(_WalletOptions.deleteWallet);
              },
              onAddressListPressed: () async {
                Navigator.of(context).pop(_WalletOptions.addressList);
              },
              onChangeRepPressed: () async {
                Navigator.of(context).pop(_WalletOptions.changeRepresentative);
              },
              onShowXpubPressed: () async {
                Navigator.of(context).pop(_WalletOptions.showXpub);
              },
              onFiroShowLelantusCoins: () async {
                Navigator.of(context).pop(_WalletOptions.lelantusCoins);
              },
              onFiroShowSparkCoins: () async {
                Navigator.of(context).pop(_WalletOptions.sparkCoins);
              },
              onFrostMSWalletOptionsPressed: () async {
                Navigator.of(context).pop(_WalletOptions.frostOptions);
              },
              walletId: walletId,
            );
          },
        );

        if (context.mounted && func != null) {
          switch (func) {
            case _WalletOptions.addressList:
              unawaited(
                Navigator.of(context).pushNamed(
                  DesktopWalletAddressesView.routeName,
                  arguments: walletId,
                ),
              );
              break;
            case _WalletOptions.deleteWallet:
              final result = await showDialog<bool?>(
                context: context,
                barrierDismissible: false,
                builder: (context) => Navigator(
                  initialRoute: DesktopDeleteWalletDialog.routeName,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  onGenerateInitialRoutes: (_, __) {
                    return [
                      RouteGenerator.generateRoute(
                        RouteSettings(
                          name: DesktopDeleteWalletDialog.routeName,
                          arguments: walletId,
                        ),
                      ),
                    ];
                  },
                ),
              );

              if (result == true) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
              break;
            case _WalletOptions.showXpub:
              final result = await showDialog<bool?>(
                context: context,
                barrierDismissible: false,
                builder: (context) => Navigator(
                  initialRoute: XPubView.routeName,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  onGenerateInitialRoutes: (_, __) {
                    return [
                      RouteGenerator.generateRoute(
                        RouteSettings(
                          name: XPubView.routeName,
                          arguments: walletId,
                        ),
                      ),
                    ];
                  },
                ),
              );

              if (result == true) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
              break;
            case _WalletOptions.changeRepresentative:
              final result = await showDialog<bool?>(
                context: context,
                barrierDismissible: false,
                builder: (context) => Navigator(
                  initialRoute: ChangeRepresentativeView.routeName,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  onGenerateInitialRoutes: (_, __) {
                    return [
                      RouteGenerator.generateRoute(
                        RouteSettings(
                          name: ChangeRepresentativeView.routeName,
                          arguments: walletId,
                        ),
                      ),
                    ];
                  },
                ),
              );

              if (result == true) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
              break;

            case _WalletOptions.lelantusCoins:
              unawaited(
                Navigator.of(context).pushNamed(
                  LelantusCoinsView.routeName,
                  arguments: walletId,
                ),
              );
              break;

            case _WalletOptions.sparkCoins:
              unawaited(
                Navigator.of(context).pushNamed(
                  SparkCoinsView.routeName,
                  arguments: walletId,
                ),
              );
              break;

            case _WalletOptions.frostOptions:
              unawaited(
                Navigator.of(context).pushNamed(
                  FrostMSWalletOptionsView.routeName,
                  arguments: walletId,
                ),
              );
              break;
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 19,
          horizontal: 32,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.svg.ellipsis,
              width: 20,
              height: 20,
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .buttonTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class WalletOptionsPopupMenu extends ConsumerWidget {
  const WalletOptionsPopupMenu({
    Key? key,
    required this.onDeletePressed,
    required this.onAddressListPressed,
    required this.onShowXpubPressed,
    required this.onChangeRepPressed,
    required this.onFiroShowLelantusCoins,
    required this.onFiroShowSparkCoins,
    required this.onFrostMSWalletOptionsPressed,
    required this.walletId,
  }) : super(key: key);

  final VoidCallback onDeletePressed;
  final VoidCallback onAddressListPressed;
  final VoidCallback onShowXpubPressed;
  final VoidCallback onChangeRepPressed;
  final VoidCallback onFiroShowLelantusCoins;
  final VoidCallback onFiroShowSparkCoins;
  final VoidCallback onFrostMSWalletOptionsPressed;
  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coin = ref.watch(pWalletCoin(walletId));

    final firoDebug =
        kDebugMode && (coin == Coin.firo || coin == Coin.firoTestNet);

    // TODO: [prio=low]
    // final bool xpubEnabled = manager.hasXPub;
    final bool xpubEnabled = false;

    final bool canChangeRep = coin == Coin.nano || coin == Coin.banano;

    final bool isFrost =
        coin == Coin.bitcoinFrost || coin == Coin.bitcoinFrostTestNet;

    return Stack(
      children: [
        Positioned(
          top: 24,
          left: MediaQuery.of(context).size.width - 234,
          child: Container(
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius * 2,
              ),
              color: Theme.of(context).extension<StackColors>()!.popupBG,
              boxShadow: [
                Theme.of(context).extension<StackColors>()!.standardBoxShadow,
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransparentButton(
                    onPressed: onAddressListPressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Assets.svg.list,
                            width: 20,
                            height: 20,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textFieldActiveSearchIconLeft,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _WalletOptions.addressList.prettyName,
                              style: STextStyles.desktopTextExtraExtraSmall(
                                      context)
                                  .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (canChangeRep)
                    const SizedBox(
                      height: 8,
                    ),
                  if (canChangeRep)
                    TransparentButton(
                      onPressed: onChangeRepPressed,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.eye,
                              width: 20,
                              height: 20,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFieldActiveSearchIconLeft,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _WalletOptions.changeRepresentative.prettyName,
                                style: STextStyles.desktopTextExtraExtraSmall(
                                        context)
                                    .copyWith(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (firoDebug)
                    const SizedBox(
                      height: 8,
                    ),
                  if (firoDebug)
                    TransparentButton(
                      onPressed: onFiroShowLelantusCoins,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.eye,
                              width: 20,
                              height: 20,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFieldActiveSearchIconLeft,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _WalletOptions.lelantusCoins.prettyName,
                                style: STextStyles.desktopTextExtraExtraSmall(
                                        context)
                                    .copyWith(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (firoDebug)
                    const SizedBox(
                      height: 8,
                    ),
                  if (firoDebug)
                    TransparentButton(
                      onPressed: onFiroShowSparkCoins,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.eye,
                              width: 20,
                              height: 20,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFieldActiveSearchIconLeft,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _WalletOptions.sparkCoins.prettyName,
                                style: STextStyles.desktopTextExtraExtraSmall(
                                        context)
                                    .copyWith(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (isFrost)
                    const SizedBox(
                      height: 8,
                    ),
                  if (isFrost)
                    TransparentButton(
                      onPressed: onFrostMSWalletOptionsPressed,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.addressBookDesktop,
                              width: 20,
                              height: 20,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFieldActiveSearchIconLeft,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _WalletOptions.frostOptions.prettyName,
                                style: STextStyles.desktopTextExtraExtraSmall(
                                        context)
                                    .copyWith(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (xpubEnabled)
                    const SizedBox(
                      height: 8,
                    ),
                  if (xpubEnabled)
                    TransparentButton(
                      onPressed: onShowXpubPressed,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.eye,
                              width: 20,
                              height: 20,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFieldActiveSearchIconLeft,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _WalletOptions.showXpub.prettyName,
                                style: STextStyles.desktopTextExtraExtraSmall(
                                        context)
                                    .copyWith(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  TransparentButton(
                    onPressed: onDeletePressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Assets.svg.trash,
                            width: 20,
                            height: 20,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textFieldActiveSearchIconLeft,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _WalletOptions.deleteWallet.prettyName,
                              style: STextStyles.desktopTextExtraExtraSmall(
                                      context)
                                  .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TransparentButton extends StatelessWidget {
  const TransparentButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        minHeight: 32,
        minWidth: 32,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Constants.size.circularBorderRadius,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
