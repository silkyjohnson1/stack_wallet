import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackwallet/models/isar/sw_theme.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/themes/defaults/dark.dart';
import 'package:stackwallet/widgets/custom_buttons/favorite_toggle.dart';

void main() {
  testWidgets("Test widget build", (widgetTester) async {
    final key = UniqueKey();

    await widgetTester.pumpWidget(
      ProviderScope(
        overrides: [],
        child: MaterialApp(
          theme: ThemeData(
            extensions: [
              StackColors.fromStackColorTheme(
                StackTheme.fromJson(
                  json: darkJson,
                  applicationThemesDirectoryPath: "",
                ),
              ),
            ],
          ),
          home: FavoriteToggle(
            onChanged: null,
            key: key,
          ),
        ),
      ),
    );

    expect(find.byType(FavoriteToggle), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
