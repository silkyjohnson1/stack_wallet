import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/models/contact.dart';
import 'package:stackwallet/pages/address_book_views/subviews/contact_popup.dart';
import 'package:stackwallet/providers/global/address_book_service_provider.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/expandable.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class AddressBookCard extends ConsumerStatefulWidget {
  const AddressBookCard({
    Key? key,
    required this.contactId,
    this.indicatorDown,
    this.desktopSendFrom = true,
  }) : super(key: key);

  final String contactId;
  final ExpandableState? indicatorDown;
  final bool desktopSendFrom;

  @override
  ConsumerState<AddressBookCard> createState() => _AddressBookCardState();
}

class _AddressBookCardState extends ConsumerState<AddressBookCard> {
  late final String contactId;
  late final bool isDesktop;
  late final bool desktopSendFrom;

  @override
  void initState() {
    contactId = widget.contactId;
    desktopSendFrom = widget.desktopSendFrom;
    isDesktop = Util.isDesktop;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // provider hack to prevent trying to update widget with deleted contact
    Contact? _contact;
    try {
      _contact = ref.watch(addressBookServiceProvider
          .select((value) => value.getContactById(contactId)));
    } catch (_) {
      return Container();
    }

    final contact = _contact!;

    final List<Coin> coins = [];
    for (var element in contact.addresses) {
      if (!coins.contains(element.coin)) {
        coins.add(element.coin);
      }
    }

    String coinsString = "";
    if (coins.isNotEmpty) {
      coinsString = coins[0].ticker;
      for (int i = 1; i < coins.length; i++) {
        coinsString += ", ${coins[i].ticker}";
      }
    }

    return ConditionalParent(
      condition: !isDesktop,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: contact.id == "default"
                  ? Theme.of(context)
                      .extension<StackColors>()!
                      .myStackContactIconBG
                  : Theme.of(context)
                      .extension<StackColors>()!
                      .textFieldDefaultBG,
              borderRadius: BorderRadius.circular(32),
            ),
            child: contact.id == "default"
                ? Center(
                    child: SvgPicture.asset(
                      Assets.svg.stackIcon(context),
                      width: 20,
                    ),
                  )
                : contact.emojiChar != null
                    ? Center(
                        child: Text(contact.emojiChar!),
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
          if (isDesktop)
            Text(
              contact.name,
              style: STextStyles.itemSubtitle12(context),
            ),
          if (isDesktop)
            const SizedBox(
              width: 16,
            ),
          if (isDesktop && !desktopSendFrom) const Spacer(),
          if (isDesktop)
            Text(
              coinsString,
              style: STextStyles.label(context),
            ),
          if (!isDesktop)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: STextStyles.itemSubtitle12(context),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  coinsString,
                  style: STextStyles.label(context),
                ),
              ],
            ),
          if (isDesktop && desktopSendFrom) const Spacer(),
          if (isDesktop && desktopSendFrom)
            SvgPicture.asset(
              widget.indicatorDown == ExpandableState.collapsed
                  ? Assets.svg.chevronDown
                  : Assets.svg.chevronUp,
              width: 10,
              height: 5,
              color: Theme.of(context).extension<StackColors>()!.textSubtitle2,
            ),
        ],
      ),
      builder: (child) => RoundedWhiteContainer(
        padding: const EdgeInsets.all(4),
        child: RawMaterialButton(
          // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
          padding: const EdgeInsets.all(0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
          ),
          onPressed: () {
            showDialog<void>(
              context: context,
              useSafeArea: true,
              barrierDismissible: true,
              builder: (_) => ContactPopUp(
                contactId: contact.id,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
