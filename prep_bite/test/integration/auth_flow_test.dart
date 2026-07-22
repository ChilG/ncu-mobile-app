import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/screens/auth/login_screen.dart';

void main() {
  group('Authentication Flow Integration Tests', () {
    testWidgets('verify login form input validation and navigation to register screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Login Screen Header
      expect(find.text('PrepBite'), findsOneWidget);
      expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
      expect(find.text('สมัครสมาชิก'), findsOneWidget);

      // Tap Login button with empty fields to trigger validation
      final loginButton = find.widgetWithText(ElevatedButton, 'เข้าสู่ระบบ');
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify validation error messages
      expect(find.text('กรุณากรอกอีเมล'), findsOneWidget);
      expect(find.text('กรุณากรอกรหัสผ่าน'), findsOneWidget);

      // Enter invalid email format
      final emailField = find.byType(TextField).at(0);
      await tester.enterText(emailField, 'invalid-email-format');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('รูปแบบอีเมลไม่ถูกต้อง'), findsOneWidget);

      // Navigate to Register Screen
      final registerLink = find.text('สมัครสมาชิก');
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      // Verify Register Screen view
      expect(find.text('สร้างบัญชีผู้ใช้ใหม่'), findsOneWidget);
      expect(find.text('ชื่อผู้ใช้ (Display Name)'), findsOneWidget);
      expect(find.text('ยืนยันรหัสผ่าน'), findsOneWidget);
    });
  });
}
