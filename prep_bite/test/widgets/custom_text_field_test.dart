import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/widgets/custom_text_field.dart';

void main() {
  testWidgets('CustomTextField renders label, hint, and responds to input',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            labelText: 'ชื่อวัตถุดิบ',
            hintText: 'กรอกชื่อวัตถุดิบที่นี่',
            prefixIcon: Icons.shopping_basket,
          ),
        ),
      ),
    );

    expect(find.text('ชื่อวัตถุดิบ'), findsOneWidget);
    expect(find.text('กรอกชื่อวัตถุดิบที่นี่'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_basket), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'พริกสด');
    expect(controller.text, equals('พริกสด'));
  });
}
