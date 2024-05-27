/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

import '../../../models/send_view_auto_fill_data.dart';
import '../../../notifications/show_flush_bar.dart';
import '../../../providers/global/active_wallet_provider.dart';
import '../../../providers/global/address_book_service_provider.dart';
import '../../../providers/providers.dart';
import '../../../themes/coin_icon_provider.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/clipboard_interface.dart';
import '../../../utilities/text_styles.dart';
import '../../../utilities/util.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/rounded_container.dart';
import '../../../widgets/rounded_white_container.dart';
import '../../exchange_view/exchange_step_views/step_2_view.dart';
import '../../send_view/send_view.dart';
import 'contact_details_view.dart';

final exchangeFromAddressBookAddressStateProvider =
    StateProvider<String>((ref) => "");

class ContactPopUp extends ConsumerWidget {
  const ContactPopUp({
    super.key,
    required this.contactId,
    this.clipboard = const ClipboardWrapper(),
  });

  final String contactId;
  final ClipboardInterface clipboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final contact = ref.watch(
      addressBookServiceProvider
          .select((value) => value.getContactById(contactId)),
    );

    final active = ref.read(currentWalletIdProvider);

    final bool hasActiveWallet = active != null;
    final bool isExchangeFlow =
        ref.watch(exchangeFlowIsActiveStateProvider.state).state;

    final addresses = contact.addressesSorted.where((e) {
      if (hasActiveWallet && !isExchangeFlow) {
        return e.coin == ref.watch(pWalletCoin(active));
      } else {
        return true;
      }
    }).toList(growable: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LimitedBox(
            maxHeight: maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).extension<StackColors>()!.popupBG,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: LimitedBox(
                      maxHeight: maxHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            // spacing: 10,
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .extension<StackColors>()!
                                            .textFieldDefaultBG,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: contact.customId == "default"
                                          ? const Center(
                                              child: AppIcon(
                                                width: 20,
                                              ),
                                            )
                                          : contact.emojiChar != null
                                              ? Center(
                                                  child:
                                                      Text(contact.emojiChar!),
                                                )
                                              : Center(
                                                  child: SvgPicture.asset(
                                                    Assets.svg.user,
                                                    width: 18,
                                                  ),
                                                ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Text(
                                        contact.name,
                                        style:
                                            STextStyles.itemSubtitle12(context),
                                      ),
                                    ),
                                    if (contact.customId != "default")
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).pushNamed(
                                            ContactDetailsView.routeName,
                                            arguments: contact.customId,
                                          );
                                        },
                                        style: Theme.of(context)
                                            .extension<StackColors>()!
                                            .getSecondaryEnabledButtonStyle(
                                              context,
                                            )!
                                            .copyWith(
                                              minimumSize:
                                                  MaterialStateProperty.all<
                                                      Size>(const Size(46, 32)),
                                            ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                          ),
                                          child: Text(
                                            "Details",
                                            style: STextStyles.buttonSmall(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: contact.customId == "default" ? 16 : 8,
                              ),
                              Container(
                                height: 1,
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .background,
                              ),
                              if (addresses.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: RoundedWhiteContainer(
                                    child: Center(
                                      child: Text(
                                        "No ${ref.watch(pWalletCoin(active!)).prettyName} addresses found",
                                        style:
                                            STextStyles.itemSubtitle(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ...addresses.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 12,
                                    left: 28,
                                    right: 24,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          SvgPicture.file(
                                            File(
                                              ref.watch(
                                                coinIconProvider(e.coin),
                                              ),
                                            ),
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (contact.customId == "default")
                                              Text(
                                                e.other!,
                                                style:
                                                    STextStyles.itemSubtitle12(
                                                  context,
                                                ),
                                              ),
                                            if (contact.customId != "default")
                                              Text(
                                                "${e.label} (${e.coin.ticker})",
                                                style:
                                                    STextStyles.itemSubtitle12(
                                                  context,
                                                ),
                                              ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              e.address,
                                              style: STextStyles.itemSubtitle(
                                                context,
                                              ).copyWith(
                                                fontSize: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              clipboard.setData(
                                                ClipboardData(text: e.address),
                                              );
                                              showFloatingFlushBar(
                                                type: FlushBarType.info,
                                                message: "Copied to clipboard",
                                                iconAsset: Assets.svg.copy,
                                                context: context,
                                              );
                                            },
                                            child: RoundedContainer(
                                              color: Theme.of(context)
                                                  .extension<StackColors>()!
                                                  .textFieldDefaultBG,
                                              padding: const EdgeInsets.all(6),
                                              child: SvgPicture.asset(
                                                Assets.svg.copy,
                                                width: 16,
                                                height: 16,
                                                color: Theme.of(context)
                                                    .extension<StackColors>()!
                                                    .accentColorDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isExchangeFlow)
                                        const SizedBox(
                                          width: 6,
                                        ),
                                      if (isExchangeFlow)
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                ref
                                                    .read(
                                                      exchangeFromAddressBookAddressStateProvider
                                                          .state,
                                                    )
                                                    .state = e.address;
                                                Navigator.of(context).popUntil(
                                                  ModalRoute.withName(
                                                    Step2View.routeName,
                                                  ),
                                                );
                                              },
                                              child: RoundedContainer(
                                                color: Theme.of(context)
                                                    .extension<StackColors>()!
                                                    .textFieldDefaultBG,
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: SvgPicture.asset(
                                                  Assets.svg.chevronRight,
                                                  width: 16,
                                                  height: 16,
                                                  color: Theme.of(context)
                                                      .extension<StackColors>()!
                                                      .accentColorDark,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (contact.customId != "default" &&
                                          hasActiveWallet &&
                                          !isExchangeFlow)
                                        const SizedBox(
                                          width: 4,
                                        ),
                                      if (contact.customId != "default" &&
                                          hasActiveWallet &&
                                          !isExchangeFlow)
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                final String contactLabel =
                                                    "${contact.name} (${e.label})";
                                                final String address =
                                                    e.address;

                                                if (hasActiveWallet) {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    SendView.routeName,
                                                    arguments: Tuple3(
                                                      active,
                                                      ref.read(
                                                        pWalletCoin(active),
                                                      ),
                                                      SendViewAutoFillData(
                                                        address: address,
                                                        contactLabel:
                                                            contactLabel,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: RoundedContainer(
                                                color: Theme.of(context)
                                                    .extension<StackColors>()!
                                                    .textFieldDefaultBG,
                                                padding: EdgeInsets.all(
                                                  Util.isDesktop ? 4 : 6,
                                                ),
                                                child: SvgPicture.asset(
                                                  Assets.svg.circleArrowUpRight,
                                                  width:
                                                      Util.isDesktop ? 12 : 16,
                                                  height:
                                                      Util.isDesktop ? 12 : 16,
                                                  color: Theme.of(context)
                                                      .extension<StackColors>()!
                                                      .accentColorDark,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
