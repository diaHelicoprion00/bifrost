part of 'app_bloc.dart';

/// States for [Authentication]
enum AppStatus{
  authenticated,
  unauthenticated,
}

/// {@template AppState}
/// A [bloc] state for [Authentication].
/// {@endtemplate}
final class AppState extends Equatable{

  /// {@macro AppState}
  const AppState._({
    required this.status,
    this.user = User.empty
});

  final AppStatus status;
  final User user;

  /// {@macro AppState}
  const AppState.authenticated(User user) : this._(status: AppStatus.authenticated);

  /// {@macro AppState}
  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  /// List of properties to distinguish between states.
  @override
  List<Object> get props => [status, user];
}