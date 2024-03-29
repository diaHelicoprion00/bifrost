import 'package:formz/formz.dart';

/// Validation errors for the [ConfirmedPassword] [FormzInput].
enum ConfirmedPasswordValidationError {
  /// Generic invalid error
  invalid
}

///{@template confirmed_password}
///Form input for a confirmed password input.
///{@endtemplate}
class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError>{
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
        : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return password == value ? null : ConfirmedPasswordValidationError.invalid;
  }
}