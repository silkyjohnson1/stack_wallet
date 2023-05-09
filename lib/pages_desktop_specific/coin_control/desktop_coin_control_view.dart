import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/utxo.dart';
import 'package:stackwallet/pages_desktop_specific/coin_control/freeze_button.dart';
import 'package:stackwallet/pages_desktop_specific/coin_control/utxo_row.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/themes/coin_icon_provider.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/widgets/animated_widgets/rotate_icon.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/dropdown_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_app_bar.dart';
import 'package:stackwallet/widgets/desktop/desktop_scaffold.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/expandable2.dart';
import 'package:stackwallet/widgets/icon_widgets/x_icon.dart';
import 'package:stackwallet/widgets/rounded_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';
import 'package:stackwallet/widgets/textfield_icon_button.dart';

class DesktopCoinControlView extends ConsumerStatefulWidget {
  const DesktopCoinControlView({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  static const String routeName = "/desktopCoinControl";

  final String walletId;

  @override
  ConsumerState<DesktopCoinControlView> createState() =>
      _DesktopCoinControlViewState();
}

class _DesktopCoinControlViewState
    extends ConsumerState<DesktopCoinControlView> {
  late final TextEditingController _searchController;
  late final Coin coin;
  final searchFieldFocusNode = FocusNode();

  final Set<UtxoRowData> _selectedUTXOs = {};

  Map<String, List<Id>>? _map;
  List<Id>? _list;

  String _searchString = "";

  CCFilter _filter = CCFilter.all;
  CCSortDescriptor _sort = CCSortDescriptor.age;

  @override
  void initState() {
    _searchController = TextEditingController();
    coin = ref
        .read(walletsChangeNotifierProvider)
        .getManager(widget.walletId)
        .coin;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    if (_sort == CCSortDescriptor.address) {
      _list = null;
      _map = MainDB.instance.queryUTXOsGroupedByAddressSync(
        walletId: widget.walletId,
        filter: _filter,
        sort: _sort,
        searchTerm: _searchString,
        coin: coin,
      );
    } else {
      _map = null;
      _list = MainDB.instance.queryUTXOsSync(
        walletId: widget.walletId,
        filter: _filter,
        sort: _sort,
        searchTerm: _searchString,
        coin: coin,
      );
    }

    return DesktopScaffold(
      appBar: DesktopAppBar(
        background: Theme.of(context).extension<StackColors>()!.popupBG,
        leading: Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                width: 18,
              ),
              SvgPicture.asset(
                Assets.svg.coinControl.gamePad,
                width: 32,
                height: 32,
                color:
                    Theme.of(context).extension<StackColors>()!.textSubtitle1,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Coin control",
                style: STextStyles.desktopH3(context),
              ),
            ],
          ),
        ),
        useSpacers: false,
        isCompactHeight: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Constants.size.circularBorderRadius,
                    ),
                    child: TextField(
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: _searchController,
                      focusNode: searchFieldFocusNode,
                      onChanged: (value) {
                        setState(() {
                          _searchString = value;
                        });
                      },
                      style:
                          STextStyles.desktopTextExtraSmall(context).copyWith(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .textFieldActiveText,
                        height: 1.8,
                      ),
                      decoration: standardInputDecoration(
                        "Search...",
                        searchFieldFocusNode,
                        context,
                        desktopMed: true,
                      ).copyWith(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 18,
                          ),
                          child: SvgPicture.asset(
                            Assets.svg.search,
                            width: 20,
                            height: 20,
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
                ),
                const SizedBox(
                  width: 24,
                ),
                AnimatedCrossFade(
                  firstChild: JDropdownButton(
                    redrawOnScreenSizeChanged: true,
                    showIcon: true,
                    width: 200,
                    items: CCFilter.values.toSet(),
                    groupValue: _filter,
                    onSelectionChanged: (CCFilter? newValue) {
                      if (newValue != null && newValue != _filter) {
                        setState(() {
                          _filter = newValue;
                        });
                      }
                    },
                  ),
                  secondChild: FreezeButton(
                    key: Key("${_selectedUTXOs.length}"),
                    selectedUTXOs: _selectedUTXOs,
                  ),
                  crossFadeState: _selectedUTXOs.isEmpty
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                AnimatedCrossFade(
                  firstChild: JDropdownButton(
                    redrawOnScreenSizeChanged: true,
                    label: "Sort by...",
                    width: 200,
                    groupValue: _sort,
                    items: CCSortDescriptor.values.toSet(),
                    onSelectionChanged: (CCSortDescriptor? newValue) {
                      if (newValue != null && newValue != _sort) {
                        setState(() {
                          _sort = newValue;
                        });
                      }
                    },
                  ),
                  secondChild: SecondaryButton(
                    buttonHeight: ButtonHeight.l,
                    width: 200,
                    label: "Clear selection (${_selectedUTXOs.length})",
                    onPressed: () => setState(() => _selectedUTXOs.clear()),
                  ),
                  crossFadeState: _selectedUTXOs.isEmpty
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: _list != null
                  ? ListView.separated(
                      itemCount: _list!.length,
                      separatorBuilder: (context, _) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        final utxo = MainDB.instance.isar.utxos
                            .where()
                            .idEqualTo(_list![index])
                            .findFirstSync()!;
                        final data = UtxoRowData(utxo.id, false);
                        data.selected = _selectedUTXOs.contains(data);

                        return UtxoRow(
                          key: Key(
                              "${utxo.walletId}_${utxo.id}_${utxo.isBlocked}"),
                          data: data,
                          walletId: widget.walletId,
                          onSelectionChanged: (value) {
                            setState(() {
                              if (data.selected) {
                                _selectedUTXOs.add(value);
                              } else {
                                _selectedUTXOs.remove(value);
                              }
                            });
                          },
                        );
                      },
                    )
                  : ListView.separated(
                      itemCount: _map!.entries.length,
                      separatorBuilder: (context, _) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        final entry = _map!.entries.elementAt(index);
                        final _controller = RotateIconController();

                        return Expandable2(
                          border: Theme.of(context)
                              .extension<StackColors>()!
                              .backgroundAppBar,
                          background: Theme.of(context)
                              .extension<StackColors>()!
                              .popupBG,
                          animationDurationMultiplier: 0.2 * entry.value.length,
                          onExpandWillChange: (state) {
                            if (state == Expandable2State.expanded) {
                              _controller.forward?.call();
                            } else {
                              _controller.reverse?.call();
                            }
                          },
                          header: RoundedContainer(
                            padding: const EdgeInsets.all(20),
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  ref.watch(coinIconProvider(coin)),
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: STextStyles.w600_14(context),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "${entry.value.length} "
                                    "output${entry.value.length > 1 ? "s" : ""}",
                                    style:
                                        STextStyles.desktopTextExtraExtraSmall(
                                            context),
                                  ),
                                ),
                                RotateIcon(
                                  animationDurationMultiplier:
                                      0.2 * entry.value.length,
                                  icon: SvgPicture.asset(
                                    Assets.svg.chevronDown,
                                    width: 14,
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textSubtitle1,
                                  ),
                                  curve: Curves.easeInOut,
                                  controller: _controller,
                                ),
                              ],
                            ),
                          ),
                          children: entry.value.map(
                            (id) {
                              final utxo = MainDB.instance.isar.utxos
                                  .where()
                                  .idEqualTo(id)
                                  .findFirstSync()!;
                              final data = UtxoRowData(utxo.id, false);
                              data.selected = _selectedUTXOs.contains(data);

                              return UtxoRow(
                                key: Key(
                                    "${utxo.walletId}_${utxo.id}_${utxo.isBlocked}"),
                                data: data,
                                walletId: widget.walletId,
                                raiseOnSelected: false,
                                onSelectionChanged: (value) {
                                  setState(() {
                                    if (data.selected) {
                                      _selectedUTXOs.add(value);
                                    } else {
                                      _selectedUTXOs.remove(value);
                                    }
                                  });
                                },
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
