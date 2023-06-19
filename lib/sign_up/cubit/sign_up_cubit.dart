import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

///{@template SignUpCubit}
/// A [Cubit] to emit new [SignUpState] objects
/// {@endtemplate}
class SignUpCubit extends Cubit<SignUpState>{
  ///{@macro SignUpCubit}
  SignUpCubit(this._authentication) : super(const SignUpState());

  final Authentication _authentication;

  /// Emits a new [SignUpState] when the email value changes
  /// Sign Up form is re-validated with [Formz].
  void emailChanged(String value){
    final email = Email.dirty(value: value);
    emit(
      state.copyWith(email: email,
      isValid: Formz.validate([email, state.password, state.confirmedPassword]),
      ),
    );
  }

  /// Emits a new [SignUpState] when the password value changes.
  /// Sign Up form is re-validated with [Formz]
  void passwordChanged(String value){
    final password = Password.dirty(value: value);
    final confirmedPassword = ConfirmedPassword.dirty(password: password.value, value: state.confirmedPassword.value);
    emit(
      state.copyWith(password: password, confirmedPassword: confirmedPassword, isValid: Formz.validate([state.email, password, confirmedPassword]))
    );
  }

  /// Emits a new [SignUpState] when the confirmedPassword value changes.
  /// Sign Up form is re-validated with [Formz]
  void confirmedPasswordChanged(String value){
    final confirmedPassword = ConfirmedPassword.dirty(password: state.password.value , value: value);
    emit(
      state.copyWith(confirmedPassword: confirmedPassword, isValid: Formz.validate([state.email, state.password, confirmedPassword]) )
    );
  }

  /// Submits the User Credentials to the Sign Up Form
  Future<void> signUpFormSubmitted() async {
    if(!state.isValid) return;
    emit(state.copyWith(status:FormzSubmissionStatus.inProgress));
    try{
      await _authentication.signUp(email: state.email.value, password: state.password.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e){
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.message));
    } catch(_){
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
}
}