import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';

part 'app_state.dart';

/// {@template AppBloc}
/// A [Bloc] to manage state and [AppEvent] changes for
/// the [Authentication] repository.
/// {endtemplate}
class AppBloc extends Bloc<AppEvent, AppState> {
  /// {@macro AppBloc}
  AppBloc({required Authentication authentication})
      : _authentication = authentication,
        super(authentication.currentUser.isEmpty
            ? const AppState.unauthenticated()
            : AppState.authenticated(authentication.currentUser)) {
    /// Registering [EventHandler] for [AppEvents].
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    /// Subscribing to the [Authentication] [User] stream.
    _userSubscription =
        _authentication.user.listen((user) => add(_AppUserChanged(user)));
  }

  /// Instance of [Authentication] repository.
  final Authentication _authentication;

  /// [User] stream subscription.
  late final StreamSubscription<User> _userSubscription;


  /// [EventHandler] for the _AppUserChanged [AppEvent].
  /// A new [AppState] from received [event] is emitted to the [Bloc].
  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isEmpty
          ? const AppState.unauthenticated()
          : AppState.authenticated(event.user),
    );
  }


  /// [EventHandler] for the AppLogoutRequested [AppEvent].
  /// [Authentication].logOut() is invoked and unawaited.
  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit){
    unawaited(_authentication.logOut());
  }

  /// Closes the subscription to the [User] stream.
  @override
  Future<void> close(){
    _userSubscription.cancel();
    return super.close();
  }
}
