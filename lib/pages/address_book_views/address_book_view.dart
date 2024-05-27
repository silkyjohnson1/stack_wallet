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
import '../../app_config.dart';
import '../../models/isar/models/blockchain_data/address.dart';
import '../../models/isar/models/contact_entry.dart';
import 'subviews/add_address_book_entry_view.dart';
import 'subviews/address_book_filter_view.dart';
import '../../providers/db/main_db_provider.dart';
import '../../providers/global/address_book_service_provider.dart';
import '../../providers/providers.dart';
import '../../providers/ui/address_book_providers/address_book_filter_provider.dart';
import '../../themes/stack_colors.dart';
import '../../utilities/assets.dart';
import '../../utilities/constants.dart';
import '../../utilities/text_styles.dart';
import '../../utilities/util.dart';
import '../../wallets/crypto_currency/crypto_currency.dart';
import '../../wallets/wallet/wallet_mixin_interfaces/spark_interface.dart';
import '../../widgets/address_book_card.dart';
import '../../widgets/background.dart';
import '../../widgets/conditional_parent.dart';
import '../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../widgets/icon_widgets/x_icon.dart';
import '../../widgets/rounded_white_container.dart';
import '../../widgets/stack_text_field.dart';
import '../../widgets/textfield_icon_button.dart';

class AddressBookView extends ConsumerStatefulWidget {
  const AddressBookView({
    super.key,
    this.coin,
    this.filterTerm,
  });

  static const String routeName = "/addressBook";

  final CryptoCurrency? coin;
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
      final coins = [...AppConfig.coins];
      coins.removeWhere(
        (e) => e is Firo && e.network == CryptoCurrencyNetwork.test,
      );

      final bool showTestNet =
          ref.read(prefsChangeNotifierProvider).showTestNetCoins;

      if (showTestNet) {
        ref.read(addressBookFilterProvider).addAll(coins, false);
      } else {
        ref.read(addressBookFilterProvider).addAll(
              coins.where((e) => e.network != CryptoCurrencyNetwork.test),
              false,
            );
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
            ..coinName = wallet.info.coin.identifier
            ..address = addressString
            ..label = "Current Receiving"
            ..other = wallet.info.name,
        );
      }
      final self = ContactEntry(
        name: "My ${AppConfig.prefix}",
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
