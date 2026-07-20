import 'package:flutter_test/flutter_test.dart';
import 'package:prep_bite/models/user_profile_model.dart';

void main() {
  group('UserProfileModel Unit Tests', () {
    test('fromMap and toMap correctly process UserProfileModel', () {
      final now = DateTime(2026, 7, 20);
      final profile = UserProfileModel(
        uid: 'user_999',
        email: 'chef@prepbite.com',
        displayName: 'Chef John',
        createdAt: now,
      );

      final map = profile.toMap();
      expect(map['uid'], equals('user_999'));
      expect(map['email'], equals('chef@prepbite.com'));
      expect(map['displayName'], equals('Chef John'));

      final fromMapProfile = UserProfileModel.fromMap(map, 'user_999');
      expect(fromMapProfile.uid, equals('user_999'));
      expect(fromMapProfile.email, equals('chef@prepbite.com'));
      expect(fromMapProfile.displayName, equals('Chef John'));
    });
  });
}
