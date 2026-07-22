import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/models/ingredient_model.dart';
import 'package:prep_bite/models/recipe_model.dart';
import 'package:prep_bite/screens/checklist/preparation_checklist_screen.dart';

void main() {
  group('Preparation Checklist Integration Tests', () {
    final sampleRecipe = RecipeModel(
      id: 'test_recipe_1',
      title: 'ผัดไทกุ้งสด',
      description: 'ผัดไทสูตรโบราณ',
      imageUrl: '',
      category: 'อาหารจานเดียว',
      prepTime: 10,
      cookingTime: 15,
      servings: 2,
      difficulty: 'ปานกลาง',
      ingredients: [
        IngredientModel(name: 'เส้นจันทน์', amount: '200 กรัม', preparation: 'แช่น้ำ', isChecked: false),
        IngredientModel(name: 'กุ้งสด', amount: '6 ตัว', preparation: 'แกะเปลือก', isChecked: false),
      ],
      steps: ['ผัดกุ้งสดให้สุก', 'ใส่เส้นและซอสผัดไท'],
      createdBy: 'test_user',
    );

    testWidgets('verify ingredient check, select all, and clear checklist flows',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PreparationChecklistScreen(recipe: sampleRecipe),
        ),
      );

      await tester.pumpAndSettle();

      // Verify title & initial status
      expect(find.text('เตรียมวัตถุดิบ: ผัดไทกุ้งสด'), findsOneWidget);
      expect(find.text('เตรียมแล้ว 0 จาก 2 รายการ'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);

      // Verify ingredients listed
      expect(find.text('เส้นจันทน์'), findsOneWidget);
      expect(find.text('กุ้งสด'), findsOneWidget);

      // Tap 'เลือกทั้งหมด' (Select All)
      final selectAllButton = find.text('เลือกทั้งหมด');
      expect(selectAllButton, findsOneWidget);
      await tester.tap(selectAllButton);
      await tester.pumpAndSettle();

      // Verify dialog appears upon 100% completion
      expect(find.text('เตรียมพร้อมแล้ว!'), findsOneWidget);
      expect(find.text('เตรียมวัตถุดิบครบแล้ว พร้อมเริ่มทำอาหาร!'), findsOneWidget);

      // Dismiss completion dialog by tapping 'ตกลง'
      await tester.tap(find.text('ตกลง'));
      await tester.pumpAndSettle();

      // Verify progress status shows 100%
      expect(find.text('เตรียมแล้ว 2 จาก 2 รายการ'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);

      // Tap 'ล้าง Checklist' (Clear Checklist)
      final clearAllButton = find.text('ล้าง Checklist');
      expect(clearAllButton, findsOneWidget);
      await tester.tap(clearAllButton);
      await tester.pumpAndSettle();

      // Verify progress reset to 0%
      expect(find.text('เตรียมแล้ว 0 จาก 2 รายการ'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
    });
  });
}
