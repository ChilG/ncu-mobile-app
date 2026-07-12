import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:area_calculate/main.dart';

void main() {
  group('Triangle Screen Widget Tests', () {
    testWidgets('Calculates triangle area correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byKey(const Key('nav_triangle')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('base_field')), '15.0');
      await tester.enterText(find.byKey(const Key('height_field')), '6.0');
      await tester.tap(find.byKey(const Key('calculate_button')));
      await tester.pump();

      expect(find.byKey(const Key('result_card')), findsOneWidget);
      expect(find.text('45'), findsOneWidget);
    });
  });
}
