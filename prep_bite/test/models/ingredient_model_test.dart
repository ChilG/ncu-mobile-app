import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/models/ingredient_model.dart';

void main() {
  group('IngredientModel Unit Tests', () {
    test('toMap and fromMap should serialize and deserialize correctly', () {
      final ingredient = IngredientModel(
        name: 'ข้าวสวย',
        amount: '1 ถ้วย',
        preparation: 'พักให้เย็น',
        isChecked: true,
      );

      final map = ingredient.toMap();
      expect(map['name'], equals('ข้าวสวย'));
      expect(map['amount'], equals('1 ถ้วย'));
      expect(map['preparation'], equals('พักให้เย็น'));
      expect(map['isChecked'], isTrue);

      final deserialized = IngredientModel.fromMap(map);
      expect(deserialized.name, equals('ข้าวสวย'));
      expect(deserialized.amount, equals('1 ถ้วย'));
      expect(deserialized.preparation, equals('พักให้เย็น'));
      expect(deserialized.isChecked, isTrue);
    });

    test('copyWith should update specified fields', () {
      final ingredient = IngredientModel(
        name: 'ไข่ไก่',
        amount: '2 ฟอง',
      );

      final updated = ingredient.copyWith(
        isChecked: true,
        preparation: 'ตอกใส่ถ้วย',
      );

      expect(updated.name, equals('ไข่ไก่'));
      expect(updated.amount, equals('2 ฟอง'));
      expect(updated.preparation, equals('ตอกใส่ถ้วย'));
      expect(updated.isChecked, isTrue);
    });
  });
}
