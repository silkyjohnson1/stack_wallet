/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/text_styles.dart';
import '../../../wallets/isar/providers/favourite_wallets_provider.dart';
import '../../../widgets/custom_page_view/custom_page_view.dart' as cpv;
import '../../manage_favorites_view/manage_favorites_view.dart';
import 'favorite_card.dart';

class FavoriteWallets extends ConsumerStatefulWidget {
  const FavoriteWallets({super.key});

  @override
  ConsumerState<FavoriteWallets> createState() => _FavoriteWalletsState();
}

class _FavoriteWalletsState extends ConsumerState<FavoriteWallets> {
  int _focusedIndex = 0;

  static const cardWidth = 220.0;
  static const cardHeight = 125.0;

  late final cpv.PageController _pageController;
  late final double screenWidth;
  late final double viewportFraction;

  int _favLength = 0;

  static const standardPadding = 16.0;

  @override
  void initState() {
    screenWidth = (window.physicalSize.shortestSide / window.devicePixelRatio);
    viewportFraction = cardWidth / screenWidth;

    _pageController = cpv.PageController(
      viewportFraction: viewportFraction,
    );

    _pageController.addListener(() {
      if (_pageController.position.pixels > (cardWidth * (_favLength - 1))) {
        _pageController.animateToPage(
          _favLength - 1,
          duration: const Duration(milliseconds: 1),
          curve: Curves.decelerate,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final favorites = ref.watch(pFavouriteWalletInfos(true));
    _favLength = favorites.length;

    final bool hasFavorites = favorites.isNotEmpty;

    final remaining = ((screenWidth - cardWidth) / cardWidth).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: standardPadding,
          ),
          child: Row(
            children: [
              Text(
                "Favorite Wallets",
                style: STextStyles.itemSubtitle(context).copyWith(
                  color: Theme.of(context).extension<StackColors>()!.textDark3,
                ),
              ),
              const Spacer(),
              if (hasFavorites)
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).extension<StackColors>()!.background,
                    ),
                  ),
                  child: SvgPicture.asset(
                    Assets.svg.ellipsis,
                    width: 16,
                    height: 16,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .accentColorDark,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      ManageFavoritesView.routeName,
                    );
                  },
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        !hasFavorites
            ? Padding(
                padding: const EdgeInsets.only(
                  left: standardPadding,
                ),
                child: Container(
                  height: cardHeight,
                  width: cardWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textFieldDefaultBG,
                    borderRadius: BorderRadius.circular(
                      Constants.size.circularBorderRadius,
                    ),
                  ),
                  child: MaterialButton(
                    splashColor:
                        Theme.of(context).extension<StackColors>()!.highlight,
                    key: const Key("favoriteWalletsAddFavoriteButtonKey"),
                    padding: const EdgeInsets.all(12),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Constants.size.circularBorderRadius,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ManageFavoritesView.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.svg.plus,
                          width: 8,
                          height: 8,
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textSubtitle1,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Add a favorite",
                          style: STextStyles.itemSubtitle(context).copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: cardHeight,
                width: screenWidth,
                child: cpv.CustomPageView.builder(
                  padEnds: false,
                  pageSnapping: true,
                  itemCount: favorites.length + remaining,
                  controller: _pageController,
                  viewportFractionalPadding:
                      standardPadding / MediaQuery.of(context).size.width,
                  onPageChanged: (int index) => setState(() {
                    _focusedIndex = index;
                  }),
                  itemBuilder: (_, index) {
                    String? walletId;

                    if (index < favorites.length) {
                      walletId = favorites[index].walletId;
                    }

                    const double scaleDown = 0.95;
                    const int milliseconds = 333;

                    return AnimatedScale(
                      scale: index == _focusedIndex ? 1.0 : scaleDown,
                      duration: const Duration(milliseconds: milliseconds),
                      curve: Curves.decelerate,
                      child: AnimatedOpacity(
                        opacity: index == _focusedIndex ? 1 : 0.45,
                        duration: const Duration(milliseconds: milliseconds),
                        curve: Curves.decelerate,
                        child: index < favorites.length
                            ? index == _focusedIndex
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: FavoriteCard(
                                      key: Key("favCard_$walletId"),
                                      walletId: walletId!,
                                      width: cardWidth,
                                      height: cardHeight,
                                    ),
                                  )
                                : FavoriteCard(
                                    key: Key("favCard_$walletId"),
                                    walletId: walletId!,
                                    width: cardWidth,
                                    height: cardHeight,
                                  )
                            : Container(),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
