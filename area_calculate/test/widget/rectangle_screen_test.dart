import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:area_calculate/main.dart';

void main() {
  group('Rectangle Screen Widget Tests', () {
    testWidgets('Validation error triggers on empty inputs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byKey(const Key('calculate_button')));
      await tester.pump();

      expect(find.text('กรุณาระบุความกว้าง'), findsOneWidget);
      expect(find.text('กรุณาระบุความยาว/สูง'), findsOneWidget);
    });

    testWidgets('Validation error triggers on invalid values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byKey(const Key('width_field')), 'abc');
      await tester.enterText(find.byKey(const Key('height_field')), '-1');
      await tester.tap(find.byKey(const Key('calculate_button')));
      await tester.pump();

      expect(find.text('กรุณาระบุเป็นตัวเลขเท่านั้น'), findsOneWidget);
      expect(find.text('ค่าต้องมากกว่า 0'), findsOneWidget);
    });

    testWidgets('Calculates area and clears successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final widthFinder = find.byKey(const Key('width_field'));
      final heightFinder = find.byKey(const Key('height_field'));

      await tester.enterText(widthFinder, '12.5');
      await tester.enterText(heightFinder, '8.0');
      await tester.tap(find.byKey(const Key('calculate_button')));
      await tester.pump();

      expect(find.byKey(const Key('result_card')), findsOneWidget);
      expect(find.text('100'), findsOneWidget);

      await tester.tap(find.byKey(const Key('clear_button')));
      await tester.pump();

      expect(find.byKey(const Key('result_card')), findsNothing);
      expect(find.text('12.5'), findsNothing);
      expect(find.text('8.0'), findsNothing);
    });
  });
}
