/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/db/main_db_provider.dart';
import '../../themes/stack_colors.dart';
import '../../utilities/constants.dart';
import '../../utilities/text_styles.dart';
import '../../utilities/util.dart';
import '../../wallets/isar/providers/favourite_wallets_provider.dart';
import '../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../widgets/desktop/desktop_app_bar.dart';
import '../../widgets/desktop/desktop_scaffold.dart';
import '../../widgets/managed_favorite.dart';

class ManageFavoritesView extends StatelessWidget {
  const ManageFavoritesView({Key? key}) : super(key: key);

  static const routeName = "/manageFavorites";

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final isDesktop = Util.isDesktop;

    return MasterScaffold(
      isDesktop: isDesktop,
      appBar: isDesktop
          ? DesktopAppBar(
              background: Theme.of(context).extension<StackColors>()!.popupBG,
              isCompactHeight: true,
              leading: const AppBarBackButton(
                isCompact: true,
              ),
              center: Expanded(
                child: Text(
                  "Favorite wallets",
                  style: STextStyles.desktopH3(context),
                ),
              ),
            )
          : AppBar(
              title: Text(
                "Favorite wallets",
                style: STextStyles.navBarTitle(context),
              ),
              leading: AppBarBackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
      body: isDesktop
          ? Consumer(
              builder: (_, ref, __) {
                final favorites = ref.watch(pFavouriteWalletInfos(true));
                final nonFavorites = ref.watch(pFavouriteWalletInfos(false));

                return Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .popupBG,
                                borderRadius: BorderRadius.circular(
                                  Constants.size.circularBorderRadius,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Drag to change wallet order.",
                                  style:
                                      STextStyles.desktopTextExtraSmall(context)
                                          .copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textSubtitle1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ReorderableListView.builder(
                            buildDefaultDragHandles: false,
                            shrinkWrap: true,
                            primary: false,
                            key: key,
                            itemCount: favorites.length,
                            itemBuilder: (builderContext, index) {
                              final walletId = favorites[index].walletId;
                              return Padding(
                                key: Key(
                                  "manageFavoriteWalletsItem_$walletId",
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 24,
                                ),
                                child: ReorderableDelayedDragStartListener(
                                  index: index,
                                  child: ManagedFavorite(
                                    walletId: walletId,
                                  ),
                                ),
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              final isar = ref.read(mainDBProvider).isar;

                              final actualIndex =
                                  favorites[oldIndex].favouriteOrderIndex;
                              if (oldIndex > newIndex) {
                                for (int i = oldIndex - 1; i >= newIndex; i--) {
                                  final next = favorites[i];
                                  next.updateIsFavourite(
                                    true,
                                    isar: isar,
                                    customIndexOverride:
                                        next.favouriteOrderIndex + 1,
                                  );
                                }
                                favorites[oldIndex].updateIsFavourite(
                                  true,
                                  isar: isar,
                                  customIndexOverride:
                                      actualIndex - (oldIndex - newIndex),
                                );
                              } else {
                                for (int i = oldIndex + 1; i < newIndex; i++) {
                                  final next = favorites[i];
                                  next.updateIsFavourite(
                                    true,
                                    isar: isar,
                                    customIndexOverride:
                                        next.favouriteOrderIndex - 1,
                                  );
                                }
                                favorites[oldIndex].updateIsFavourite(
                                  true,
                                  isar: isar,
                                  customIndexOverride:
                                      actualIndex + (newIndex - oldIndex),
                                );
                              }
                            },
                            proxyDecorator: (child, index, animation) {
                              return Material(
                                elevation: 15,
                                color: Colors.transparent,
                                // shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      Constants.size.circularBorderRadius * 1.5,
                                    ),
                                  ),
                                ),
                                child: child,
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 32,
                              bottom: 11,
                              left: 24,
                              right: 24,
                            ),
                            child: Text(
                              "Add to favorites",
                              style:
                                  STextStyles.itemSubtitle12(context).copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark3,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: nonFavorites.length,
                            itemBuilder: (buildContext, index) {
                              // final walletId = ref.watch(
                              //     nonFavorites[index].select((value) => value.walletId));
                              final walletId = nonFavorites[index].walletId;
                              return Padding(
                                key: Key(
                                  "manageNonFavoriteWalletsItem_$walletId",
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 5,
                                ),
                                child: ManagedFavorite(
                                  walletId: walletId,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          : Container(
              color: Theme.of(context).extension<StackColors>()!.background,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .popupBG,
                          borderRadius: BorderRadius.circular(
                            Constants.size.circularBorderRadius,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Drag to change wallet order.",
                            style: STextStyles.label(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Consumer(
                        builder: (_, ref, __) {
                          final favorites =
                              ref.watch(pFavouriteWalletInfos(true));
                          return ReorderableListView.builder(
                            key: key,
                            itemCount: favorites.length,
                            itemBuilder: (builderContext, index) {
                              final walletId = favorites[index].walletId;
                              return Padding(
                                key: Key(
                                  "manageFavoriteWalletsItem_$walletId",
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: ManagedFavorite(
                                  walletId: walletId,
                                ),
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              final isar = ref.read(mainDBProvider).isar;

                              final actualIndex =
                                  favorites[oldIndex].favouriteOrderIndex;
                              if (oldIndex > newIndex) {
                                for (int i = oldIndex - 1; i >= newIndex; i--) {
                                  final next = favorites[i];
                                  next.updateIsFavourite(
                                    true,
                                    isar: isar,
                                    customIndexOverride:
                                        next.favouriteOrderIndex + 1,
                                  );
                                }
                                favorites[oldIndex].updateIsFavourite(
                                  true,
                                  isar: isar,
                                  customIndexOverride:
                                      actualIndex - (oldIndex - newIndex),
                                );
                              } else {
                                for (int i = oldIndex + 1; i < newIndex; i++) {
                                  final next = favorites[i];
                                  next.updateIsFavourite(
                                    true,
                                    isar: isar,
                                    customIndexOverride:
                                        next.favouriteOrderIndex - 1,
                                  );
                                }
                                favorites[oldIndex].updateIsFavourite(
                                  true,
                                  isar: isar,
                                  customIndexOverride:
                                      actualIndex + (newIndex - oldIndex),
                                );
                              }
                            },
                            proxyDecorator: (child, index, animation) {
                              return Material(
                                elevation: 15,
                                color: Colors.transparent,
                                // shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      Constants.size.circularBorderRadius * 1.5,
                                    ),
                                  ),
                                ),
                                child: child,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        bottom: 12,
                        left: 4,
                        right: 4,
                      ),
                      child: Text(
                        "Add to favorites",
                        style: STextStyles.itemSubtitle12(context).copyWith(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textDark3,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer(
                        builder: (_, ref, __) {
                          final nonFavorites =
                              ref.watch(pFavouriteWalletInfos(false));

                          return ListView.builder(
                            itemCount: nonFavorites.length,
                            itemBuilder: (buildContext, index) {
                              // final walletId = ref.watch(
                              //     nonFavorites[index].select((value) => value.walletId));
                              final walletId = nonFavorites[index].walletId;
                              return Padding(
                                key: Key(
                                  "manageNonFavoriteWalletsItem_$walletId",
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: ManagedFavorite(
                                  walletId: walletId,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
