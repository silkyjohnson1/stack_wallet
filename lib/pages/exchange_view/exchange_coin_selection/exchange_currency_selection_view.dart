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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';

import '../../../app_config.dart';
import '../../../exceptions/exchange/unsupported_currency_exception.dart';
import '../../../models/isar/exchange_cache/currency.dart';
import '../../../models/isar/exchange_cache/pair.dart';
import '../../../services/exchange/change_now/change_now_exchange.dart';
import '../../../services/exchange/exchange.dart';
import '../../../services/exchange/exchange_data_loading_service.dart';
import '../../../services/exchange/majestic_bank/majestic_bank_exchange.dart';
import '../../../services/exchange/trocador/trocador_exchange.dart';
import '../../../themes/stack_colors.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/prefs.dart';
import '../../../utilities/text_styles.dart';
import '../../../utilities/util.dart';
import '../../../widgets/background.dart';
import '../../../widgets/conditional_parent.dart';
import '../../../widgets/custom_buttons/app_bar_icon_button.dart';
import '../../../widgets/custom_loading_overlay.dart';
import '../../../widgets/desktop/primary_button.dart';
import '../../../widgets/desktop/secondary_button.dart';
import '../../../widgets/icon_widgets/x_icon.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/rounded_white_container.dart';
import '../../../widgets/stack_dialog.dart';
import '../../../widgets/stack_text_field.dart';
import '../../../widgets/textfield_icon_button.dart';
import '../../buy_view/sub_widgets/crypto_selection_view.dart';

class ExchangeCurrencySelectionView extends StatefulWidget {
  const ExchangeCurrencySelectionView({
    super.key,
    required this.willChangeTicker,
    required this.pairedTicker,
    required this.isFixedRate,
    required this.willChangeIsSend,
  });

  final String? willChangeTicker;
  final String? pairedTicker;
  final bool isFixedRate;
  final bool willChangeIsSend;

  @override
  State<ExchangeCurrencySelectionView> createState() =>
      _ExchangeCurrencySelectionViewState();
}

