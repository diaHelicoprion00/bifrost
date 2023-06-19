// ignore_for_file: prefer_const_constructors
import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bifrost/sign_up/sign_up.dart';
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

  const validPasswordString = 't0pS3cret1234';
  const validPassword = Password.dirty(value: validPasswordString);

  const invalidConfirmedPasswordString = 'invalid';
  const invalidConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: invalidConfirmedPasswordString,
  );

  const validConfirmedPasswordString = 't0pS3cret1234';
  const validConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: validConfirmedPasswordString,
  );

  /// A suite of tests to ensure that the SignUpCubit works as intended
  group('SignUpCubit', () {
    late Authentication authentication;

    /// Initialize the Authentication Repository and set up response to authentication.signUp()
    setUp(() {
      authentication = MockAuthentication();
      when(
        () => authentication.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
    });

    /// test that SignUpState() is the state of SignUpCubit.
    test('initial state is SignUpState', () {
      expect(SignUpCubit(authentication).state, SignUpState());
    });

    /// A suite of tests to ensure that the emailChanged returns the
    /// appropriate states when the email value changes.
    group('emailChanged', () {
      /// test that an invalidEmail state is returned when an invalid email is entered.
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => SignUpCubit(authentication),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => const <SignUpState>[SignUpState(email: invalidEmail)],
      );

      /// test that a true isValid state is returned when a valid email is entered.
      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => SignUpCubit(authentication),
        seed: () => SignUpState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
        ],
      );
    });

    /// A suite of tests to ensure that the passwordChanged() method returns the
    /// correct states when the password value changes
    group("passwordChanged", () {
      /// test that an invalid SignUpState is emitted when an invalid password is
      /// entered
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => SignUpCubit(authentication),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            confirmedPassword: ConfirmedPassword.dirty(
              password: invalidPasswordString,
            ),
            password: invalidPassword,
          ),
        ],
      );

      /// test that a valid SignUpState is emitted when a valid password is entered
      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => SignUpCubit(authentication),
        seed: () => SignUpState(
          email: validEmail,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
        ],
      );

      /// test that a valid SignUpState is emitted when a valid confirmedPassword is entered
      /// before a valid Password
      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when confirmedPasswordChanged is called first and then '
        'passwordChanged is called',
        build: () => SignUpCubit(authentication),
        seed: () => SignUpState(
          email: validEmail,
        ),
        act: (cubit) => cubit
          ..confirmedPasswordChanged(validConfirmedPasswordString)
          ..passwordChanged(validPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            confirmedPassword: validConfirmedPassword,
          ),
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
        ],
      );
    });

    /// A suite of tests to ensure that the confirmedPasswordChanged() method emits the
    /// correct states when the confirmedPasswordChanges.
    group('confirmedPasswordChanged', () {
      /// test that an invalid SignUpState is emitted when an invalid confirmedPassword is entered
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => SignUpCubit(authentication),
        act: (cubit) {
          cubit.confirmedPasswordChanged(invalidConfirmedPasswordString);
        },
        expect: () => const <SignUpState>[
          SignUpState(confirmedPassword: invalidConfirmedPassword),
        ],
      );

      /// test that a valid SignUpState is emitted when a valid confirmedPassword is entered
      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => SignUpCubit(authentication),
        seed: () => SignUpState(email: validEmail, password: validPassword),
        act: (cubit) => cubit.confirmedPasswordChanged(
          validConfirmedPasswordString,
        ),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
        ],
      );

      /// test that a valid SignUpState is emitted when passwordChanged() is
      /// called before confirmedPasswordChanged().
      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when passwordChanged is called first and then '
        'confirmedPasswordChanged is called',
        build: () => SignUpCubit(authentication),
        seed: () => SignUpState(email: validEmail),
        act: (cubit) => cubit
          ..passwordChanged(validPasswordString)
          ..confirmedPasswordChanged(validConfirmedPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPasswordString,
            ),
          ),
          SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
        ],
      );

      /// A suite of tests to ensure that SignUpFormSubmitted() works as intended.
      group('signUpFormSubmitted', () {
        /// test that nothing is returned when the signUpFormButton is pressed
        /// but the form hasn't been validated yet.
        blocTest<SignUpCubit, SignUpState>(
          'does nothing when status is not validated',
          build: () => SignUpCubit(authentication),
          act: (cubit) => cubit.signUpFormSubmitted(),
          expect: () => const <SignUpState>[],
        );

        /// test that Authentication.signUp() is called once when the
        /// SignUp Credentials are valid.
        blocTest<SignUpCubit, SignUpState>(
          'calls signUp with correct email/password/confirmedPassword',
          build: () => SignUpCubit(authentication),
          seed: () => SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
          act: (cubit) => cubit.signUpFormSubmitted(),
          verify: (_) {
            verify(
              () => authentication.signUp(
                email: validEmailString,
                password: validPasswordString,
              ),
            ).called(1);
          },
        );

        /// test that the SignUpCubit emits two states when the SignUpForm is valid and has been submitted.
        /// The first state has status FormzSubmissionStatus.inProgress,
        /// the second state has status FormzSubmissionStatus.success.
        blocTest<SignUpCubit, SignUpState>(
          'emits [inProgress, success] '
          'when signUp succeeds',
          build: () => SignUpCubit(authentication),
          seed: () => SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
          act: (cubit) => cubit.signUpFormSubmitted(),
          expect: () => const <SignUpState>[
            SignUpState(
              status: FormzSubmissionStatus.inProgress,
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              isValid: true,
            ),
            SignUpState(
              status: FormzSubmissionStatus.success,
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              isValid: true,
            )
          ],
        );

        /// test that two states are emitted when the SignUpForm has been submitted and there is
        /// a SignUpWithEmailAndPasswordFailure.
        /// First state has the status: FormzSubmissionStatus.inProgress
        /// Second state has the status: FormzSubmissionStatus.failure
        blocTest<SignUpCubit, SignUpState>(
          'emits [inProgress, failure] '
          'when signUp fails due to SignUpWithEmailAndPasswordFailure',
          setUp: () {
            when(
              () => authentication.signUp(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenThrow(SignUpWithEmailAndPasswordFailure('oops'));
          },
          build: () => SignUpCubit(authentication),
          seed: () => SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
          act: (cubit) => cubit.signUpFormSubmitted(),
          expect: () => const <SignUpState>[
            SignUpState(
              status: FormzSubmissionStatus.inProgress,
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              isValid: true,
            ),
            SignUpState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'oops',
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              isValid: true,
            )
          ],
        );

        /// test that two SignUpStates are returned when the SignUpForm has been submitted and
        /// there is a generic Exception.
        /// First state has the status: FormzSubmissionStatus.inProgress
        /// Second state has the status: FormzSubmissionStatus.failure
        blocTest<SignUpCubit, SignUpState>(
          'emits [inProgress, failure] '
          'when signUp fails due to generic exception',
          setUp: () {
            when(
              () => authentication.signUp(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenThrow(Exception('oops'));
          },
          build: () => SignUpCubit(authentication),
          seed: () => SignUpState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            isValid: true,
          ),
          act: (cubit) => cubit.signUpFormSubmitted(),
          expect: () => const <SignUpState>[
            SignUpState(
              status: FormzSubmissionStatus.inProgress,
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              isValid: true,
            ),
            SignUpState(
              status: FormzSubmissionStatus.failure,
              email: validEmail,
              password: validPassword,
              confirmedPassword: validConfirmedPassword,
              isValid: true,
            )
          ],
        );
      });
    });
  });
}
