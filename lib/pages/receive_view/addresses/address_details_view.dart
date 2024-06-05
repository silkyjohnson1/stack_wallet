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
import 'package:isar/isar.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../db/isar/main_db.dart';
import '../../../models/isar/models/blockchain_data/v2/transaction_v2.dart';
import '../../../models/isar/models/isar_models.dart';
import '../../../providers/db/main_db_provider.dart';
import '../../../providers/global/wallets_provider.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/address_utils.dart';
import '../../../utilities/text_styles.dart';
import '../../../utilities/util.dart';
import '../../../wallets/isar/providers/wallet_info_provider.dart';
import '../../../widgets/background.dart';
import '../../../widgets/conditional_parent.dart';
import '../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../widgets/custom_buttons/blue_text_button.dart';
import '../../../widgets/custom_buttons/simple_copy_button.dart';
import '../../../widgets/custom_buttons/simple_edit_button.dart';
import '../../../widgets/desktop/desktop_dialog.dart';
import '../../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../../widgets/rounded_white_container.dart';
import '../../../widgets/transaction_card.dart';
import '../../wallet_view/sub_widgets/no_transactions_found.dart';
import '../../wallet_view/transaction_views/transaction_details_view.dart';
import '../../wallet_view/transaction_views/tx_v2/transaction_v2_card.dart';
import 'address_tag.dart';

class AddressDetailsView extends ConsumerStatefulWidget {
  const AddressDetailsView({
    super.key,
    required this.addressId,
    required this.walletId,
  });

  static const String routeName = "/addressDetailsView";

  final Id addressId;
  final String walletId;

  @override
  ConsumerState<AddressDetailsView> createState() => _AddressDetailsViewState();
}

class _AddressDetailsViewState extends ConsumerState<AddressDetailsView> {
  final _qrKey = GlobalKey();
  final isDesktop = Util.isDesktop;

  late Stream<AddressLabel?> stream;
  late final Address address;

  AddressLabel? label;

