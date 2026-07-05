import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midterm/main.dart';
import 'package:midterm/screens/home_page_content.dart';
import 'package:midterm/screens/products_page_content.dart';
import 'package:midterm/screens/settings_page_content.dart';

void main() {
  testWidgets('Midterm App navigation and state test', (
    WidgetTester tester,
  ) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // 2. Verify that the initial page is the Home page.
    expect(find.byType(HomePageContent), findsOneWidget);
    expect(find.text('นี่คือหน้าแรก'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('หน้าแรก')),
      findsOneWidget,
    ); // AppBar title

    // 3. Tap the "สินค้า" tab on the bottom navigation bar.
    // Tap the icon instead of the text since the text exists in both bottom navigation bar and appbar title/content sometimes.
    await tester.tap(find.byIcon(Icons.shopping_bag));
    await tester.pumpAndSettle();

    // Verify we are on the Products page.
    expect(find.byType(ProductsPageContent), findsOneWidget);
    expect(find.text('หน้าสินค้า'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('สินค้า')),
      findsOneWidget,
    ); // AppBar title

    // Verify the initial state of the add-to-cart button.
    expect(find.text('เพิ่มสินค้า'), findsOneWidget);
    expect(find.text('เพิ่มสินค้าแล้ว'), findsNothing);

    // 4. Tap the "เพิ่มสินค้า" button.
    await tester.tap(find.text('เพิ่มสินค้า'));
    await tester.pump();

    // Verify the button state changes to "เพิ่มสินค้าแล้ว".
    expect(find.text('เพิ่มสินค้า'), findsNothing);
    expect(find.text('เพิ่มสินค้าแล้ว'), findsOneWidget);

    // 5. Tap the "ตั้งค่า" tab on the bottom navigation bar.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify we are on the Settings page.
    expect(find.byType(SettingsPageContent), findsOneWidget);
    expect(find.text('นี่คือหน้าตั้งค่า'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('ตั้งค่า')),
      findsOneWidget,
    ); // AppBar title
  });
}
