import 'package:user_information_api/user_information_api.dart';

/// {@template user_information_api}
/// The interface for an API that provides access to user information.
/// {@endtemplate}
abstract class UserInformationApi {
  /// {@macro user_api}
  const UserInformationApi();

  /// Provides a [Stream] of user information
  Stream<UserInformation> getUserInformation();

  /// Saves a [UserInformation]
  ///
  /// If a [UserInformation] with same id already exists, it updates the [UserInformation]/
  Future<void> setUserInformation(UserInformation userInformation);

  /// Deletes a [UserInformation]
  Future<void> deleteUserInformation(String id);
}

/// Error thrown when a [UserInformation] with a given id is not found.
class UserInformationNotFoundException implements Exception {}
