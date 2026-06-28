import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:button_navigation_app/main.dart';

void main() {
  testWidgets('Verify presence of buttons and correct navigation flow', (WidgetTester tester) async {
    // 1. Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify HomeScreen elements are present
    expect(find.text('Flutter Buttons Demo'), findsOneWidget);
    expect(find.text('Open Text Page'), findsOneWidget);
    expect(find.text('Open Outlined Page'), findsOneWidget);
    expect(find.text('Open ElevatedButton Page'), findsOneWidget);

    // 2. Test TextButton Navigation to TextPage
    await tester.tap(find.text('Open Text Page'));
    await tester.pumpAndSettle(); // Wait for navigation transition to finish

    // Verify TextPage is displayed
    expect(find.text('Text Button Page'), findsOneWidget);
    expect(find.text('This is the page opened by TextButton!'), findsOneWidget);
    
    // Tap 'Go Back' on TextPage
    await tester.tap(find.widgetWithText(TextButton, 'Go Back'));
    await tester.pumpAndSettle(); // Wait for navigation transition back

    // Verify we are back on HomeScreen
    expect(find.text('Flutter Buttons Demo'), findsOneWidget);

    // 3. Test OutlinedButton Navigation to OutlinedPage
    await tester.tap(find.text('Open Outlined Page'));
    await tester.pumpAndSettle();

    // Verify OutlinedPage is displayed
    expect(find.text('Outlined Button Page'), findsOneWidget);
    expect(find.text('This is the page opened by OutlinedButton!'), findsOneWidget);

    // Tap 'Go Back' on OutlinedPage
    await tester.tap(find.widgetWithText(OutlinedButton, 'Go Back'));
    await tester.pumpAndSettle();

    // Verify we are back on HomeScreen
    expect(find.text('Flutter Buttons Demo'), findsOneWidget);

    // 4. Test ElevatedButton Navigation to ElevatedPage
    await tester.tap(find.text('Open ElevatedButton Page'));
    await tester.pumpAndSettle();

    // Verify ElevatedPage is displayed
    expect(find.text('Elevated Button Page'), findsOneWidget);
    expect(find.text('This is the page opened by ElevatedButton!'), findsOneWidget);

    // Tap 'Go Back' on ElevatedPage
    await tester.tap(find.widgetWithText(ElevatedButton, 'Go Back'));
    await tester.pumpAndSettle();

    // Verify we are back on HomeScreen
    expect(find.text('Flutter Buttons Demo'), findsOneWidget);
  });
}
