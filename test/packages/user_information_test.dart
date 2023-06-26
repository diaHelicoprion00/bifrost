import 'package:authentication/authentication.dart';
import 'package:user_information_api/user_information_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// A suite of tests to ensure that the UserInformation model works as intended.
  group('User Information Model', () {
    const String userId = "12345";
    const String username = 'mock-man';
    const List<String> majors = ['Egyptology'];
    const List<String> minors = ['Computer Science'];
    const int graduationClass = 2049;
    const String educationYear = 'Sophomore';

    final userInformation = UserInformation(
        id: userId,
        username: username,
        majors: majors,
        minors: minors,
        graduationClass: graduationClass,
        educationYear: educationYear);

    /// test that the UserInformation model stores user information correctly
    test('correctly stores user properties', () {
      expect(userInformation.id, userId);
      expect(userInformation.username, username);
      expect(userInformation.majors, majors);
      expect(userInformation.minors, minors);
      expect(userInformation.graduationClass, graduationClass);
      expect(userInformation.educationYear, educationYear);
    });

    /// test that a unique Id is generated for a missing user information Id
    test('generates unique id', () {
      final userInformation = UserInformation(username: username);
      expect(userInformation.id, isNotEmpty);
    });

    /// A suite of tests to ensure that the copy constructor works as intended
    group('copyWith', () {
      /// test that copyWith creates a correct copy when none of the parameters are present
      test('correctly creates copy when no parameter is present', () {
        expect(userInformation.copyWith(), equals(userInformation));
      });

      /// test that copyWith creates a correct copy when none of the parameters are present
      test('correctly creates copy when some parameters are present', () {
        final copyUser = userInformation.copyWith(id: '42');
        expect(userInformation.username, equals(userInformation.username));
      });

      /// test that copyWith creates a correct copy when all of the parameters are present
      test('correctly creates copy when all parameters are present', () {
        final copyUser = userInformation.copyWith(
            id: userId,
            username: username,
            majors: majors,
            minors: minors,
            graduationClass: graduationClass,
            educationYear: educationYear);
      });
    });
  });
}