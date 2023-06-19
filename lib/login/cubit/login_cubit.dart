import 'package:authentication/authentication.dart';
import 'package:form_inputs/form_inputs.dart';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

///{@template LoginCubit}
///Cubit to handle [LoginState] transitions in the [LoginPage].
///{@endtemplate}
class LoginCubit extends Cubit<LoginState> {
  ///{@macro LoginCubit}
  LoginCubit(this._authentication) : super(const LoginState());

  final Authentication _authentication;

  /// Emits a new [LoginState] when the email value changes
  /// Login Form is re-validated with [Formz].
  void emailChanged(String value) {
    final email = Email.dirty(value: value);
    emit(
      state.copyWith(
          email: email,
          isValid: Formz.validate([email, state.password])
      ),
    );
  }

  /// Emits a new [LoginState] when the password value changes
  /// Login Form is re-validated with [Formz].
  void passwordChanged(String value) {
    final password = Password.dirty(value: value);
    emit(
        state.copyWith(
            password: password,
            isValid: Formz.validate([state.email, password]),
        )
    );
  }

  /// Logins to [Bifrost] via the user credentials.
  Future<void> logInWithCredentials() async {
    /// do not attempt to sign in if form is invalid
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      /// attempt to log in with email and password
      await _authentication.logInWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
            errorMessage: e.message,
            status: FormzSubmissionStatus.failure
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  /// Logins to [Bifrost] via Google
  Future<void> logInWithGoogle() async{
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try{
      await _authentication.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleFailure catch(e){
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzSubmissionStatus.failure
      ));
    } catch(_){
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}

