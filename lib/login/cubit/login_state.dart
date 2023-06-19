part of 'login_cubit.dart';

/// {@template LoginState}
/// Stores the Login status and User credentials
/// {@endtemplate}
final class LoginState extends Equatable {
  /// {@macro LoginState}
  const LoginState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  /// Returns [List] of properties that can be used to compare multiple [LoginState] objects.
  @override
  List<Object?> get props => [email, password, status, isValid, errorMessage];

  /// Returns new [LoginState] object that updates
  /// existing [LoginState] properties, if needed.
  LoginState copyWith(
      {Email? email,
      Password? password,
      FormzSubmissionStatus? status,
      bool? isValid,
      String? errorMessage}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
