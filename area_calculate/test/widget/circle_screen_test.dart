import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:area_calculate/main.dart';

void main() {
  group('Circle Screen Widget Tests', () {
    testWidgets('Calculates circle area correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byKey(const Key('nav_circle')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('radius_field')), '10.0');
      await tester.tap(find.byKey(const Key('calculate_button')));
      await tester.pump();

      expect(find.byKey(const Key('result_card')), findsOneWidget);
      expect(find.textContaining('314.159'), findsOneWidget);
    });
  });
}
