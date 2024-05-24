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

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/isar/models/contact_entry.dart';
import '../../../../models/paynym/paynym_account_lite.dart';
import '../../../../models/send_view_auto_fill_data.dart';
import '../../../../pages/send_view/confirm_transaction_view.dart';
import '../../../../pages/send_view/sub_widgets/building_transaction_dialog.dart';
import '../../../desktop_home_view.dart';
import 'address_book_address_chooser/address_book_address_chooser.dart';
import 'desktop_fee_dropdown.dart';
import '../../../../providers/providers.dart';
import '../../../../providers/ui/fee_rate_type_state_provider.dart';
import '../../../../providers/ui/preview_tx_button_state_provider.dart';
import '../../../../themes/stack_colors.dart';
import '../../../../utilities/address_utils.dart';
import '../../../../utilities/amount/amount.dart';
import '../../../../utilities/amount/amount_formatter.dart';
import '../../../../utilities/amount/amount_input_formatter.dart';
import '../../../../utilities/barcode_scanner_interface.dart';
import '../../../../utilities/clipboard_interface.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/logger.dart';
import '../../../../utilities/prefs.dart';
import '../../../../utilities/text_styles.dart';
import '../../../../utilities/util.dart';
import '../../../../wallets/crypto_currency/coins/firo.dart';
import '../../../../wallets/crypto_currency/crypto_currency.dart';
import '../../../../wallets/isar/providers/eth/current_token_wallet_provider.dart';
import '../../../../wallets/isar/providers/eth/token_balance_provider.dart';
import '../../../../wallets/models/tx_data.dart';
import '../../../../widgets/custom_buttons/blue_text_button.dart';
import '../../../../widgets/desktop/desktop_dialog.dart';
import '../../../../widgets/desktop/desktop_dialog_close_button.dart';
import '../../../../widgets/desktop/primary_button.dart';
import '../../../../widgets/desktop/secondary_button.dart';
import '../../../../widgets/icon_widgets/addressbook_icon.dart';
import '../../../../widgets/icon_widgets/clipboard_icon.dart';
import '../../../../widgets/icon_widgets/x_icon.dart';
import '../../../../widgets/stack_text_field.dart';
import '../../../../widgets/textfield_icon_button.dart';

// const _kCryptoAmountRegex = r'^([0-9]*[,.]?[0-9]{0,8}|[,.][0-9]{0,8})$';

class DesktopTokenSend extends ConsumerStatefulWidget {
  const DesktopTokenSend({
    super.key,
    required this.walletId,
    this.autoFillData,
    this.clipboard = const ClipboardWrapper(),
    this.barcodeScanner = const BarcodeScannerWrapper(),
    this.accountLite,
  });

  final String walletId;
  final SendViewAutoFillData? autoFillData;
  final ClipboardInterface clipboard;
  final BarcodeScannerInterface barcodeScanner;
  final PaynymAccountLite? accountLite;

  @override
  ConsumerState<DesktopTokenSend> createState() => _DesktopTokenSendState();
}

class _DesktopTokenSendState extends ConsumerState<DesktopTokenSend> {
  late final String walletId;
  late final CryptoCurrency coin;
  late final ClipboardInterface clipboard;
  late final BarcodeScannerInterface scanner;

  late TextEditingController sendToController;
  late TextEditingController cryptoAmountController;
  late TextEditingController baseAmountController;
  late TextEditingController nonceController;

  late final SendViewAutoFillData? _data;

  final _addressFocusNode = FocusNode();
  final _cryptoFocus = FocusNode();
  final _baseFocus = FocusNode();
  final _nonceFocusNode = FocusNode();

  String? _note;

  Amount? _amountToSend;
  Amount? _cachedAmountToSend;
  String? _address;

  bool _addressToggleFlag = false;

  bool _cryptoAmountChangeLock = false;
  late VoidCallback onCryptoAmountChanged;

