import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/stack_colors.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/text_styles.dart';

import 'package:basic_utils/basic_utils.dart';

class OpenAliasBottomSheet extends ConsumerStatefulWidget {
  const OpenAliasBottomSheet({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  final Null Function(String) onSelected;

  @override
  ConsumerState<OpenAliasBottomSheet> createState() =>
      _OpenAliasBottomSheetState();
}

class _OpenAliasBottomSheetState extends ConsumerState<OpenAliasBottomSheet> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).extension<StackColors>()!.popupBG,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldDefaultBG,
                      borderRadius: BorderRadius.circular(
                        Constants.size.circularBorderRadius,
                      ),
                    ),
                    width: 60,
                    height: 4,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Text(
                  'OpenAlias Address',
                  style: STextStyles.smallMed12(context),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 480,
                      minHeight: 70,
                    ),
                    child: TextButton(
                      style: Theme.of(context)
                          .extension<StackColors>()!
                          .getPrimaryEnabledButtonStyle(context),
                      onPressed: () async {
                        String text = textEditingController.text.trim().replaceAll("@", ".");
                        List<RRecord>? result = await DnsUtils.lookupRecord(text, RRecordType.TXT);
                        String address = "";
                        if (result != null && result.isNotEmpty) {
                          for (RRecord record in result) {
                            if (record.data.startsWith("oa1:xmr")) {
                              List<String> datas = record.data.split(" ");
                              for (String data in datas) {
                                if (data.startsWith("recipient_address=")) {
                                  address = data.substring("recipient_address=".length).replaceAll(";", "");
                                  break;
                                }
                              }
                              break;
                            }
                          }
                        }
                        widget.onSelected(address!);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Enter",
                        style: STextStyles.button(context),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


