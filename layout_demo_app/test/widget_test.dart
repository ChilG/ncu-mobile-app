// This is a basic Flutter widget test for the Layout Demo app.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:layout_demo_app/main.dart';

void main() {
  testWidgets('Layout Demo UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title 'Layout Demo' is present in the AppBar.
    expect(find.text('Layout Demo'), findsOneWidget);

    // Verify that elements from Example 1 (Container and Center) are present.
    expect(find.text('Centered Box'), findsOneWidget);

    // Verify that elements from Example 2 (Row and Column with icons) are present.
    expect(find.text('Rating'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);

    // Verify that elements from Example 3 (Card) are present.
    expect(find.text('Title of the Card'), findsOneWidget);
    expect(find.text('Learn More'), findsOneWidget);
  });
}
