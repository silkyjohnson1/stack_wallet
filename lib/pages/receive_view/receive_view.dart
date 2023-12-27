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

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackwallet/models/isar/models/isar_models.dart';
import 'package:stackwallet/notifications/show_flush_bar.dart';
import 'package:stackwallet/pages/receive_view/addresses/wallet_addresses_view.dart';
import 'package:stackwallet/pages/receive_view/generate_receiving_uri_qr_code_view.dart';
import 'package:stackwallet/providers/db/main_db_provider.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/route_generator.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/address_utils.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/clipboard_interface.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/wallets/isar/providers/wallet_info_provider.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/multi_address_interface.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/spark_interface.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackwallet/widgets/custom_loading_overlay.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class ReceiveView extends ConsumerStatefulWidget {
  const ReceiveView({
    Key? key,
    required this.walletId,
    this.tokenContract,
    this.clipboard = const ClipboardWrapper(),
  }) : super(key: key);

  static const String routeName = "/receiveView";

  final String walletId;
  final EthContract? tokenContract;
  final ClipboardInterface clipboard;

  @override
  ConsumerState<ReceiveView> createState() => _ReceiveViewState();
}

class _ReceiveViewState extends ConsumerState<ReceiveView> {
  late final Coin coin;
  late final String walletId;
  late final ClipboardInterface clipboard;
  late final bool supportsSpark;

  String? _sparkAddress;
  String? _qrcodeContent;
  bool _showSparkAddress = true;

  Future<void> generateNewAddress() async {
    final wallet = ref.read(pWallets).getWallet(walletId);

    if (wallet is MultiAddressInterface) {
      bool shouldPop = false;
      unawaited(
        showDialog(
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () async => shouldPop,
              child: Container(
                color: Theme.of(context)
                    .extension<StackColors>()!
                    .overlay
                    .withOpacity(0.5),
                child: const CustomLoadingOverlay(
                  message: "Generating address",
                  eventBus: null,
                ),
              ),
            );
          },
        ),
      );

      await wallet.generateNewReceivingAddress();

      shouldPop = true;

