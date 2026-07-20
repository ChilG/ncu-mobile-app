import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail should return error for empty or invalid email', () {
      expect(Validators.validateEmail(''), equals('กรุณากรอกอีเมล'));
      expect(Validators.validateEmail('   '), equals('กรุณากรอกอีเมล'));
      expect(Validators.validateEmail('invalid-email'), equals('รูปแบบอีเมลไม่ถูกต้อง'));
      expect(Validators.validateEmail('user@domain'), equals('รูปแบบอีเมลไม่ถูกต้อง'));
      expect(Validators.validateEmail('user@domain.com'), isNull);
    });

    test('validatePassword should return error for short password', () {
      expect(Validators.validatePassword(''), equals('กรุณากรอกรหัสผ่าน'));
      expect(Validators.validatePassword('12345'), equals('รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร'));
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('securePassword123'), isNull);
    });

    test('validateRequired should validate non-empty text', () {
      expect(Validators.validateRequired('', 'ชื่อเมนู'), equals('กรุณากรอกชื่อเมนู'));
      expect(Validators.validateRequired('   ', 'คำอธิบาย'), equals('กรุณากรอกคำอธิบาย'));
      expect(Validators.validateRequired('ต้มยำกุ้ง', 'ชื่อเมนู'), isNull);
    });

    test('validateNumber should validate integer inputs', () {
      expect(Validators.validateNumber('', 'เวลาเตรียม'), equals('กรุณากรอกเวลาเตรียม'));
      expect(Validators.validateNumber('abc', 'เวลาเตรียม'), equals('เวลาเตรียม ต้องเป็นตัวเลขเท่านั้น'));
      expect(Validators.validateNumber('15', 'เวลาเตรียม'), isNull);
    });
  });
}
