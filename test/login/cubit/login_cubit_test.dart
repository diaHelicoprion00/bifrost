import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bifrost/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthentication extends Mock implements Authentication {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(value: invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(value: validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(value: invalidPasswordString);

  const validPasswordString = 't0pS3cret42';
  const validPassword = Password.dirty(value: validPasswordString);

  /// A suite of tests to ensure that the LoginCubit works as intended
  group('LoginCubit', () {
    late Authentication authentication;

    setUp(() {
      authentication = MockAuthentication();
      when(
        () => authentication.logInWithGoogle(),
      ).thenAnswer((_) async {});
      when(
        () => authentication.logInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
    });

    /// test that the Initial State Type is a LoginState
    test('initial State is LoginState', () {
      expect(LoginCubit(authentication).state, const LoginState());
    });

    /// A suite of tests to ensure that an email change event triggers the correct state changes.
    group('emailChanged', () {
      /// Test that the isValid LoginState property is false when an invalid Email is entered
      blocTest<LoginCubit, LoginState>(
          'emits [invalid] when email/password are invalid',
          build: () => LoginCubit(authentication),
          act: (cubit) => cubit.emailChanged(invalidEmailString),
          expect: () => const <LoginState>[
                LoginState(email: invalidEmail, isValid: false)
              ]);

      /// Test that the isValid LoginState property is true when a valid Email is entered.
      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(authentication),
        seed: () => const LoginState(password: validPassword),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => const <LoginState>[
          LoginState(email: validEmail, password: validPassword, isValid: true)
        ],
      );
    });

    /// A suite of tests to ensure the LoginCubit emits the correct states when the password changes
    group('passwordChanged', () {
      /// A test to ensure that the LoginCubit emits a false isValid LoginState property
      /// when the password is invalid
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(authentication),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <LoginState>[
          LoginState(password: invalidPassword, isValid: false)
        ],
      );

      /// A test to ensure that the LoginCubit emits a true isValid LoginState property
      /// when the password and email are valid
      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(authentication),
        seed: () => const LoginState(email: validEmail),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
        ],
      );
    });

    /// A suite of tests to ensure that the logInWithCredentials method works as intended.
    group('logInWithCredentials', () {
      /// test that no logIn method is called when the status is not validated
      /// Should return an empty state
      blocTest<LoginCubit, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginCubit(authentication),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[],
      );

      /// Test that the logInWithEmailAndPassword method is called with the
      /// correct email and password when the Login State has been validated.
      blocTest<LoginCubit, LoginState>(
        'calls logInWithEmailAndPassword with correct email/password',
        build: () => LoginCubit(authentication),
        seed: () => const LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        verify: (_) {
          verify(
            () => authentication.logInWithEmailAndPassword(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      /// Test that two LoginStates are emitted when the LoginState is valid
      /// First State should contain an inProgress status
      /// Second State should contain a success status
      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithEmailAndPassword succeeds',
        build: () => LoginCubit(authentication),
        seed: () => const LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            password: validPassword,
            isValid: true,
          )
        ],
      );

      /// Test that when a LogInWithEmailAndPasswordFailure is thrown, two LoginStates are emitted.
      /// First state has a status of submissionInProgress.
      /// Second state has a status of submissionFailure.
      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails '
        'due to LogInWithEmailAndPasswordFailure',
        setUp: () {
          when(
            () => authentication.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(const LogInWithEmailAndPasswordFailure('oopsie'));
        },
        build: () => LoginCubit(authentication),
        seed: () => const LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'oopsie',
            email: validEmail,
            password: validPassword,
            isValid: true,
          )
        ],
      );

      /// test that before a generic exception is thrown, two LoginStates are emitted.
      /// First state has status of FormzSubmissionStatus.inProgress
      /// Second state has status of FormzSubmissionStatus.failure
      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails due to generic exception',
        setUp: () {
          when(
            () => authentication.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginCubit(authentication),
        seed: () => const LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            password: validPassword,
            isValid: true,
          )
        ],
      );
    });

    /// A suite of tests to ensure that the logInWithGoogle methods works as intended
    group('logInWIthGoogle', (){

      /// test that Authentication.logInWithGoogle() is called once
      blocTest<LoginCubit, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginCubit(authentication),
        act: (cubit) => cubit.logInWithGoogle(),
        verify: (_) {
          verify(() => authentication.logInWithGoogle()).called(1);
        },
      );

      /// test that when logInWithGoogle() succeeds, there are two LoginStates emitted.
      /// First state has the status is FormzSubmissionStatus.inProgress
      /// Second state has the status is FormzSubmissionStatus.success
      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, success] '
            'when logInWithGoogle succeeds',
        build: () => LoginCubit(authentication),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success)
        ],
      );

      /// test that when logInWithGoogle() encounters a LogInWithGoogleFailure exception, two
      /// LoginStates are emitted.
      /// First state has the status: FormzSubmissionStatus.inProgress,
      /// Second state has the status: FormzSubmissionStatus.failure
      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, failure] '
            'when logInWithGoogle fails due to LogInWithGoogleFailure',
        setUp: () {
          when(
                () => authentication.logInWithGoogle(),
          ).thenThrow(const LogInWithGoogleFailure('oops'));
        },
        build: () => LoginCubit(authentication),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'oops',
          )
        ],
      );

      /// Test that when LogInWithGoogle encounters a generic exception, two LoginStates are emitted.
      /// First state has the status: FormzSubmissionStatus.inProgress
      /// Second state has the status: FormzSubmissionStatus.failure
      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, failure] '
            'when logInWithGoogle fails due to generic exception',
        setUp: () {
          when(
                () => authentication.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginCubit(authentication),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure)
        ],
      );
    });
  });

}