  Future<void> previewSend() async {
    final tokenWallet = ref.read(pCurrentTokenWallet)!;

    final Amount amount = _amountToSend!;
    final Amount availableBalance = ref
        .read(
          pTokenBalance(
            (
              walletId: walletId,
              contractAddress: tokenWallet.tokenContract.address
            ),
          ),
        )
        .spendable;

    // confirm send all
    if (amount == availableBalance) {
      final bool? shouldSendAll = await showDialog<bool>(
        context: context,
        useSafeArea: false,
        barrierDismissible: true,
        builder: (context) {
          return DesktopDialog(
            maxWidth: 450,
            maxHeight: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 32,
                bottom: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Confirm send all",
                        style: STextStyles.desktopH3(context),
                      ),
                      const DesktopDialogCloseButton(),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 32,
                    ),
                    child: Text(
                      "You are about to send your entire balance. Would you like to continue?",
                      textAlign: TextAlign.left,
                      style: STextStyles.desktopTextExtraExtraSmall(context)
                          .copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 32,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            buttonHeight: ButtonHeight.l,
                            label: "Cancel",
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: PrimaryButton(
                            buttonHeight: ButtonHeight.l,
                            label: "Yes",
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (shouldSendAll == null || shouldSendAll == false) {
        // cancel preview
        return;
      }
    }

    try {
      bool wasCancelled = false;

      if (mounted) {
        unawaited(
          showDialog<dynamic>(
            context: context,
            useSafeArea: false,
            barrierDismissible: false,
            builder: (context) {
              return DesktopDialog(
                maxWidth: 400,
                maxHeight: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: BuildingTransactionDialog(
                    coin: tokenWallet.cryptoCurrency,
                    isSpark: false,
                    onCancel: () {
                      wasCancelled = true;

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
          ),
        );
      }

      final time = Future<dynamic>.delayed(
        const Duration(
          milliseconds: 2500,
        ),
      );

      TxData txData;
      Future<TxData> txDataFuture;

      txDataFuture = tokenWallet.prepareSend(
        txData: TxData(
          recipients: [
            (
              address: _address!,
              amount: amount,
              isChange: false,
            ),
          ],
          feeRateType: ref.read(feeRateTypeStateProvider),
          nonce: int.tryParse(nonceController.text),
        ),
      );

      final results = await Future.wait([
        txDataFuture,
        time,
      ]);

      txData = results.first as TxData;

      if (!wasCancelled && mounted) {
        txData = txData.copyWith(
          note: _note ?? "",
        );

        // pop building dialog
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        unawaited(
          showDialog(
            context: context,
            builder: (context) => DesktopDialog(
              maxHeight: MediaQuery.of(context).size.height - 64,
              maxWidth: 580,
              child: ConfirmTransactionView(
                txData: txData,
                walletId: walletId,
                onSuccess: clearSendForm,
                isTokenTx: true,
                routeOnSuccessName: DesktopHomeView.routeName,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // pop building dialog
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        unawaited(
          showDialog<void>(
            context: context,
            builder: (context) {
              return DesktopDialog(
                maxWidth: 450,
                maxHeight: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    bottom: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transaction failed",
                            style: STextStyles.desktopH3(context),
                          ),
                          const DesktopDialogCloseButton(),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 32,
                        ),
                        child: SelectableText(
                          e.toString(),
                          textAlign: TextAlign.left,
                          style: STextStyles.desktopTextExtraExtraSmall(context)
                              .copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              buttonHeight: ButtonHeight.l,
                              label: "Ok",
                              onPressed: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  void clearSendForm() {
    sendToController.text = "";
    cryptoAmountController.text = "";
    baseAmountController.text = "";
    nonceController.text = "";
    _address = "";
    _addressToggleFlag = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _cryptoAmountChanged() async {
    if (!_cryptoAmountChangeLock) {
      final String cryptoAmount = cryptoAmountController.text;
      if (cryptoAmount.isNotEmpty &&
          cryptoAmount != "." &&
          cryptoAmount != ",") {
        _amountToSend = cryptoAmount.contains(",")
            ? Decimal.parse(cryptoAmount.replaceFirst(",", ".")).toAmount(
                fractionDigits:
                    ref.read(pCurrentTokenWallet)!.tokenContract.decimals,
              )
            : Decimal.parse(cryptoAmount).toAmount(
                fractionDigits:
                    ref.read(pCurrentTokenWallet)!.tokenContract.decimals,
              );
        if (_cachedAmountToSend != null &&
            _cachedAmountToSend == _amountToSend) {
          return;
        }
        Logging.instance.log(
          "it changed $_amountToSend $_cachedAmountToSend",
          level: LogLevel.Info,
        );
        _cachedAmountToSend = _amountToSend;

        final price = ref
            .read(priceAnd24hChangeNotifierProvider)
            .getTokenPrice(
              ref.read(pCurrentTokenWallet)!.tokenContract.address,
            )
            .item1;

        if (price > Decimal.zero) {
          final String fiatAmountString = Amount.fromDecimal(
            _amountToSend!.decimal * price,
            fractionDigits: 2,
          ).fiatString(
            locale: ref.read(localeServiceChangeNotifierProvider).locale,
          );

          baseAmountController.text = fiatAmountString;
        }
      } else {
        _amountToSend = null;
        _cachedAmountToSend = null;
        baseAmountController.text = "";
      }

      _updatePreviewButtonState(_address, _amountToSend);
    }
  }

  String? _updateInvalidAddressText(String address) {
    if (_data != null && _data!.contactLabel == address) {
      return null;
    }
    if (address.isNotEmpty &&
        !ref
            .read(pWallets)
            .getWallet(walletId)
            .cryptoCurrency
            .validateAddress(address)) {
      return "Invalid address";
    }
    return null;
  }

  void _updatePreviewButtonState(String? address, Amount? amount) {
    final wallet = ref.read(pWallets).getWallet(walletId);

    final isValidAddress = wallet.cryptoCurrency.validateAddress(address ?? "");
    ref.read(previewTokenTxButtonStateProvider.state).state =
        (isValidAddress && amount != null && amount > Amount.zero);
  }

  Future<void> scanQr() async {
    try {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
        await Future<void>.delayed(const Duration(milliseconds: 75));
      }

      final qrResult = await scanner.scan();

      Logging.instance.log(
        "qrResult content: ${qrResult.rawContent}",
        level: LogLevel.Info,
      );

      final results = AddressUtils.parseUri(qrResult.rawContent);

      Logging.instance.log("qrResult parsed: $results", level: LogLevel.Info);

      if (results.isNotEmpty && results["scheme"] == coin.uriScheme) {
        // auto fill address
        _address = results["address"] ?? "";
        sendToController.text = _address!;

        // autofill notes field
        if (results["message"] != null) {
          _note = results["message"]!;
        } else if (results["label"] != null) {
          _note = results["label"]!;
        }

        // autofill amount field
        if (results["amount"] != null) {
          final amount = Decimal.parse(results["amount"]!).toAmount(
            fractionDigits:
                ref.read(pCurrentTokenWallet)!.tokenContract.decimals,
          );
          cryptoAmountController.text = ref.read(pAmountFormatter(coin)).format(
                amount,
                withUnitName: false,
              );

          _amountToSend = amount;
        }

        _updatePreviewButtonState(_address, _amountToSend);
        setState(() {
          _addressToggleFlag = sendToController.text.isNotEmpty;
        });

        // now check for non standard encoded basic address
      } else if (ref
          .read(pWallets)
          .getWallet(walletId)
          .cryptoCurrency
          .validateAddress(qrResult.rawContent)) {
        _address = qrResult.rawContent;
        sendToController.text = _address ?? "";

        _updatePreviewButtonState(_address, _amountToSend);
        setState(() {
          _addressToggleFlag = sendToController.text.isNotEmpty;
        });
      }
    } on PlatformException catch (e, s) {
      // here we ignore the exception caused by not giving permission
      // to use the camera to scan a qr code
      Logging.instance.log(
        "Failed to get camera permissions while trying to scan qr code in SendView: $e\n$s",
        level: LogLevel.Warning,
      );
    }
  }

  Future<void> pasteAddress() async {
    final ClipboardData? data = await clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      String content = data.text!.trim();
      if (content.contains("\n")) {
        content = content.substring(0, content.indexOf("\n"));
      }

      sendToController.text = content;
      _address = content;

      _updatePreviewButtonState(_address, _amountToSend);
      setState(() {
        _addressToggleFlag = sendToController.text.isNotEmpty;
      });
    }
  }

  void fiatTextFieldOnChanged(String baseAmountString) {
    final int tokenDecimals =
        ref.read(pCurrentTokenWallet)!.tokenContract.decimals;

    if (baseAmountString.isNotEmpty &&
        baseAmountString != "." &&
        baseAmountString != ",") {
      final baseAmount = baseAmountString.contains(",")
          ? Decimal.parse(baseAmountString.replaceFirst(",", "."))
              .toAmount(fractionDigits: 2)
          : Decimal.parse(baseAmountString).toAmount(fractionDigits: 2);

      final Decimal _price = ref
          .read(priceAnd24hChangeNotifierProvider)
          .getTokenPrice(
            ref.read(pCurrentTokenWallet)!.tokenContract.address,
          )
          .item1;

      if (_price == Decimal.zero) {
        _amountToSend = Decimal.zero.toAmount(fractionDigits: tokenDecimals);
      } else {
        _amountToSend = baseAmount <= Amount.zero
            ? Decimal.zero.toAmount(fractionDigits: tokenDecimals)
            : (baseAmount.decimal / _price)
                .toDecimal(scaleOnInfinitePrecision: tokenDecimals)
                .toAmount(fractionDigits: tokenDecimals);
      }
      if (_cachedAmountToSend != null && _cachedAmountToSend == _amountToSend) {
        return;
      }
      _cachedAmountToSend = _amountToSend;
      Logging.instance.log(
        "it changed $_amountToSend $_cachedAmountToSend",
        level: LogLevel.Info,
      );

      final amountString = ref.read(pAmountFormatter(coin)).format(
            _amountToSend!,
            withUnitName: false,
            ethContract: ref.read(pCurrentTokenWallet)!.tokenContract,
          );

      _cryptoAmountChangeLock = true;
      cryptoAmountController.text = amountString;
      _cryptoAmountChangeLock = false;
    } else {
      _amountToSend = Decimal.zero.toAmount(fractionDigits: tokenDecimals);
      _cryptoAmountChangeLock = true;
      cryptoAmountController.text = "";
      _cryptoAmountChangeLock = false;
    }

    _updatePreviewButtonState(_address, _amountToSend);
  }

  Future<void> sendAllTapped() async {
    cryptoAmountController.text = ref
        .read(
          pTokenBalance(
            (
              walletId: walletId,
              contractAddress:
                  ref.read(pCurrentTokenWallet)!.tokenContract.address
            ),
          ),
        )
        .spendable
        .decimal
        .toStringAsFixed(
          ref.read(pCurrentTokenWallet)!.tokenContract.decimals,
        );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(tokenFeeSessionCacheProvider);
      ref.read(previewTokenTxButtonStateProvider.state).state = false;
    });

    // _calculateFeesFuture = calculateFees(0);
    _data = widget.autoFillData;
    walletId = widget.walletId;
    coin = ref.read(pWallets).getWallet(walletId).info.coin;
    clipboard = widget.clipboard;
    scanner = widget.barcodeScanner;

    sendToController = TextEditingController();
    cryptoAmountController = TextEditingController();
    baseAmountController = TextEditingController();
    nonceController = TextEditingController();
    // feeController = TextEditingController();

    onCryptoAmountChanged = _cryptoAmountChanged;
    cryptoAmountController.addListener(onCryptoAmountChanged);

    if (_data != null) {
      if (_data!.amount != null) {
        cryptoAmountController.text = _data!.amount!.toString();
      }
      sendToController.text = _data!.contactLabel;
      _address = _data!.address;
      _addressToggleFlag = true;
    }

    _cryptoFocus.addListener(() {
      if (!_cryptoFocus.hasFocus && !_baseFocus.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_amountToSend == null) {
            ref.refresh(sendAmountProvider);
          } else {
            ref.read(sendAmountProvider.state).state = _amountToSend!;
          }
        });
      }
    });

    _baseFocus.addListener(() {
      if (!_cryptoFocus.hasFocus && !_baseFocus.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_amountToSend == null) {
            ref.refresh(sendAmountProvider);
          } else {
            ref.read(sendAmountProvider.state).state = _amountToSend!;
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    cryptoAmountController.removeListener(onCryptoAmountChanged);

    sendToController.dispose();
    cryptoAmountController.dispose();
    baseAmountController.dispose();
    nonceController.dispose();
    // feeController.dispose();

    _addressFocusNode.dispose();
    _cryptoFocus.dispose();
    _baseFocus.dispose();
    _nonceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final tokenContract = ref.watch(pCurrentTokenWallet)!.tokenContract;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        if (coin is Firo)
          Text(
            "Send from",
            style: STextStyles.desktopTextExtraSmall(context).copyWith(
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .textFieldActiveSearchIconRight,
            ),
            textAlign: TextAlign.left,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Amount",
              style: STextStyles.desktopTextExtraSmall(context).copyWith(
                color: Theme.of(context)
                    .extension<StackColors>()!
                    .textFieldActiveSearchIconRight,
              ),
              textAlign: TextAlign.left,
            ),
            CustomTextButton(
              text: "Send all ${tokenContract.symbol}",
              onTap: sendAllTapped,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          autocorrect: Util.isDesktop ? false : true,
          enableSuggestions: Util.isDesktop ? false : true,
          style: STextStyles.smallMed14(context).copyWith(
            color: Theme.of(context).extension<StackColors>()!.textDark,
          ),
          key: const Key("amountInputFieldCryptoTextFieldKey"),
          controller: cryptoAmountController,
          focusNode: _cryptoFocus,
          keyboardType: Util.isDesktop
              ? null
              : const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
          textAlign: TextAlign.right,
          inputFormatters: [
            AmountInputFormatter(
              decimals: tokenContract.decimals,
              unit: ref.watch(pAmountUnit(coin)),
              locale: ref.watch(
                localeServiceChangeNotifierProvider
                    .select((value) => value.locale),
              ),
            ),
            // regex to validate a crypto amount with 8 decimal places
            // TextInputFormatter.withFunction((oldValue, newValue) => RegExp(
            //       _kCryptoAmountRegex.replaceAll(
            //         "0,8",
            //         "0,${tokenContract.decimals}",
            //       ),
            //     ).hasMatch(newValue.text)
            //         ? newValue
            //         : oldValue),
          ],
          onChanged: (newValue) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              top: 22,
              right: 12,
              bottom: 22,
            ),
            hintText: "0",
            hintStyle: STextStyles.desktopTextExtraSmall(context).copyWith(
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .textFieldDefaultText,
            ),
            prefixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  tokenContract.symbol,
                  style: STextStyles.smallMed14(context).copyWith(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .accentColorDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (Prefs.instance.externalCalls)
          const SizedBox(
            height: 10,
          ),
        if (Prefs.instance.externalCalls)
          TextField(
            autocorrect: Util.isDesktop ? false : true,
            enableSuggestions: Util.isDesktop ? false : true,
            style: STextStyles.smallMed14(context).copyWith(
              color: Theme.of(context).extension<StackColors>()!.textDark,
            ),
            key: const Key("amountInputFieldFiatTextFieldKey"),
            controller: baseAmountController,
            focusNode: _baseFocus,
            keyboardType: Util.isDesktop
                ? null
                : const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
            textAlign: TextAlign.right,
            inputFormatters: [
              AmountInputFormatter(
                decimals: 2,
                locale: ref.watch(
                  localeServiceChangeNotifierProvider
                      .select((value) => value.locale),
                ),
              ),
              // // regex to validate a fiat amount with 2 decimal places
              // TextInputFormatter.withFunction((oldValue, newValue) =>
              //     RegExp(r'^([0-9]*[,.]?[0-9]{0,2}|[,.][0-9]{0,2})$')
              //             .hasMatch(newValue.text)
              //         ? newValue
              //         : oldValue),
            ],
            onChanged: fiatTextFieldOnChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                top: 22,
                right: 12,
                bottom: 22,
              ),
              hintText: "0",
              hintStyle: STextStyles.desktopTextExtraSmall(context).copyWith(
                color: Theme.of(context)
                    .extension<StackColors>()!
                    .textFieldDefaultText,
              ),
              prefixIcon: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    ref.watch(
                      prefsChangeNotifierProvider
                          .select((value) => value.currency),
                    ),
                    style: STextStyles.smallMed14(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .accentColorDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Send to",
          style: STextStyles.desktopTextExtraSmall(context).copyWith(
            color: Theme.of(context)
                .extension<StackColors>()!
                .textFieldActiveSearchIconRight,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
          child: TextField(
            minLines: 1,
            maxLines: 5,
            key: const Key("sendViewAddressFieldKey"),
            controller: sendToController,
            readOnly: false,
            autocorrect: false,
            enableSuggestions: false,
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(
            //       RegExp("[a-zA-Z0-9]{34}")),
            // ],
            toolbarOptions: const ToolbarOptions(
              copy: false,
              cut: false,
              paste: true,
              selectAll: false,
            ),
            onChanged: (newValue) {
              _address = newValue;
              _updatePreviewButtonState(_address, _amountToSend);

              setState(() {
                _addressToggleFlag = newValue.isNotEmpty;
              });
            },
            focusNode: _addressFocusNode,
            style: STextStyles.desktopTextExtraSmall(context).copyWith(
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .textFieldActiveText,
              height: 1.8,
            ),
            decoration: standardInputDecoration(
              "Enter ${tokenContract.symbol} address",
              _addressFocusNode,
              context,
              desktopMed: true,
            ).copyWith(
              contentPadding: const EdgeInsets.only(
                left: 16,
                top: 11,
                bottom: 12,
                right: 5,
              ),
              suffixIcon: Padding(
                padding: sendToController.text.isEmpty
                    ? const EdgeInsets.only(right: 8)
                    : const EdgeInsets.only(right: 0),
                child: UnconstrainedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _addressToggleFlag
                          ? TextFieldIconButton(
                              key: const Key(
                                "sendTokenViewClearAddressFieldButtonKey",
                              ),
                              onTap: () {
                                sendToController.text = "";
                                _address = "";
                                _updatePreviewButtonState(
                                  _address,
                                  _amountToSend,
                                );
                                setState(() {
                                  _addressToggleFlag = false;
                                });
                              },
                              child: const XIcon(),
                            )
                          : TextFieldIconButton(
                              key: const Key(
                                "sendTokenViewPasteAddressFieldButtonKey",
                              ),
                              onTap: pasteAddress,
                              child: sendToController.text.isEmpty
                                  ? const ClipboardIcon()
                                  : const XIcon(),
                            ),
                      if (sendToController.text.isEmpty)
                        TextFieldIconButton(
                          key: const Key("sendTokenViewAddressBookButtonKey"),
                          onTap: () async {
                            final entry =
                                await showDialog<ContactAddressEntry?>(
                              context: context,
                              builder: (context) => DesktopDialog(
                                maxWidth: 696,
                                maxHeight: 600,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 32,
                                          ),
                                          child: Text(
                                            "Address book",
                                            style:
                                                STextStyles.desktopH3(context),
                                          ),
                                        ),
                                        const DesktopDialogCloseButton(),
                                      ],
                                    ),
                                    Expanded(
                                      child: AddressBookAddressChooser(
                                        coin: coin,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            if (entry != null) {
                              sendToController.text =
                                  entry.other ?? entry.label;

                              _address = entry.address;

                              _updatePreviewButtonState(
                                _address,
                                _amountToSend,
                              );

                              setState(() {
                                _addressToggleFlag = true;
                              });
                            }
                          },
                          child: const AddressBookIcon(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Builder(
          builder: (_) {
            final error = _updateInvalidAddressText(
              _address ?? "",
            );

            if (error == null || error.isEmpty) {
              return Container();
            } else {
              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    top: 4.0,
                  ),
                  child: Text(
                    error,
                    textAlign: TextAlign.left,
                    style: STextStyles.label(context).copyWith(
                      color:
                          Theme.of(context).extension<StackColors>()!.textError,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Transaction fee (max)",
          style: STextStyles.desktopTextExtraSmall(context).copyWith(
            color: Theme.of(context)
                .extension<StackColors>()!
                .textFieldActiveSearchIconRight,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10,
        ),
        DesktopFeeDropDown(
          walletId: walletId,
          isToken: true,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Nonce",
          style: STextStyles.desktopTextExtraSmall(context).copyWith(
            color: Theme.of(context)
                .extension<StackColors>()!
                .textFieldActiveSearchIconRight,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
          child: TextField(
            minLines: 1,
            maxLines: 1,
            key: const Key("sendViewNonceFieldKey"),
            controller: nonceController,
            readOnly: false,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: const TextInputType.numberWithOptions(),
            focusNode: _nonceFocusNode,
            style: STextStyles.desktopTextExtraSmall(context).copyWith(
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .textFieldActiveText,
              height: 1.8,
            ),
            decoration: standardInputDecoration(
              "Leave empty to auto select nonce",
              _nonceFocusNode,
              context,
              desktopMed: true,
            ).copyWith(
              contentPadding: const EdgeInsets.only(
                left: 16,
                top: 11,
                bottom: 12,
                right: 5,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        PrimaryButton(
          buttonHeight: ButtonHeight.l,
          label: "Preview send",
          enabled: ref.watch(previewTokenTxButtonStateProvider.state).state,
          onPressed: ref.watch(previewTokenTxButtonStateProvider.state).state
              ? previewSend
              : null,
        ),
      ],
    );
  }
}