  void _showDesktopAddressQrCode() {
    showDialog<void>(
      context: context,
      builder: (context) => DesktopDialog(
        maxWidth: 480,
        maxHeight: 400,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Address QR code",
                    style: STextStyles.desktopH3(context),
                  ),
                ),
                const DesktopDialogCloseButton(),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: RepaintBoundary(
                      key: _qrKey,
                      child: QrImageView(
                        data: AddressUtils.buildUriString(
                          ref.watch(pWalletCoin(widget.walletId)),
                          address.value,
                          {},
                        ),
                        size: 220,
                        backgroundColor:
                            Theme.of(context).extension<StackColors>()!.popupBG,
                        foregroundColor: Theme.of(context)
                            .extension<StackColors>()!
                            .accentColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    address = MainDB.instance.isar.addresses
        .where()
        .idEqualTo(widget.addressId)
        .findFirstSync()!;

    label = MainDB.instance.getAddressLabelSync(widget.walletId, address.value);
    Id? id = label?.id;
    if (id == null) {
      label = AddressLabel(
        walletId: widget.walletId,
        addressString: address.value,
        value: "",
        tags: address.subType == AddressSubType.receiving
            ? ["receiving"]
            : address.subType == AddressSubType.change
                ? ["change"]
                : null,
      );
      id = MainDB.instance.putAddressLabelSync(label!);
    }
    stream = MainDB.instance.watchAddressLabel(id: id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coin = ref.watch(pWalletCoin(widget.walletId));
    return ConditionalParent(
      condition: !isDesktop,
      builder: (child) => Background(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.backgroundAppBar,
            leading: AppBarBackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            titleSpacing: 0,
            title: Text(
              "Address details",
              style: STextStyles.navBarTitle(context),
            ),
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (builderContext, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      child: StreamBuilder<AddressLabel?>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            label = snapshot.data!;
          }

          return ConditionalParent(
            condition: isDesktop,
            builder: (child) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedWhiteContainer(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Address details",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                context,
                              ).copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textSubtitle1,
                              ),
                            ),
                            CustomTextButton(
                              text: "View QR code",
                              onTap: _showDesktopAddressQrCode,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        RoundedWhiteContainer(
                          padding: EdgeInsets.zero,
                          borderColor: Theme.of(context)
                              .extension<StackColors>()!
                              .backgroundAppBar,
                          child: child,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Transaction history",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                context,
                              ).copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textSubtitle1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RoundedWhiteContainer(
                          padding: EdgeInsets.zero,
                          borderColor: Theme.of(context)
                              .extension<StackColors>()!
                              .backgroundAppBar,
                          child: ref
                                      .watch(pWallets)
                                      .getWallet(widget.walletId)
                                      .isarTransactionVersion ==
                                  2
                              ? _AddressDetailsTxV2List(
                                  walletId: widget.walletId,
                                  address: address,
                                )
                              : _AddressDetailsTxList(
                                  walletId: widget.walletId,
                                  address: address,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isDesktop)
                  Center(
                    child: RepaintBoundary(
                      key: _qrKey,
                      child: QrImageView(
                        data: AddressUtils.buildUriString(
                          coin,
                          address.value,
                          {},
                        ),
                        size: 220,
                        backgroundColor: Theme.of(context)
                            .extension<StackColors>()!
                            .background,
                        foregroundColor: Theme.of(context)
                            .extension<StackColors>()!
                            .accentColorDark,
                      ),
                    ),
                  ),
                if (!isDesktop)
                  const SizedBox(
                    height: 16,
                  ),
                _Item(
                  title: "Address",
                  data: address.value,
                  button: isDesktop
                      ? IconCopyButton(
                          data: address.value,
                        )
                      : SimpleCopyButton(
                          data: address.value,
                        ),
                ),
                const _Div(
                  height: 12,
                ),
                _Item(
                  title: "Label",
                  data: label!.value,
                  button: SimpleEditButton(
                    editValue: label!.value,
                    editLabel: 'label',
                    onValueChanged: (value) {
                      MainDB.instance.putAddressLabel(
                        label!.copyWith(
                          label: value,
                        ),
                      );
                    },
                  ),
                ),
                const _Div(
                  height: 12,
                ),
                _Tags(
                  tags: label!.tags,
                ),
                if (address.derivationPath != null)
                  const _Div(
                    height: 12,
                  ),
                if (address.derivationPath != null)
                  _Item(
                    title: "Derivation path",
                    data: address.derivationPath!.value,
                    button: Container(),
                  ),
                if (address.type == AddressType.spark)
                  const _Div(
                    height: 12,
                  ),
                if (address.type == AddressType.spark)
                  _Item(
                    title: "Diversifier",
                    data: address.derivationIndex.toString(),
                    button: Container(),
                  ),
                const _Div(
                  height: 12,
                ),
                _Item(
                  title: "Type",
                  data: address.type.readableName,
                  button: Container(),
                ),
                const _Div(
                  height: 12,
                ),
                _Item(
                  title: "Sub type",
                  data: address.subType.prettyName,
                  button: Container(),
                ),
                if (!isDesktop)
                  const SizedBox(
                    height: 20,
                  ),
                if (!isDesktop)
                  Text(
                    "Transactions",
                    textAlign: TextAlign.left,
                    style: STextStyles.itemSubtitle(context).copyWith(
                      color:
                          Theme.of(context).extension<StackColors>()!.textDark3,
                    ),
                  ),
                if (!isDesktop)
                  const SizedBox(
                    height: 12,
                  ),
                if (!isDesktop)
                  ref
                              .watch(pWallets)
                              .getWallet(widget.walletId)
                              .isarTransactionVersion ==
                          2
                      ? _AddressDetailsTxV2List(
                          walletId: widget.walletId,
                          address: address,
                        )
                      : _AddressDetailsTxList(
                          walletId: widget.walletId,
                          address: address,
                        ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddressDetailsTxList extends StatelessWidget {
  const _AddressDetailsTxList({
    super.key,
    required this.walletId,
    required this.address,
  });

  final String walletId;
  final Address address;

  @override
  Widget build(BuildContext context) {
    final query = MainDB.instance
        .getTransactions(walletId)
        .filter()
        .address((q) => q.valueEqualTo(address.value));

    final count = query.countSync();

    if (count > 0) {
      if (Util.isDesktop) {
        final txns = query.findAllSync();
        return ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (_, index) => TransactionCard(
            transaction: txns[index],
            walletId: walletId,
          ),
          separatorBuilder: (_, __) => const _Div(height: 1),
          itemCount: count,
        );
      } else {
        return RoundedWhiteContainer(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: query
                .findAllSync()
                .map(
                  (e) => TransactionCard(
                    transaction: e,
                    walletId: walletId,
                  ),
                )
                .toList(),
          ),
        );
      }
    } else {
      return const NoTransActionsFound();
    }
  }
}

class _AddressDetailsTxV2List extends ConsumerWidget {
  const _AddressDetailsTxV2List({
    super.key,
    required this.walletId,
    required this.address,
  });

  final String walletId;
  final Address address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletTxFilter =
        ref.watch(pWallets).getWallet(walletId).transactionFilterOperation;

    final query =
        ref.watch(mainDBProvider).isar.transactionV2s.buildQuery<TransactionV2>(
              whereClauses: [
                IndexWhereClause.equalTo(
                  indexName: 'walletId',
                  value: [walletId],
                ),
              ],
              filter: FilterGroup.and([
                if (walletTxFilter != null) walletTxFilter,
                FilterGroup.or([
                  ObjectFilter(
                    property: 'inputs',
                    filter: FilterCondition.contains(
                      property: "addresses",
                      value: address.value,
                    ),
                  ),
                  ObjectFilter(
                    property: 'outputs',
                    filter: FilterCondition.contains(
                      property: "addresses",
                      value: address.value,
                    ),
                  ),
                ]),
              ]),
              sortBy: [
                const SortProperty(
                  property: "timestamp",
                  sort: Sort.desc,
                ),
              ],
            );

    final count = query.countSync();

    if (count > 0) {
      if (Util.isDesktop) {
        final txns = query.findAllSync();
        return ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (_, index) => TransactionCardV2(
            transaction: txns[index],
          ),
          separatorBuilder: (_, __) => const _Div(height: 1),
          itemCount: count,
        );
      } else {
        return RoundedWhiteContainer(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: query
                .findAllSync()
                .map(
                  (e) => TransactionCardV2(
                    transaction: e,
                  ),
                )
                .toList(),
          ),
        );
      }
    } else {
      return const NoTransActionsFound();
    }
  }
}

class _Div extends StatelessWidget {
  const _Div({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    if (Util.isDesktop) {
      return Container(
        color: Theme.of(context).extension<StackColors>()!.backgroundAppBar,
        height: 1,
        width: double.infinity,
      );
    } else {
      return SizedBox(
        height: height,
      );
    }
  }
}

class _Tags extends StatelessWidget {
  const _Tags({
    super.key,
    required this.tags,
  });

  final List<String>? tags;

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tags",
                style: STextStyles.itemSubtitle(context),
              ),
              Container(),
              // SimpleEditButton(
              //   onPressedOverride: () {
              //     // TODO edit tags
              //   },
              // ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          tags != null && tags!.isNotEmpty
              ? Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: tags!
                      .map(
                        (e) => AddressTag(
                          tag: e,
                        ),
                      )
                      .toList(),
                )
              : Text(
                  "Tags will appear here",
                  style: STextStyles.w500_14(context).copyWith(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textSubtitle3,
                  ),
                ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.title,
    required this.data,
    required this.button,
  });

  final String title;
  final String data;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return ConditionalParent(
      condition: !Util.isDesktop,
      builder: (child) => RoundedWhiteContainer(
        child: child,
      ),
      child: ConditionalParent(
        condition: Util.isDesktop,
        builder: (child) => Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: STextStyles.itemSubtitle(context),
                ),
                button,
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            data.isNotEmpty
                ? SelectableText(
                    data,
                    style: STextStyles.w500_14(context),
                  )
                : Text(
                    "$title will appear here",
                    style: STextStyles.w500_14(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textSubtitle3,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
