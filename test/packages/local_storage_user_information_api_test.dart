import 'dart:convert';

import 'package:user_information_api/user_information_api.dart';
import 'package:local_storage_user_information_api/local_storage_user_information_api.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  /// A suite of tests to ensure that the Local Storage implementation of
  /// UserInformationApi
  group('LocalStorageUserInformationAPI', () {
    late SharedPreferences plugin;

    const String userId = "12345";
    const String username = 'mock-man';
    const List<String> majors = ['Egyptology'];
    const List<String> minors = ['Computer Science'];
    const int graduationClass = 2049;
    const String educationYear = 'Sophomore';

    final storedUserInformation = UserInformation(
        id: userId,
        username: username,
        majors: majors,
        minors: minors,
        graduationClass: graduationClass,
        educationYear: educationYear);

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any()))
          .thenReturn(json.encode(storedUserInformation));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    /// Returns a [localStorageUserInformationApi] object with an initialized
    /// Shared Preferences plugin;
    localStorageUserInformationApi createSubject() {
      return localStorageUserInformationApi(plugin: plugin);
    }

    /// A suite of tests to ensure that the [localStorageUserInformationApi] constructor works as intended.
    group('constructor', () {
      /// test that the constructor successfully creates an object
      test('initializes properly', () {
        expect(createSubject, returnsNormally);
      });

      /// A suite of tests to ensure that the constructor initializes the UserInformation stream
      group('initializes the UserInformation stream', () {
        /// test that the UserInformation stream is successfully
        /// initialized (with [UserInformation].empty) when there is no existing User Information
        test('with empty UserInformation object when no UserInformation exists',
            () {
          when(() => plugin.getString(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.getUserInformation(), emits(UserInformation.empty()));
          verify(
            () => plugin.getString(
              localStorageUserInformationApi.kUserInformationKey,
            ),
          ).called(1);
        });

        /// test that the UserInformation stream is successfully
        /// initialized with the stored [UserInformation] object when there is an existing User Information
        test('with existing UserInformation if present', () {
          final subject = createSubject();

          expect(subject.getUserInformation(), emits(storedUserInformation));
          verify(
            () => plugin.getString(
              localStorageUserInformationApi.kUserInformationKey,
            ),
          ).called(1);
        });
      });
    });

    /// A suite of tests to ensure that the getUserInformation method works as intended.
    group('getUserInformation', () {
      test('returns a stream of current UserInformation object', () {
        expect(
            createSubject().getUserInformation(), emits(storedUserInformation));
      });
    });

    /// A suite of tests to ensure that the setUserInformation method works as intended.
    group('setUserInformation', () {
      /// test that setUserInformation saves new User Information
      test('saves new User Information', () {
        when(() => plugin.getString(any())).thenReturn(null);

        final subject = createSubject();
        final newUserInformation = UserInformation(
            id: '0000', username: 'mock-man-2', majors: majors, minors: minors);

        expect(subject.setUserInformation(newUserInformation), completes);
        expect(subject.getUserInformation(), emits(newUserInformation));

        verify(
          () => plugin.setString(
            localStorageUserInformationApi.kUserInformationKey,
            json.encode(newUserInformation),
          ),
        ).called(1);
      });

      /// test that setUserInformation throws [UserInformationNotFoundException] when the new User Information doesn't match the
      /// existing User Information id
      test(
          'throws UserInformationNotFoundException when UserInformation ids do not match',
          () {
        final newUserInformation =
            UserInformation(id: null, username: 'mock-man-2');

        final subject = createSubject();

        expect(() => subject.setUserInformation(newUserInformation),
            throwsA(isA<UserInformationNotFoundException>()));
       expect(subject.getUserInformation(), emits(storedUserInformation));
      });

      /// test that setUserInformation updates and saves new User Information when it matches
      /// existing User Information id
      test('updates existing User Information', () {
        final subject = createSubject();
        final newUserInformation = UserInformation(
            id: userId, username: 'mock-man-2', majors: majors, minors: minors);

        expect(subject.setUserInformation(newUserInformation), completes);
        expect(subject.getUserInformation(), emits(newUserInformation));

        verify(
          () => plugin.setString(
            localStorageUserInformationApi.kUserInformationKey,
            json.encode(newUserInformation),
          ),
        ).called(1);
      });
    });

    /// A suite of tests to ensure that the deleteUserInformation method works as intended.
    group('deleteUserInformation', () {
      /// test that deleteUserInformation returns UserInformation.empty when there is no  User Information
      test('deletes null User Information', () {
        when(() => plugin.getString(any())).thenReturn(null);

        final subject = createSubject();

        expect(subject.deleteUserInformation('test'), completes);
        expect(subject.getUserInformation(), emits(UserInformation.empty()));

      });

      /// test that setUserInformation throws [UserInformationNotFoundException] when the new User Information doesn't match the
      /// existing User Information id
      test(
          'throws UserInformationNotFoundException when UserInformation ids do not match',
              () {

            final subject = createSubject();

            expect(() => subject.deleteUserInformation('test'),
                throwsA(isA<UserInformationNotFoundException>()));
            expect(subject.getUserInformation(), emits(storedUserInformation));
          });

      /// test that setUserInformation updates and saves new User Information when it matches
      /// existing User Information id
      test('deletes existing User Information', () {
        final subject = createSubject();

        expect(subject.deleteUserInformation(userId), completes);
        expect(subject.getUserInformation(), emits(UserInformation.empty()));
      });
    });
  });
}
