/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages/add_wallet_views/create_or_restore_wallet_view/sub_widgets/coin_image.dart';
import 'package:stackwallet/pages/add_wallet_views/restore_wallet_view/restore_options_view/sub_widgets/mobile_mnemonic_length_selector.dart';
import 'package:stackwallet/pages/add_wallet_views/restore_wallet_view/restore_options_view/sub_widgets/restore_from_date_picker.dart';
import 'package:stackwallet/pages/add_wallet_views/restore_wallet_view/restore_options_view/sub_widgets/restore_options_next_button.dart';
import 'package:stackwallet/pages/add_wallet_views/restore_wallet_view/restore_options_view/sub_widgets/restore_options_platform_layout.dart';
import 'package:stackwallet/pages/add_wallet_views/restore_wallet_view/restore_wallet_view.dart';
import 'package:stackwallet/pages/add_wallet_views/restore_wallet_view/sub_widgets/mnemonic_word_count_select_sheet.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackwallet/providers/ui/verify_recovery_phrase/mnemonic_word_count_state_provider.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/format.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/date_picker/date_picker.dart';
import 'package:stackwallet/widgets/desktop/desktop_app_bar.dart';
import 'package:stackwallet/widgets/desktop/desktop_scaffold.dart';
import 'package:stackwallet/widgets/expandable.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';
import 'package:tuple/tuple.dart';

class RestoreOptionsView extends ConsumerStatefulWidget {
  const RestoreOptionsView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const routeName = "/restoreOptions";

  final String walletName;
  final Coin coin;

  @override
  ConsumerState<RestoreOptionsView> createState() => _RestoreOptionsViewState();
}

class _RestoreOptionsViewState extends ConsumerState<RestoreOptionsView> {
  late final String walletName;
  late final Coin coin;
  late final bool isDesktop;

  late TextEditingController _dateController;
  late FocusNode textFieldFocusNode;
  late final FocusNode passwordFocusNode;
  late final TextEditingController passwordController;

  final bool _nextEnabled = true;
  DateTime _restoreFromDate = DateTime.fromMillisecondsSinceEpoch(0);
  bool hidePassword = true;
  bool _expandedAdavnced = false;

  bool get supportsMnemonicPassphrase =>
      !(coin == Coin.monero || coin == Coin.wownero || coin == Coin.epicCash);

  @override
  void initState() {
    walletName = widget.walletName;
    coin = widget.coin;
    isDesktop = Util.isDesktop;

    _dateController = TextEditingController();
    textFieldFocusNode = FocusNode();
    passwordController = TextEditingController();
    passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    textFieldFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> nextPressed() async {
    if (!isDesktop) {
      // hide keyboard if has focus
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
        await Future<void>.delayed(const Duration(milliseconds: 75));
      }
    }

    if (mounted) {
      await Navigator.of(context).pushNamed(
        RestoreWalletView.routeName,
        arguments: Tuple5(
          walletName,
          coin,
          ref.read(mnemonicWordCountStateProvider.state).state,
          _restoreFromDate,
          passwordController.text,
        ),
      );
    }
  }

  Future<void> chooseDate() async {
    // check and hide keyboard
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future<void>.delayed(const Duration(milliseconds: 125));
    }

