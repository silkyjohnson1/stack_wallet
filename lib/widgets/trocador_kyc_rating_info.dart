import 'package:flutter/material.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/exchange/trocador/trocador_kyc_icon.dart';
import 'package:stackwallet/widgets/exchange/trocador/trocador_rating_type_enum.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

class TrocadorKYCRatingInfo extends StatelessWidget {
  const TrocadorKYCRatingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final small = MediaQuery.of(context).size.width <= 500;

    return ConditionalParent(
      condition: !small,
      builder: (child) => DesktopDialog(
        maxHeight: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Trocador KYC Rating",
                    style: STextStyles.desktopH3(context),
                  ),
                ),
                const DesktopDialogCloseButton(),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: child,
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  const Spacer(),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      label: "Ok",
                      buttonHeight: ButtonHeight.l,
                      onPressed: Navigator.of(context).pop,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      child: ConditionalParent(
        condition: small,
        builder: (child) {
          return StackDialogBase(
            child: child,
          );
        },
        child: Column(
          children: [
            if (small)
              Text(
                "Trocador KYC Rating",
                style: STextStyles.pageTitleH2(context),
              ),
            if (small)
              const SizedBox(
                height: 16,
              ),
            const _Rating(
              kycType: TrocadorKYCType.a,
              text: "Never asks for user verification.",
            ),
            const SizedBox(
              height: 16,
            ),
            const _Rating(
              kycType: TrocadorKYCType.b,
              text: "Rarely asks for verification. Refunds if refused.",
            ),
            const SizedBox(
              height: 16,
            ),
            const _Rating(
              kycType: TrocadorKYCType.c,
              text:
                  "Rarely asks for verification. Refunds if refused, unless a "
                  "legal order prevents it.",
            ),
            const SizedBox(
              height: 16,
            ),
            const _Rating(
              kycType: TrocadorKYCType.d,
              text:
                  "Rarely asks for verification. In case of refusal may block "
                  "funds indefinitely without a legal order.",
            ),
            if (small)
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: SecondaryButton(
                        label: "Close",
                        onPressed: Navigator.of(context).pop,
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({
    Key? key,
    required this.kycType,
    required this.text,
  }) : super(key: key);

  final TrocadorKYCType kycType;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrocadorKYCIcon(
          kycType: kycType,
          width: 20,
          height: 20,
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Text(
            text,
            style: STextStyles.subtitle(context),
          ),
        ),
      ],
    );
  }
}