      if (mounted) {
        Navigator.of(context)
            .popUntil(ModalRoute.withName(ReceiveView.routeName));
      }
    }
  }

  Future<void> generateNewSparkAddress() async {
    final wallet = ref.read(pWallets).getWallet(walletId);
    if (wallet is SparkInterface) {
      bool shouldPop = false;
      unawaited(
        showDialog(
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () async => shouldPop,
              child: Container(
                color: Theme.of(context)
                    .extension<StackColors>()!
                    .overlay
                    .withOpacity(0.5),
                child: const CustomLoadingOverlay(
                  message: "Generating address",
                  eventBus: null,
                ),
              ),
            );
          },
        ),
      );

      final address = await wallet.generateNextSparkAddress();
      await ref.read(mainDBProvider).isar.writeTxn(() async {
        await ref.read(mainDBProvider).isar.addresses.put(address);
      });

      shouldPop = true;

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        if (_sparkAddress != address.value) {
          setState(() {
            _sparkAddress = address.value;
          });
        }
      }
    }
  }

  StreamSubscription<Address?>? _streamSub;

  @override
  void initState() {
    walletId = widget.walletId;
    coin = ref.read(pWalletCoin(walletId));
    clipboard = widget.clipboard;
    supportsSpark = ref.read(pWallets).getWallet(walletId) is SparkInterface;

    if (supportsSpark) {
      _streamSub = ref
          .read(mainDBProvider)
          .isar
          .addresses
          .where()
          .walletIdEqualTo(walletId)
          .filter()
          .typeEqualTo(AddressType.spark)
          .sortByDerivationIndexDesc()
          .findFirst()
          .asStream()
          .listen((event) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _sparkAddress = event?.value;
            });
          }
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final ticker = widget.tokenContract?.symbol ?? coin.ticker;

    if (supportsSpark) {
      if (_showSparkAddress) {
        _qrcodeContent = _sparkAddress;
      } else {
        _qrcodeContent = ref.watch(pWalletReceivingAddress(walletId));
      }
    } else {
      _qrcodeContent = ref.watch(pWalletReceivingAddress(walletId));
    }

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
            "Receive $ticker",
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
                  semanticsLabel:
                      "Address List Pop-up Button. Opens A Pop-up For Address List Button.",
                  key: const Key("walletNetworkSettingsAddNewNodeViewButton"),
                  size: 36,
                  shadows: const [],
                  color: Theme.of(context).extension<StackColors>()!.background,
                  icon: SvgPicture.asset(
                    Assets.svg.verticalEllipsis,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .accentColorDark,
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {
                    showDialog<dynamic>(
                      barrierColor: Colors.transparent,
                      barrierDismissible: true,
                      context: context,
                      builder: (_) {
                        return Stack(
                          children: [
                            Positioned(
                              top: 9,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .popupBG,
                                  borderRadius: BorderRadius.circular(
                                    Constants.size.circularBorderRadius,
                                  ),
                                  // boxShadow: [CFColors.standardBoxShadow],
                                  boxShadow: const [],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushNamed(
                                          WalletAddressesView.routeName,
                                          arguments: walletId,
                                        );
                                      },
                                      child: RoundedWhiteContainer(
                                        boxShadow: [
                                          Theme.of(context)
                                              .extension<StackColors>()!
                                              .standardBoxShadow,
                                        ],
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              "Address list",
                                              style: STextStyles.field(context),
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
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConditionalParent(
                    condition: supportsSpark,
                    builder: (child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<bool>(
                            value: _showSparkAddress,
                            items: [
                              DropdownMenuItem(
                                value: true,
                                child: Text(
                                  "Spark address",
                                  style: STextStyles.desktopTextMedium(context),
                                ),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text(
                                  "Transparent address",
                                  style: STextStyles.desktopTextMedium(context),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value is bool && value != _showSparkAddress) {
                                setState(() {
                                  _showSparkAddress = value;
                                });
                              }
                            },
                            isExpanded: true,
                            iconStyleData: IconStyleData(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  Assets.svg.chevronDown,
                                  width: 12,
                                  height: 6,
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textFieldActiveSearchIconRight,
                                ),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              offset: const Offset(0, -10),
                              elevation: 0,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textFieldDefaultBG,
                                borderRadius: BorderRadius.circular(
                                  Constants.size.circularBorderRadius,
                                ),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_showSparkAddress)
                          GestureDetector(
                            onTap: () {
                              clipboard.setData(
                                ClipboardData(text: _sparkAddress ?? "Error"),
                              );
                              showFloatingFlushBar(
                                type: FlushBarType.info,
                                message: "Copied to clipboard",
                                iconAsset: Assets.svg.copy,
                                context: context,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .backgroundAppBar,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Constants.size.circularBorderRadius,
                                ),
                              ),
                              child: RoundedWhiteContainer(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Your ${coin.ticker} SPARK address",
                                          style:
                                              STextStyles.itemSubtitle(context),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.svg.copy,
                                              width: 15,
                                              height: 15,
                                              color: Theme.of(context)
                                                  .extension<StackColors>()!
                                                  .infoItemIcons,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Copy",
                                              style: STextStyles.link2(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _sparkAddress ?? "Error",
                                            style: STextStyles
                                                    .desktopTextExtraExtraSmall(
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (!_showSparkAddress) child,
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        clipboard.setData(
                          ClipboardData(
                              text:
                                  ref.watch(pWalletReceivingAddress(walletId))),
                        );
                        showFloatingFlushBar(
                          type: FlushBarType.info,
                          message: "Copied to clipboard",
                          iconAsset: Assets.svg.copy,
                          context: context,
                        );
                      },
                      child: RoundedWhiteContainer(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Your $ticker address",
                                  style: STextStyles.itemSubtitle(context),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.svg.copy,
                                      width: 10,
                                      height: 10,
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .infoItemIcons,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "Copy",
                                      style: STextStyles.link2(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ref.watch(
                                        pWalletReceivingAddress(walletId)),
                                    style: STextStyles.itemSubtitle12(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (ref.watch(pWallets
                              .select((value) => value.getWallet(walletId)))
                          is MultiAddressInterface ||
                      supportsSpark)
                    const SizedBox(
                      height: 12,
                    ),
                  if (ref.watch(pWallets
                              .select((value) => value.getWallet(walletId)))
                          is MultiAddressInterface ||
                      supportsSpark)
                    TextButton(
                      onPressed: supportsSpark && _showSparkAddress
                          ? generateNewSparkAddress
                          : generateNewAddress,
                      style: Theme.of(context)
                          .extension<StackColors>()!
                          .getSecondaryEnabledButtonStyle(context),
                      child: Text(
                        "Generate new address",
                        style: STextStyles.button(context).copyWith(
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .accentColorDark),
                      ),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundedWhiteContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            QrImageView(
                                data: AddressUtils.buildUriString(
                                  coin,
                                  _qrcodeContent ?? "",
                                  {},
                                ),
                                size: MediaQuery.of(context).size.width / 2,
                                foregroundColor: Theme.of(context)
                                    .extension<StackColors>()!
                                    .accentColorDark),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextButton(
                              text: "Create new QR code",
                              onTap: () async {
                                unawaited(Navigator.of(context).push(
                                  RouteGenerator.getRoute(
                                    shouldUseMaterialRoute:
                                        RouteGenerator.useMaterialPageRoute,
                                    builder: (_) => GenerateUriQrCodeView(
                                      coin: coin,
                                      receivingAddress: _qrcodeContent ?? "",
                                    ),
                                    settings: const RouteSettings(
                                      name: GenerateUriQrCodeView.routeName,
                                    ),
                                  ),
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