    if (mounted) {
      final date = await showSWDatePicker(context);
      if (date != null) {
        _restoreFromDate = date;
        _dateController.text = Format.formatDate(date);
      }
    }
  }

  Future<void> chooseDesktopDate() async {
    final date = await showSWDatePicker(context);
    if (date != null) {
      _restoreFromDate = date;
      _dateController.text = Format.formatDate(date);
    }
  }

  Future<void> chooseMnemonicLength() async {
    await showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return MnemonicWordCountSelectSheet(
          lengthOptions: Constants.possibleLengthsForCoin(coin),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType with ${coin.name} $walletName");

    final lengths = Constants.possibleLengthsForCoin(coin).toList();

    return MasterScaffold(
      isDesktop: isDesktop,
      appBar: isDesktop
          ? const DesktopAppBar(
              isCompactHeight: false,
              leading: AppBarBackButton(),
              trailing: ExitToMyStackButton(),
            )
          : AppBar(
              leading: AppBarBackButton(
                onPressed: () {
                  if (textFieldFocusNode.hasFocus) {
                    textFieldFocusNode.unfocus();
                    Future<void>.delayed(const Duration(milliseconds: 100))
                        .then((value) => Navigator.of(context).pop());
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
      body: RestoreOptionsPlatformLayout(
        isDesktop: isDesktop,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 480 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(
                flex: isDesktop ? 10 : 1,
              ),
              if (!isDesktop)
                CoinImage(
                  coin: coin,
                  height: 100,
                  width: 100,
                ),
              SizedBox(
                height: isDesktop ? 0 : 16,
              ),
              Text(
                "Restore options",
                textAlign: TextAlign.center,
                style: isDesktop
                    ? STextStyles.desktopH2(context)
                    : STextStyles.pageTitleH1(context),
              ),
              SizedBox(
                height: isDesktop ? 40 : 24,
              ),
              if (coin == Coin.monero ||
                  coin == Coin.epicCash ||
                  (coin == Coin.wownero &&
                      ref.watch(mnemonicWordCountStateProvider.state).state ==
                          25))
                Text(
                  "Choose start date",
                  style: isDesktop
                      ? STextStyles.desktopTextExtraSmall(context).copyWith(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textDark3,
                        )
                      : STextStyles.smallMed12(context),
                  textAlign: TextAlign.left,
                ),
              if (coin == Coin.monero ||
                  coin == Coin.epicCash ||
                  (coin == Coin.wownero &&
                      ref.watch(mnemonicWordCountStateProvider.state).state ==
                          25))
                SizedBox(
                  height: isDesktop ? 16 : 8,
                ),
              if (coin == Coin.monero ||
                  coin == Coin.epicCash ||
                  (coin == Coin.wownero &&
                      ref.watch(mnemonicWordCountStateProvider.state).state ==
                          25))
                if (!isDesktop)
                  RestoreFromDatePicker(
                    onTap: chooseDate,
                    controller: _dateController,
                  ),
              if (coin == Coin.monero ||
                  coin == Coin.epicCash ||
                  (coin == Coin.wownero &&
                      ref.watch(mnemonicWordCountStateProvider.state).state ==
                          25))
                if (isDesktop)
                  // TODO desktop date picker
                  RestoreFromDatePicker(
                    onTap: chooseDesktopDate,
                    controller: _dateController,
                  ),
              if (coin == Coin.monero ||
                  coin == Coin.epicCash ||
                  (coin == Coin.wownero &&
                      ref.watch(mnemonicWordCountStateProvider.state).state ==
                          25))
                const SizedBox(
                  height: 8,
                ),
              if (coin == Coin.monero ||
                  coin == Coin.epicCash ||
                  (coin == Coin.wownero &&
                      ref.watch(mnemonicWordCountStateProvider.state).state ==
                          25))
                RoundedWhiteContainer(
                  child: Center(
                    child: Text(
                      "Choose the date you made the wallet (approximate is fine)",
                      style: isDesktop
                          ? STextStyles.desktopTextExtraSmall(context).copyWith(
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textSubtitle1,
                            )
                          : STextStyles.smallMed12(context).copyWith(
                              fontSize: 10,
                            ),
                    ),
                  ),
                ),
              if (coin == Coin.monero ||
                  coin == Coin.epicCash ||
                  (coin == Coin.wownero &&
                      ref.watch(mnemonicWordCountStateProvider.state).state ==
                          25))
                SizedBox(
                  height: isDesktop ? 24 : 16,
                ),
              Text(
                "Choose recovery phrase length",
                style: isDesktop
                    ? STextStyles.desktopTextExtraSmall(context).copyWith(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .textDark3,
                      )
                    : STextStyles.smallMed12(context),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: isDesktop ? 16 : 8,
              ),
              if (isDesktop)
                DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    value:
                        ref.watch(mnemonicWordCountStateProvider.state).state,
                    items: [
                      ...lengths.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            "$e words",
                            style: STextStyles.desktopTextMedium(context),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value is int) {
                        ref.read(mnemonicWordCountStateProvider.state).state =
                            value;
                      }
                    },
                    isExpanded: true,
                    iconStyleData: IconStyleData(
                      icon: SvgPicture.asset(
                        Assets.svg.chevronDown,
                        width: 12,
                        height: 6,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .textFieldActiveSearchIconRight,
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
              if (!isDesktop)
                MobileMnemonicLengthSelector(
                  chooseMnemonicLength: chooseMnemonicLength,
                ),
              if (supportsMnemonicPassphrase)
                SizedBox(
                  height: isDesktop ? 24 : 16,
                ),
              if (supportsMnemonicPassphrase)
                Expandable(
                  onExpandChanged: (state) {
                    setState(() {
                      _expandedAdavnced = state == ExpandableState.expanded;
                    });
                  },
                  header: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Advanced",
                            style: isDesktop
                                ? STextStyles.desktopTextExtraExtraSmall(
                                        context)
                                    .copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textDark3,
                                  )
                                : STextStyles.smallMed12(context),
                            textAlign: TextAlign.left,
                          ),
                          SvgPicture.asset(
                            _expandedAdavnced
                                ? Assets.svg.chevronUp
                                : Assets.svg.chevronDown,
                            width: 12,
                            height: 6,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textFieldActiveSearchIconRight,
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Constants.size.circularBorderRadius,
                          ),
                          child: TextField(
                            key: const Key("mnemonicPassphraseFieldKey1"),
                            focusNode: passwordFocusNode,
                            controller: passwordController,
                            style: isDesktop
                                ? STextStyles.desktopTextMedium(context)
                                    .copyWith(
                                    height: 2,
                                  )
                                : STextStyles.field(context),
                            obscureText: hidePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: standardInputDecoration(
                              "BIP39 passphrase",
                              passwordFocusNode,
                              context,
                            ).copyWith(
                              suffixIcon: UnconstrainedBox(
                                child: ConditionalParent(
                                  condition: isDesktop,
                                  builder: (child) => SizedBox(
                                    height: 70,
                                    child: child,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: isDesktop ? 24 : 16,
                                      ),
                                      GestureDetector(
                                        key: const Key(
                                            "mnemonicPassphraseFieldShowPasswordButtonKey"),
                                        onTap: () async {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          hidePassword
                                              ? Assets.svg.eye
                                              : Assets.svg.eyeSlash,
                                          color: Theme.of(context)
                                              .extension<StackColors>()!
                                              .textDark3,
                                          width: isDesktop ? 24 : 16,
                                          height: isDesktop ? 24 : 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RoundedWhiteContainer(
                          child: Center(
                            child: Text(
                              "If the recovery phrase you are about to restore "
                              "was created with an optional BIP39 passphrase "
                              "you can enter it here.",
                              style: isDesktop
                                  ? STextStyles.desktopTextExtraSmall(context)
                                      .copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .textSubtitle1,
                                    )
                                  : STextStyles.itemSubtitle(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isDesktop)
                const Spacer(
                  flex: 3,
                ),
              if (isDesktop)
                const SizedBox(
                  height: 32,
                ),
              RestoreOptionsNextButton(
                isDesktop: isDesktop,
                onPressed: _nextEnabled ? nextPressed : null,
              ),
              if (isDesktop)
                const Spacer(
                  flex: 15,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
