import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bifrost/login/login.dart';
import 'package:bifrost/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements Authentication {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements Password {}

void main() {
  const loginButtonKey = Key('loginForm_continue_raisedButton');
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin_raisedButton');
  const emailInputKey = Key('loginForm_emailInput_textField');
  const passwordInputKey = Key('loginForm_passwordInput_textField');
  const createAccountButtonKey = Key('loginForm_createAccount_flatButton');

  const testEmail = 'test@gmail.com';
  const testPassword = 'testP@ssw0rd1';

  group('LoginForm', () {
    late LoginCubit loginCubit;

    /// Initialize LoginCubit, and setUp mock responses for LoginCubit state and LoginCubit methods
    setUp(() {
      loginCubit = MockLoginCubit();
      when(() => loginCubit.state).thenReturn(const LoginState());
      when(() => loginCubit.logInWithGoogle()).thenAnswer((_) async {});
      when(() => loginCubit.logInWithCredentials()).thenAnswer((_) async {});
    });

    /// A suite of tests to ensure that certain methods are called on the LoginForm
    group('calls', () {
      /// test that LoginCubit.emailChanged() is called once when the email changes on LoginForm
      testWidgets('emailChanged when email changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => loginCubit.emailChanged(testEmail)).called(1);
      });

      /// test that LoginCubit.passwordChanged() is called once when the password changes on LoginForm
      testWidgets('passwordChanged when password changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(() => loginCubit.passwordChanged(testPassword)).called(1);
      });

      /// test that LoginCubit.logInWithCredentials() is called when the login button
      /// is pressed on LoginForm
      testWidgets('logInWithCredentials when login button is pressed',
          (tester) async {
        when(() => loginCubit.state).thenReturn(
          const LoginState(isValid: true),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(loginButtonKey));
        verify(() => loginCubit.logInWithCredentials()).called(1);
      });

      /// test that LoginCubit.logInWithGoogle() is called when the sign in with google button is
      /// pressed on the Login Form
      testWidgets('logInWithGoogle when sign in with google button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginCubit.logInWithGoogle()).called(1);
      });

      /// Test that widgets are rendered in response to certain events
      group('renders', () {

        /// Test that SnackBar is rendered when the LoginState has a status of
        /// FormzSubmissionStatus.failure
        testWidgets('AuthenticationFailure SnackBar when submission fails',
            (tester) async {
          whenListen(
            loginCubit,
            Stream.fromIterable(const <LoginState>[
              LoginState(status: FormzSubmissionStatus.inProgress),
              LoginState(status: FormzSubmissionStatus.failure),
            ]),
          );
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: loginCubit,
                  child: const LoginForm(),
                ),
              ),
            ),
          );
          await tester.pump();
          expect(find.text('Authentication Failure'), findsOneWidget);
        });

        /// test that an error text is rendered when an invalid email is entered.
        testWidgets('invalid email error text when email is invalid',
                (tester) async {
              final email = MockEmail();
              when(() => email.displayError).thenReturn(EmailValidationError.invalid);
              when(() => loginCubit.state).thenReturn(LoginState(email: email));
              await tester.pumpWidget(
                MaterialApp(
                  home: Scaffold(
                    body: BlocProvider.value(
                      value: loginCubit,
                      child: const LoginForm(),
                    ),
                  ),
                ),
              );
              expect(find.text('invalid email'), findsOneWidget);
            });

        /// test that an error text is rendered when an invalid password is entered.
        testWidgets('invalid password error text when password is invalid',
                (tester) async {
              final password = MockPassword();
              when(
                    () => password.displayError,
              ).thenReturn(PasswordValidationError.invalid);
              when(() => loginCubit.state).thenReturn(LoginState(password: password));
              await tester.pumpWidget(
                MaterialApp(
                  home: Scaffold(
                    body: BlocProvider.value(
                      value: loginCubit,
                      child: const LoginForm(),
                    ),
                  ),
                ),
              );
              expect(find.text('invalid password'), findsOneWidget);
            });

        /// test that the login button is disabled when the LoginState does not have a
        /// valid status
        testWidgets('disabled login button when status is not validated',
                (tester) async {
              when(() => loginCubit.state).thenReturn(const LoginState());
              await tester.pumpWidget(
                MaterialApp(
                  home: Scaffold(
                    body: BlocProvider.value(
                      value: loginCubit,
                      child: const LoginForm(),
                    ),
                  ),
                ),
              );
              final loginButton = tester.widget<ElevatedButton>(
                find.byKey(loginButtonKey),
              );
              expect(loginButton.enabled, isFalse);
            });

        /// test that the login button is enabled when the LoginState has a
        /// valid status
        testWidgets('enabled login button when status is validated',
                (tester) async {
              when(() => loginCubit.state).thenReturn(
                const LoginState(isValid: true),
              );
              await tester.pumpWidget(
                MaterialApp(
                  home: Scaffold(
                    body: BlocProvider.value(
                      value: loginCubit,
                      child: const LoginForm(),
                    ),
                  ),
                ),
              );
              final loginButton = tester.widget<ElevatedButton>(
                find.byKey(loginButtonKey),
              );
              expect(loginButton.enabled, isTrue);
            });

        /// test that the Sign In With Google button is rendered on the LoginForm
        testWidgets('Sign in with Google Button', (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: loginCubit,
                  child: const LoginForm(),
                ),
              ),
            ),
          );
          expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
        });
      });

      /// test that a Sign Up Button is rendered and that when pressed,
      /// a Sign Up page is rendered (navigation).
      group('navigates', () {
        testWidgets('to SignUpPage when Create Account is pressed',
                (tester) async {
              await tester.pumpWidget(
                RepositoryProvider<Authentication>(
                  create: (_) => MockAuthenticationRepository(),
                  child: MaterialApp(
                    home: Scaffold(
                      body: BlocProvider.value(
                        value: loginCubit,
                        child: const LoginForm(),
                      ),
                    ),
                  ),
                ),
              );
              await tester.tap(find.byKey(createAccountButtonKey));
              await tester.pumpAndSettle();
              expect(find.byType(SignUpPage), findsOneWidget);
            });
      });
      });
    });

}
