part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidatorError { invalid }

/// {@template SignUpState}
/// Stores the SignUp credentials of the user.
/// {@endtemplate}
final class SignUpState extends Equatable {
  ///{@macro SignUpState}
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  /// Returns a new [SignUpState] object that
 /// updates the existing [SignUpState]'s properties, if needed.
  SignUpState copyWith(
      {Email? email,
      Password? password,
      ConfirmedPassword? confirmedPassword,
      FormzSubmissionStatus? status,
      bool? isValid,
      String? errorMessage}) {
    return SignUpState(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid,
        errorMessage: errorMessage ?? this.errorMessage);
  }


  /// Returns [List] of properties that can be used to compare multiple [SignUpState] objects.
  @override
  List<Object?> get props =>
      [email, password, confirmedPassword, status, isValid, errorMessage];
}