class _ExchangeCurrencySelectionViewState
    extends State<ExchangeCurrencySelectionView> {
  late TextEditingController _searchController;
  final _searchFocusNode = FocusNode();
  final isDesktop = Util.isDesktop;

  List<Currency> _currencies = [];

  bool _loaded = false;
  String _searchString = "";

  Future<T> _showUpdatingCurrencies<T>({
    required Future<T> whileFuture,
  }) async {
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Container(
            color: Theme.of(context)
                .extension<StackColors>()!
                .overlay
                .withOpacity(0.6),
            child: const CustomLoadingOverlay(
              message: "Loading currencies",
              eventBus: null,
            ),
          ),
        ),
      ),
    );

    final result = await whileFuture;

    if (mounted) {
      Navigator.of(context, rootNavigator: isDesktop).pop();
    }

    return result;
  }

  Future<List<Currency>> _loadCurrencies() async {
    if (widget.pairedTicker == null) {
      return await _getCurrencies();
    }
    await ExchangeDataLoadingService.instance.initDB();
    List<Currency> currencies = await ExchangeDataLoadingService
        .instance.isar.currencies
        .where()
        .filter()
        .exchangeNameEqualTo(MajesticBankExchange.exchangeName)
        .or()
        .exchangeNameStartsWith(TrocadorExchange.exchangeName)
        .findAll();

    final cn = await ChangeNowExchange.instance.getPairedCurrencies(
      widget.pairedTicker!,
      widget.isFixedRate,
    );

    if (cn.value == null) {
      if (cn.exception is UnsupportedCurrencyException) {
        return _getDistinctCurrenciesFrom(currencies);
      }

      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => StackDialog(
            title: "Exchange Error",
            message: "Failed to load currency data: ${cn.exception}",
            leftButton: SecondaryButton(
              label: "Ok",
              onPressed: Navigator.of(context, rootNavigator: isDesktop).pop,
            ),
            rightButton: PrimaryButton(
              label: "Retry",
              onPressed: () async {
                Navigator.of(context, rootNavigator: isDesktop).pop();
                _currencies = await _showUpdatingCurrencies(
                  whileFuture: _loadCurrencies(),
                );
                setState(() {});
              },
            ),
          ),
        );
      }
    } else {
      currencies.addAll(cn.value!);
    }

    return _getDistinctCurrenciesFrom(currencies);
  }

  Future<List<Currency>> _getCurrencies() async {
    await ExchangeDataLoadingService.instance.initDB();
    final currencies = await ExchangeDataLoadingService.instance.isar.currencies
        .where()
        .filter()
        .isFiatEqualTo(false)
        .and()
        .group(
          (q) => widget.isFixedRate
              ? q
                  .rateTypeEqualTo(SupportedRateType.both)
                  .or()
                  .rateTypeEqualTo(SupportedRateType.fixed)
              : q
                  .rateTypeEqualTo(SupportedRateType.both)
                  .or()
                  .rateTypeEqualTo(SupportedRateType.estimated),
        )
        .sortByIsStackCoin()
        .thenByName()
        .findAll();

    // If using Tor, filter exchanges which do not support Tor.
    if (Prefs.instance.useTor) {
      if (Exchange.exchangeNamesWithTorSupport.isNotEmpty) {
        currencies.removeWhere(
          (element) => !Exchange.exchangeNamesWithTorSupport
              .contains(element.exchangeName),
        );
      }
    }

    return _getDistinctCurrenciesFrom(currencies);
  }

  List<Currency> _getDistinctCurrenciesFrom(List<Currency> currencies) {
    final List<Currency> distinctCurrencies = [];
    for (final currency in currencies) {
      if (!distinctCurrencies.any(
        (e) => e.ticker.toLowerCase() == currency.ticker.toLowerCase(),
      )) {
        distinctCurrencies.add(currency);
      }
    }
    return distinctCurrencies;
  }

  List<Currency> filter(String text) {
    if (widget.pairedTicker == null) {
      if (text.isEmpty) {
        return _currencies;
      }

      return _currencies
          .where(
            (e) =>
                e.name.toLowerCase().contains(text.toLowerCase()) ||
                e.ticker.toLowerCase().contains(text.toLowerCase()),
          )
          .toList();
    } else {
      if (text.isEmpty) {
        return _currencies
            .where(
              (e) =>
                  e.ticker.toLowerCase() != widget.pairedTicker!.toLowerCase(),
            )
            .toList();
      }

      return _currencies
          .where(
            (e) =>
                e.ticker.toLowerCase() != widget.pairedTicker!.toLowerCase() &&
                (e.name.toLowerCase().contains(text.toLowerCase()) ||
                    e.ticker.toLowerCase().contains(text.toLowerCase())),
          )
          .toList();
    }
  }

  @override
  void initState() {
    _searchController = TextEditingController();

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
    if (!_loaded) {
      _loaded = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        _currencies =
            await _showUpdatingCurrencies(whileFuture: _loadCurrencies());
        setState(() {});
      });
    }

    return ConditionalParent(
      condition: !isDesktop,
      builder: (child) {
        return Background(
          child: Scaffold(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.background,
            appBar: AppBar(
              leading: AppBarBackButton(
                onPressed: () async {
                  if (FocusScope.of(context).hasFocus) {
                    FocusScope.of(context).unfocus();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 50),
                    );
                  }
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: Text(
                "Choose a coin to exchange",
                style: STextStyles.pageTitleH2(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: child,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (!isDesktop)
            const SizedBox(
              height: 16,
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
            child: TextField(
              autofocus: isDesktop,
              autocorrect: !isDesktop,
              enableSuggestions: !isDesktop,
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) => setState(() => _searchString = value),
              style: STextStyles.field(context),
              decoration: standardInputDecoration(
                "Search",
                _searchFocusNode,
                context,
                desktopMed: isDesktop,
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
                                    _searchString = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: Builder(
              builder: (context) {
                final coins = AppConfig.coins.where(
                  (e) =>
                      e.ticker.toLowerCase() !=
                      widget.pairedTicker?.toLowerCase(),
                );

                final items = filter(_searchString);

                final walletCoins = items
                    .where(
                      (currency) => coins
                          .where(
                            (coin) =>
                                coin.ticker.toLowerCase() ==
                                currency.ticker.toLowerCase(),
                          )
                          .isNotEmpty,
                    )
                    .toList();

                // sort alphabetically by name
                items.sort((a, b) => a.name.compareTo(b.name));

                // reverse sort walletCoins to prepare for next step
                walletCoins.sort((a, b) => b.name.compareTo(a.name));

                // insert wallet coins at beginning
                for (final c in walletCoins) {
                  items.remove(c);
                  items.insert(0, c);
                }

                return RoundedWhiteContainer(
                  padding: const EdgeInsets.all(0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: isDesktop ? false : null,
                    itemCount: items.length,
                    itemBuilder: (builderContext, index) {
                      final bool hasImageUrl =
                          items[index].image.startsWith("http");
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(items[index]);
                          },
                          child: RoundedWhiteContainer(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      AppConfig.isStackCoin(items[index].ticker)
                                          ? CoinIconForTicker(
                                              ticker: items[index].ticker,
                                              size: 24,
                                            )
                                          // ? getIconForTicker(
                                          //     items[index].ticker,
                                          //     size: 24,
                                          //   )
                                          : hasImageUrl
                                              ? SvgPicture.network(
                                                  items[index].image,
                                                  width: 24,
                                                  height: 24,
                                                  placeholderBuilder: (_) =>
                                                      const LoadingIndicator(),
                                                )
                                              : const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items[index].name,
                                        style:
                                            STextStyles.largeMedium14(context),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        items[index].ticker.toUpperCase(),
                                        style: STextStyles.smallMed12(context)
                                            .copyWith(
                                          color: Theme.of(context)
                                              .extension<StackColors>()!
                                              .textSubtitle1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
