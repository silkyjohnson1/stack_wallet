import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackwallet/models/isar/sw_theme.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/themes/defaults/dark.dart';
import 'package:stackwallet/widgets/shake/shake.dart';

void main() {
  testWidgets("Widget build", (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
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
        home: Material(
          child: Shake(
              animationRange: 10,
              controller: ShakeController(),
              animationDuration: const Duration(milliseconds: 200),
              child: Column(
                children: const [
                  Center(
                    child: Text("Enter Pin"),
                  )
                ],
              )),
        ),
      ),
    );

    expect(find.byType(Shake), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });
}
