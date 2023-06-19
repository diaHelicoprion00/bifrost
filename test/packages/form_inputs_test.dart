import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  /// A suite of tests to ensure that the FormzInput validators work as intended.
  group('Email Input', () {
    /// A test to ensure that the email validator works correctly for a correct email address.
    test('validates a correct email address', () {
        const emailInput = Email.dirty(value: 'mockname@mockmail.com');
        expect(emailInput.error, null);
    });

    /// A test to ensure that the email validator works correctly for an incorrect email address.
    test('validates an incorrect email address', () {
      const emailInput = Email.dirty(value: 'mockname123');
      expect(emailInput.error, EmailValidationError.invalid);
    });
  });

  /// A suite of tests to ensure that the Password FormzInput validator work as intended.
  group('Password Input', () {


    /// A test to ensure that the password validator works correctly for a correct password.
    test('validates a correct email address', () {
      const passwordInput = Password.dirty(value: 'mockPassword123');
      expect(passwordInput.error , null);
    });

    /// A test to ensure that the password validator works correctly for an incorrect password.
    test('validates an incorrect password', () {
      const passwordInput = Password.dirty(value: '.');
      expect(passwordInput.error , PasswordValidationError.invalid);
    });
  });

  /// A suite of tests to ensure that the ConfirmedPassword FormzInput validator work as intended.
  group('ConfirmedPassword Input', () {
    /// A test to ensure that the confirmed password validator works correctly when
    /// the original password matches the confirmed password.
    test('validates when the confirmed password matches the original password', () {
      const confirmedPassword = ConfirmedPassword.dirty(password: 'mockPassword123',value: 'mockPassword123');
      expect(confirmedPassword.error, null);
    });

    /// A test to ensure that the confirmed password validator works correctly when
    /// the original password does not match the confirmed password.
    test('validates when the confirmed password does not match the original password', () {
      const confirmedPassword = ConfirmedPassword.dirty(password: 'mockPassword123',value: 'mockPassword456');
      expect(confirmedPassword.error, ConfirmedPasswordValidationError.invalid);
    });
  });
}
