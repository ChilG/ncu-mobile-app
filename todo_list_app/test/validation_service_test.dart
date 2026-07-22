import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/validation_service.dart';

void main() {
  group('ValidationService Unit Tests', () {
    final validationService = ValidationService();

    test('Test Case 1: returns true for a valid non-empty string', () {
      final result = validationService.isValidString('Hello World');
      expect(result, isTrue);
    });

    test('Test Case 2: returns false for empty or null strings', () {
      final resultEmpty = validationService.isValidString('');
      final resultNull = validationService.isValidString(null);
      final resultWhitespace = validationService.isValidString('   ');

      expect(resultEmpty, isFalse);
      expect(resultNull, isFalse);
      expect(resultWhitespace, isFalse);
    });
  });
}
