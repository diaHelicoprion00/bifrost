part of 'app_bloc.dart';

/// {@template AppEvent}
/// An [event] class for Authentication.
/// {#endtemplate}
sealed class AppEvent{
 const AppEvent();
}

/// {@template AppLogoutRequested}
/// An [AppEvent] subclass for a logout [event].
///  {endtemplate}
final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

/// {@template AppUserChanged}
/// An [AppEvent] subclass for a [User] changed [event].
final class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.user);

  final User user;
}