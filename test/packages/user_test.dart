import 'package:authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// A suite of tests to ensure that the [User] model works as intended.
  group('User', () {
    const userId = 'mock-id';
    const userName = 'mock-name';
    const userEmail = 'mockname@mockmail.com';

    /// A test to ensure that the User model correctly stores user properties.
    test('correctly stores user properties', () {
      const user = User(id: userId, name: userName, email: userEmail);
      expect(user.id, userId);
      expect(user.name, userName);
      expect(user.email, userEmail);
    });

    /// A test to ensure that two User objects are correctly compared.
    test('correctly compares equal User objects', () {
      expect(const User(id: userId, name: userName, email: userEmail),
          equals(const User(id: userId, name: userName, email: userEmail)));
    });

    /// A test to ensure that the isEmpty method works correctly for an empty user.
    test('isEmpty returns true for an empty user', () {
      expect(User.empty.isEmpty, isTrue);
    });

    /// A test to ensure that the isEmpty method works correctly for a non-empty user.
    test('isEmpty returns false for a non-empty user', () {
      const user = User(id: userId, name: userName, email: userEmail);
      expect(user.isEmpty, isFalse);
    });
  });
}
