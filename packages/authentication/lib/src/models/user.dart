import 'package:equatable/equatable.dart';

/// The [User] model describes a user's authentication information.
/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable{
  const User({
    required this.id,
    this.email,
    this.name
});

  /// The current user's email address.
  final String? email;

  /// The current user's name.
  final String? name;

  /// The current user's id.
  final String id;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Getter to determine whether a user is empty.
  bool get isEmpty => this == User.empty;

  /// List of properties to determine if multiple users are equal
  @override
  List<Object?> get props => [email, id, name];
}
