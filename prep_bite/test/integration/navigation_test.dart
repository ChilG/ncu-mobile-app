import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/screens/navigation/main_navigation_screen.dart';

void main() {
  group('Main Navigation Integration Tests', () {
    testWidgets('verify navigation between tabs (Home, Favorites, Add Recipe, Profile)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigationScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify bottom navigation bar is present
      expect(find.byType(NavigationBar), findsOneWidget);

      // Verify initial tab is Home (หน้าแรก)
      expect(find.text('หน้าแรก'), findsWidgets);

      // Tap Favorites tab (รายการโปรด)
      final favoritesTab = find.text('รายการโปรด');
      expect(favoritesTab, findsOneWidget);
      await tester.tap(favoritesTab);
      await tester.pumpAndSettle();

      // Verify Favorites screen active
      expect(find.text('รายการโปรด'), findsWidgets);

      // Tap Add Recipe tab (เพิ่มสูตร)
      final addRecipeTab = find.text('เพิ่มสูตร');
      expect(addRecipeTab, findsOneWidget);
      await tester.tap(addRecipeTab);
      await tester.pumpAndSettle();

      // Verify Add Recipe screen active
      expect(find.text('เพิ่มสูตรอาหารใหม่'), findsOneWidget);

      // Tap Profile tab (โปรไฟล์)
      final profileTab = find.text('โปรไฟล์');
      expect(profileTab, findsOneWidget);
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Verify Profile screen active (contains header 'โปรไฟล์ผู้ใช้งาน')
      expect(find.text('โปรไฟล์ผู้ใช้งาน'), findsOneWidget);

      // Navigate back to Home tab
      final homeTab = find.text('หน้าแรก');
      await tester.tap(homeTab);
      await tester.pumpAndSettle();
    });
  });
}
