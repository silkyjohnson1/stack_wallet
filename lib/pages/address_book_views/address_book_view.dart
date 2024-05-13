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
import 'package:stackwallet/models/isar/models/blockchain_data/address.dart';
import 'package:stackwallet/models/isar/models/contact_entry.dart';
import 'package:stackwallet/pages/address_book_views/subviews/add_address_book_entry_view.dart';
import 'package:stackwallet/pages/address_book_views/subviews/address_book_filter_view.dart';
import 'package:stackwallet/providers/db/main_db_provider.dart';
import 'package:stackwallet/providers/global/address_book_service_provider.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/providers/ui/address_book_providers/address_book_filter_provider.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/spark_interface.dart';
import 'package:stackwallet/whiteLabel.dart';
import 'package:stackwallet/widgets/address_book_card.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/icon_widgets/x_icon.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';
import 'package:stackwallet/widgets/textfield_icon_button.dart';

class AddressBookView extends ConsumerStatefulWidget {
  const AddressBookView({
    super.key,
    this.coin,
    this.filterTerm,
  });

  static const String routeName = "/addressBook";

  final Coin? coin;
  final String? filterTerm;

  @override
  ConsumerState<AddressBookView> createState() => _AddressBookViewState();
}

class _AddressBookViewState extends ConsumerState<AddressBookView> {
  late TextEditingController _searchController;

  final _searchFocusNode = FocusNode();

  String _searchTerm = "";

  @override
  void initState() {
    _searchController = TextEditingController();
    ref.refresh(addressBookFilterProvider);

    if (widget.coin == null) {
      final List<Coin> coins = Coin.values.toList();
      coins.remove(Coin.firoTestNet);

      final bool showTestNet =
          ref.read(prefsChangeNotifierProvider).showTestNetCoins;

      if (showTestNet) {
        ref.read(addressBookFilterProvider).addAll(coins, false);
      } else {
        ref
            .read(addressBookFilterProvider)
            .addAll(coins.where((e) => !e.isTestNet), false);
      }
    } else {
      ref.read(addressBookFilterProvider).add(widget.coin!, false);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final List<ContactAddressEntry> addresses = [];
      final wallets = ref.read(pWallets).wallets;
      for (final wallet in wallets) {
        final String addressString;
        if (wallet is SparkInterface) {
          Address? address = await wallet.getCurrentReceivingSparkAddress();
          if (address == null) {
            address = await wallet.generateNextSparkAddress();
            await ref.read(mainDBProvider).updateOrPutAddresses([address]);
          }
          addressString = address.value;
        } else {
          final address = await wallet.getCurrentReceivingAddress();
          addressString = address?.value ?? wallet.info.cachedReceivingAddress;
        }

        addresses.add(
          ContactAddressEntry()
            ..coinName = wallet.info.coin.name
            ..address = addressString
            ..label = "Current Receiving"
            ..other = wallet.info.name,
        );
      }
      final self = ContactEntry(
        name: "My ${WhiteLabel.prefix}",
        addresses: addresses,
        isFavorite: true,
        customId: "default",
      );
      await ref.read(addressBookServiceProvider).editContact(self);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    final contacts =
        ref.watch(addressBookServiceProvider.select((value) => value.contacts));

    final isDesktop = Util.isDesktop;
    return ConditionalParent(
      condition: !isDesktop,
      builder: (child) {
        return Background(
          child: Scaffold(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.background,
            appBar: AppBar(
              leading: AppBarBackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Address book",
                style: STextStyles.navBarTitle(context),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 10,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AppBarIconButton(
                      key: const Key("addressBookFilterViewButton"),
                      size: 36,
                      shadows: const [],
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .background,
                      icon: SvgPicture.asset(
                        Assets.svg.filter,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .accentColorDark,
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AddressBookFilterView.routeName,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 10,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AppBarIconButton(
                      key: const Key("addressBookAddNewContactViewButton"),
                      size: 36,
                      shadows: const [],
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .background,
                      icon: SvgPicture.asset(
                        Assets.svg.plus,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .accentColorDark,
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AddAddressBookEntryView.routeName,
                        );
                      },
                    ),
                  ),
                ),
              ],
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 271,
                            ),
                            child: child,
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
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
            child: !isDesktop
                ? TextField(
                    autocorrect: Util.isDesktop ? false : true,
                    enableSuggestions: Util.isDesktop ? false : true,
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) {
                      setState(() {
                        _searchTerm = value;
                      });
                    },
                    style: STextStyles.field(context),
                    decoration: standardInputDecoration(
                      "Search",
                      _searchFocusNode,
                      context,
                    ).copyWith(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 16,
                        ),
                        child: SvgPicture.asset(
                          Assets.svg.search,
                          width: 16,
                          height: 16,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: UnconstrainedBox(
                                child: Row(
                                  children: [
                                    TextFieldIconButton(
                                      child: const XIcon(),
                                      onTap: () async {
                                        setState(() {
                                          _searchController.text = "";
                                          _searchTerm = "";
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : null,
                    ),
                  )
                : null,
          ),
          if (!isDesktop) const SizedBox(height: 16),
          Text(
            "Favorites",
            style: STextStyles.smallMed12(context),
          ),
          const SizedBox(
            height: 12,
          ),
          if (contacts.isNotEmpty)
            RoundedWhiteContainer(
              padding: EdgeInsets.all(!isDesktop ? 0 : 15),
              child: Column(
                children: [
                  ...contacts
                      .where(
                        (element) => element.addressesSorted
                            .where(
                              (e) => ref.watch(
                                addressBookFilterProvider.select(
                                  (value) => value.coins.contains(e.coin),
                                ),
                              ),
                            )
                            .isNotEmpty,
                      )
                      .where(
                        (e) =>
                            e.isFavorite &&
                            ref
                                .read(addressBookServiceProvider)
                                .matches(widget.filterTerm ?? _searchTerm, e),
                      )
                      .where((element) => element.isFavorite)
                      .map(
                        (e) => AddressBookCard(
                          key: Key("favContactCard_${e.customId}_key"),
                          contactId: e.customId,
                        ),
                      ),
                ],
              ),
            ),
          if (contacts.isEmpty)
            RoundedWhiteContainer(
              child: Center(
                child: Text(
                  "Your favorite contacts will appear here",
                  style: STextStyles.itemSubtitle(context),
                ),
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "All contacts",
            style: STextStyles.smallMed12(context),
          ),
          const SizedBox(
            height: 12,
          ),
          if (contacts.isNotEmpty)
            Column(
              children: [
                RoundedWhiteContainer(
                  padding: EdgeInsets.all(!isDesktop ? 0 : 15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ...contacts
                            .where(
                              (element) => element.addressesSorted
                                  .where(
                                    (e) => ref.watch(
                                      addressBookFilterProvider.select(
                                        (value) => value.coins.contains(e.coin),
                                      ),
                                    ),
                                  )
                                  .isNotEmpty,
                            )
                            .where(
                              (e) => ref
                                  .read(addressBookServiceProvider)
                                  .matches(widget.filterTerm ?? _searchTerm, e),
                            )
                            .map(
                              (e) => AddressBookCard(
                                key:
                                    Key("desktopContactCard_${e.customId}_key"),
                                contactId: e.customId,
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (contacts.isEmpty)
            RoundedWhiteContainer(
              child: Center(
                child: Text(
                  "Your contacts will appear here",
                  style: STextStyles.itemSubtitle(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
