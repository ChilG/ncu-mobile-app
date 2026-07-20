import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/models/ingredient_model.dart';
import 'package:prep_bite/models/recipe_model.dart';

void main() {
  group('RecipeModel Unit Tests', () {
    test('fromMap and toMap should convert recipe correctly', () {
      final recipe = RecipeModel(
        id: 'recipe_123',
        title: 'ผัดไทยกุ้งสด',
        description: 'เมนูยอดฮิตรสชาติกลมกล่อม',
        imageUrl: 'https://example.com/padthai.jpg',
        category: 'อาหารจานเดียว',
        prepTime: 15,
        cookingTime: 10,
        servings: 2,
        difficulty: 'ปานกลาง',
        ingredients: [
          IngredientModel(name: 'เส้นจันท์', amount: '150 กรัม'),
          IngredientModel(name: 'กุ้งสด', amount: '4 ตัว'),
        ],
        steps: [
          'แช่เส้นจันท์ให้นุ่ม',
          'ผัดซอสผัดไทยและใส่เส้น',
        ],
        createdBy: 'user_456',
        createdAt: DateTime(2026, 1, 1),
      );

      final map = recipe.toMap();
      expect(map['title'], equals('ผัดไทยกุ้งสด'));
      expect(map['category'], equals('อาหารจานเดียว'));
      expect(map['prepTime'], equals(15));
      expect(map['ingredients'].length, equals(2));

      final fromMapRecipe = RecipeModel.fromMap(map, 'recipe_123');
      expect(fromMapRecipe.id, equals('recipe_123'));
      expect(fromMapRecipe.title, equals('ผัดไทยกุ้งสด'));
      expect(fromMapRecipe.ingredients.length, equals(2));
      expect(fromMapRecipe.steps.length, equals(2));
    });

    test('copyWith should produce updated RecipeModel copy', () {
      final recipe = RecipeModel(
        id: '1',
        title: 'แกงจืด',
        description: '',
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

      final updated = recipe.copyWith(title: 'แกงจืดเต้าหู้หมูสับ', prepTime: 10);
      expect(updated.title, equals('แกงจืดเต้าหู้หมูสับ'));
      expect(updated.prepTime, equals(10));
      expect(updated.cookingTime, equals(10));
    });
  });
}
