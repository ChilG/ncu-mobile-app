import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/models/recipe_model.dart';
import 'package:prep_bite/widgets/recipe_card.dart';

void main() {
  testWidgets('RecipeCard renders title, category and responds to taps',
      (WidgetTester tester) async {
    bool isTapped = false;
    bool isFavTapped = false;

    final recipe = RecipeModel(
      id: 'r_1',
      title: 'ข้าวผัดกระเพราหมูสับ',
      description: 'รสชาติเผ็ดร้อน หอมกลิ่นกระเพรา',
      imageUrl: '',
      category: 'อาหารจานเดียว',
      prepTime: 5,
      cookingTime: 10,
      servings: 1,
      difficulty: 'ง่าย',
      ingredients: [],
      steps: [],
      createdBy: 'user_1',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeCard(
            recipe: recipe,
            isFavorite: false,
            onTap: () => isTapped = true,
            onFavoriteTap: () => isFavTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('ข้าวผัดกระเพราหมูสับ'), findsOneWidget);
    expect(find.text('อาหารจานเดียว'), findsOneWidget);
    expect(find.text('รสชาติเผ็ดร้อน หอมกลิ่นกระเพรา'), findsOneWidget);
    expect(find.text('15 นาที'), findsOneWidget);
    expect(find.text('ง่าย'), findsOneWidget);

    await tester.tap(find.byType(RecipeCard));
    expect(isTapped, isTrue);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    expect(isFavTapped, isTrue);
  });
}
