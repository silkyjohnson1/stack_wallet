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
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages/ordinals/widgets/ordinals_list.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/show_loading.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/ordinals_interface.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_app_bar.dart';
import 'package:stackwallet/widgets/desktop/desktop_scaffold.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';

class DesktopOrdinalsView extends ConsumerStatefulWidget {
  const DesktopOrdinalsView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/desktopOrdinalsView";

  final String walletId;

  @override
  ConsumerState<DesktopOrdinalsView> createState() => _DesktopOrdinals();
}

class _DesktopOrdinals extends ConsumerState<DesktopOrdinalsView> {
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;

  String _searchTerm = "";

  @override
  void initState() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    return DesktopScaffold(
      appBar: DesktopAppBar(
        background: Theme.of(context).extension<StackColors>()!.popupBG,
        isCompactHeight: true,
        useSpacers: false,
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
                onPressed: Navigator.of(context).pop,
              ),
              const SizedBox(
                width: 15,
              ),
              SvgPicture.asset(
                Assets.svg.ordinal,
                width: 32,
                height: 32,
                color:
                    Theme.of(context).extension<StackColors>()!.textSubtitle1,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Ordinals",
                style: STextStyles.desktopH3(context),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                // Expanded(
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(
                //       Constants.size.circularBorderRadius,
                //     ),
                //     child: TextField(
                //       autocorrect: Util.isDesktop ? false : true,
                //       enableSuggestions: Util.isDesktop ? false : true,
                //       controller: searchController,
                //       focusNode: searchFocusNode,
                //       onChanged: (value) {
                //         setState(() {
                //           _searchTerm = value;
                //         });
                //       },
                //       style: STextStyles.field(context),
                //       decoration: standardInputDecoration(
                //         "Search",
                //         searchFocusNode,
                //         context,
                //       ).copyWith(
                //         prefixIcon: Padding(
                //           padding: const EdgeInsets.symmetric(
                //             horizontal: 10,
                //             vertical: 20,
                //           ),
                //           child: SvgPicture.asset(
                //             Assets.svg.search,
                //             width: 16,
                //             height: 16,
                //           ),
                //         ),
                //         suffixIcon: searchController.text.isNotEmpty
                //             ? Padding(
                //                 padding: const EdgeInsets.only(right: 0),
                //                 child: UnconstrainedBox(
                //                   child: Row(
                //                     children: [
                //                       TextFieldIconButton(
                //                         child: const XIcon(),
                //                         onTap: () async {
                //                           setState(() {
                //                             searchController.text = "";
                //                             _searchTerm = "";
                //                           });
                //                         },
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               )
                //             : null,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   width: 16,
                // ),
                // SecondaryButton(
                //   width: 184,
                //   label: "Filter",
                //   buttonHeight: ButtonHeight.l,
                //   icon: SvgPicture.asset(
                //     Assets.svg.filter,
                //     color: Theme.of(context)
                //         .extension<StackColors>()!
                //         .buttonTextSecondary,
                //   ),
                //   onPressed: () {
                //     Navigator.of(context).pushNamed(
                //       OrdinalsFilterView.routeName,
                //     );
                //   },
                // ),
                const SizedBox(
                  width: 16,
                ),
                SecondaryButton(
                  width: 184,
                  label: "Update",
                  buttonHeight: ButtonHeight.l,
                  icon: SvgPicture.asset(
                    Assets.svg.arrowRotate,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .buttonTextSecondary,
                  ),
                  onPressed: () async {
                    // show loading for a minimum of 2 seconds on refreshing
                    await showLoading(
                        rootNavigator: true,
                        whileFuture: Future.wait<void>([
                          Future.delayed(const Duration(seconds: 2)),
                          (ref.read(pWallets).getWallet(widget.walletId)
                                  as OrdinalsInterface)
                              .refreshInscriptions()
                        ]),
                        context: context,
                        message: "Refreshing...");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: OrdinalsList(
                  walletId: widget.walletId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
