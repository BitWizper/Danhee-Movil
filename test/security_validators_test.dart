import 'package:danhee_movil/utils/security_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecurityValidators', () {
    test('accepts a valid email and rejects malformed addresses', () {
      expect(SecurityValidators.validateEmail('person@example.com'), isNull);
      expect(
        SecurityValidators.validateEmail('person..name@example.com'),
        isNotNull,
      );
      expect(SecurityValidators.validateEmail('person@localhost'), isNotNull);
      expect(
        SecurityValidators.validateEmail(' person@example.com '),
        isNotNull,
      );
    });

    test('requires a complex new password and matching confirmation', () {
      expect(SecurityValidators.validateNewPassword('Short1!'), isNotNull);
      expect(
        SecurityValidators.validateNewPassword('GoodStrongPass9!'),
        isNull,
      );
      expect(
        SecurityValidators.validatePasswordConfirmation(
          'GoodStrongPass9?',
          'GoodStrongPass9!',
        ),
        isNotNull,
      );
      expect(
        SecurityValidators.validatePasswordConfirmation(
          'GoodStrongPass9!',
          'GoodStrongPass9!',
        ),
        isNull,
      );
    });
  });
}
