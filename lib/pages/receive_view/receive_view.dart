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
import 'package:stackwallet/utilities/enums/derive_path_type_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/wallets/crypto_currency/crypto_currency.dart';
import 'package:stackwallet/wallets/isar/providers/wallet_info_provider.dart';
import 'package:stackwallet/wallets/wallet/impl/bitcoin_wallet.dart';
import 'package:stackwallet/wallets/wallet/intermediate/bip39_hd_wallet.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/bcash_interface.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/multi_address_interface.dart';
import 'package:stackwallet/wallets/wallet/wallet_mixin_interfaces/spark_interface.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackwallet/widgets/custom_loading_overlay.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class ReceiveView extends ConsumerStatefulWidget {
  const ReceiveView({
    super.key,
    required this.walletId,
    this.tokenContract,
    this.clipboard = const ClipboardWrapper(),
  });

  static const String routeName = "/receiveView";

  final String walletId;
  final EthContract? tokenContract;
  final ClipboardInterface clipboard;

  @override
  ConsumerState<ReceiveView> createState() => _ReceiveViewState();
}

class _ReceiveViewState extends ConsumerState<ReceiveView> {
  late final CryptoCurrency coin;
  late final String walletId;
  late final ClipboardInterface clipboard;
  late final bool _supportsSpark;
  late final bool _showMultiType;

  int _currentIndex = 0;

  final List<AddressType> _walletAddressTypes = [];
  final Map<AddressType, String> _addressMap = {};
  final Map<AddressType, StreamSubscription<Address?>> _addressSubMap = {};

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

      final Address? address;
      if (wallet is Bip39HDWallet && wallet is! BCashInterface) {
        final type = DerivePathType.values.firstWhere(
          (e) => e.getAddressType() == _walletAddressTypes[_currentIndex],
        );
        address = await wallet.generateNextReceivingAddress(
          derivePathType: type,
        );
        await ref.read(mainDBProvider).isar.writeTxn(() async {
          await ref.read(mainDBProvider).isar.addresses.put(address!);
        });
      } else {
        await wallet.generateNewReceivingAddress();
        address = null;
      }

      shouldPop = true;

      if (mounted) {
        Navigator.of(context)
            .popUntil(ModalRoute.withName(ReceiveView.routeName));

        setState(() {
          _addressMap[_walletAddressTypes[_currentIndex]] =
              address?.value ?? ref.read(pWalletReceivingAddress(walletId));
        });
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
        setState(() {
          _addressMap[AddressType.spark] = address.value;
        });
      }
    }
  }

  @override
  void initState() {
    walletId = widget.walletId;
    coin = ref.read(pWalletCoin(walletId));
    clipboard = widget.clipboard;
    final wallet = ref.read(pWallets).getWallet(walletId);
    _supportsSpark = wallet is SparkInterface;
    _showMultiType = _supportsSpark ||
        (wallet is! BCashInterface &&
            wallet is Bip39HDWallet &&
            wallet.supportedAddressTypes.length > 1);

    _walletAddressTypes.add(coin.primaryAddressType);

    if (_showMultiType) {
      if (_supportsSpark) {
        _walletAddressTypes.insert(0, AddressType.spark);
      } else {
        _walletAddressTypes.addAll((wallet as Bip39HDWallet)
            .supportedAddressTypes
            .where((e) => e != coin.primaryAddressType));
      }
    }

    if (_walletAddressTypes.length > 1 && wallet is BitcoinWallet) {
      _walletAddressTypes.removeWhere((e) => e == AddressType.p2pkh);
    }

    _addressMap[_walletAddressTypes[_currentIndex]] =
        ref.read(pWalletReceivingAddress(walletId));

    if (_showMultiType) {
      for (final type in _walletAddressTypes) {
        _addressSubMap[type] = ref
            .read(mainDBProvider)
            .isar
            .addresses
            .where()
            .walletIdEqualTo(walletId)
            .filter()
            .typeEqualTo(type)
            .sortByDerivationIndexDesc()
            .findFirst()
            .asStream()
            .listen((event) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _addressMap[type] =
                    event?.value ?? _addressMap[type] ?? "[No address yet]";
              });
            }
          });
        });
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    for (final subscription in _addressSubMap.values) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final ticker = widget.tokenContract?.symbol ?? coin.ticker;

    final String address;
    if (_showMultiType) {
      address = _addressMap[_walletAddressTypes[_currentIndex]]!;
    } else {
      address = ref.watch(pWalletReceivingAddress(walletId));
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
                    condition: _showMultiType,
                    builder: (child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Address type",
                          style: STextStyles.w500_14(context).copyWith(
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .infoItemLabel,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            value: _currentIndex,
                            items: [
                              for (int i = 0;
                                  i < _walletAddressTypes.length;
                                  i++)
                                DropdownMenuItem(
                                  value: i,
                                  child: Text(
                                    _supportsSpark &&
                                            _walletAddressTypes[i] ==
                                                AddressType.p2pkh
                                        ? "Transparent address"
                                        : "${_walletAddressTypes[i].readableName} address",
                                    style: STextStyles.w500_14(context),
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null && value != _currentIndex) {
                                setState(() {
                                  _currentIndex = value;
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
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textFieldDefaultBG,
                                borderRadius: BorderRadius.circular(
                                  Constants.size.circularBorderRadius,
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
                        child,
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        clipboard.setData(
                          ClipboardData(
                            text: address,
                          ),
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
                                    address,
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
                  const SizedBox(
                    height: 12,
                  ),
                  PrimaryButton(
                    label: "Copy address",
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      clipboard.setData(
                        ClipboardData(
                          text: address,
                        ),
                      );
                      showFloatingFlushBar(
                        type: FlushBarType.info,
                        message: "Copied to clipboard",
                        iconAsset: Assets.svg.copy,
                        context: context,
                      );
                    },
                  ),
                  if (ref.watch(pWallets
                              .select((value) => value.getWallet(walletId)))
                          is MultiAddressInterface ||
                      _supportsSpark)
                    const SizedBox(
                      height: 12,
                    ),
                  if (ref.watch(pWallets
                              .select((value) => value.getWallet(walletId)))
                          is MultiAddressInterface ||
                      _supportsSpark)
                    SecondaryButton(
                      label: "Generate new address",
                      onPressed: _supportsSpark &&
                              _walletAddressTypes[_currentIndex] ==
                                  AddressType.spark
                          ? generateNewSparkAddress
                          : generateNewAddress,
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
                                  address,
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
                              text: "Advanced options",
                              onTap: () async {
                                unawaited(Navigator.of(context).push(
                                  RouteGenerator.getRoute(
                                    shouldUseMaterialRoute:
                                        RouteGenerator.useMaterialPageRoute,
                                    builder: (_) => GenerateUriQrCodeView(
                                      coin: coin,
                                      receivingAddress: address,
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
