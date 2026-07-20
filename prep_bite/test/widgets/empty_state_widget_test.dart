import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/widgets/empty_state_widget.dart';

void main() {
  testWidgets('EmptyStateWidget displays title and subtitle correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            title: 'ยังไม่มีสูตรอาหาร',
            subtitle: 'กรุณาเพิ่มสูตรอาหารใหม่',
            icon: Icons.soup_kitchen_outlined,
          ),
        ),
      ),
    );

    expect(find.text('ยังไม่มีสูตรอาหาร'), findsOneWidget);
    expect(find.text('กรุณาเพิ่มสูตรอาหารใหม่'), findsOneWidget);
    expect(find.byIcon(Icons.soup_kitchen_outlined), findsOneWidget);
  });
}
