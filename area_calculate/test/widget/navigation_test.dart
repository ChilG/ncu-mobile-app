import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:area_calculate/main.dart';

void main() {
  group('Navigation Widget Tests', () {
    testWidgets('Switching tabs displays correct screens', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('คำนวณพื้นที่สี่เหลี่ยม'), findsWidgets);
      expect(find.byKey(const Key('width_field')), findsOneWidget);
      expect(find.byKey(const Key('height_field')), findsOneWidget);

      await tester.tap(find.byKey(const Key('nav_triangle')));
      await tester.pumpAndSettle();

      expect(find.text('คำนวณพื้นที่สามเหลี่ยม'), findsWidgets);
      expect(find.byKey(const Key('base_field')), findsOneWidget);
      expect(find.byKey(const Key('height_field')), findsOneWidget);

      await tester.tap(find.byKey(const Key('nav_circle')));
      await tester.pumpAndSettle();

      expect(find.text('คำนวณพื้นที่วงกลม'), findsWidgets);
      expect(find.byKey(const Key('radius_field')), findsOneWidget);
    });
  });
}
