import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/models/ingredient_model.dart';
import 'package:prep_bite/widgets/ingredient_check_tile.dart';

void main() {
  testWidgets('IngredientCheckTile renders name, amount, preparation and triggers callback on check',
      (WidgetTester tester) async {
    bool isCheckedValue = false;

    final ingredient = IngredientModel(
      name: 'กระเทียม',
      amount: '1 ช้อนโต๊ะ',
      preparation: 'สับละเอียด',
      isChecked: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientCheckTile(
            ingredient: ingredient,
            onChanged: (val) {
              isCheckedValue = val ?? false;
            },
          ),
        ),
      ),
    );

    expect(find.text('กระเทียม'), findsOneWidget);
    expect(find.text('1 ช้อนโต๊ะ'), findsOneWidget);
    expect(find.text('(สับละเอียด)'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(isCheckedValue, isTrue);
  });
}
