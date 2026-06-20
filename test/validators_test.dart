import 'package:authentication_notes_manager/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppValidators', () {
    test('email validator checks format', () {
      expect(AppValidators.email(''), isNotNull);
      expect(AppValidators.email('bad-email'), isNotNull);
      expect(AppValidators.email('good@mail.com'), isNull);
    });

    test('password validator checks minimum length', () {
      expect(AppValidators.password('123'), isNotNull);
      expect(AppValidators.password('123456'), isNull);
    });

    test('confirm password validator checks match', () {
      expect(AppValidators.confirmPassword('123456', 'abcdef'), isNotNull);
      expect(AppValidators.confirmPassword('123456', '123456'), isNull);
    });
  });
}
