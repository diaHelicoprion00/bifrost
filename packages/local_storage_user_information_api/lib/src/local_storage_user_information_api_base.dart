import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_information_api/user_information_api.dart';

/// {@template local_storage_user_information_api}
/// A Flutter implementation of [UserInformationApi] that stores the
/// information of a Bifrost user in local Storage.
/// {@endtemplate}
class localStorageUserInformationApi extends UserInformationApi {
  /// {@macro local_storage_user_information_api}
  localStorageUserInformationApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _userInformationStreamController =
      BehaviorSubject<UserInformation>.seeded(UserInformation.empty());

  @visibleForTesting
  static const kUserInformationKey = '__user_information_key__';

  /// Takes in a [key] and returns a [String] from local storage
  String? _getValue(String key) => _plugin.getString(key);

  /// Takes in a [key],[value] pair and stores them in local storage.
  Future<void> _setValue(String key, String value) => _plugin.setString(key, value);

  /// Initializes the Information Stream Controller
  /// Checks if there is an existing Json instance of User information in local storage
  /// Adds the existing instance to the stream controller
  /// Adds an empty object to controller if no instance exists.
  void _init() {
    final userInformationJson = _getValue(kUserInformationKey);
   if (userInformationJson != null) {
      final UserInformation userInformation =
          UserInformation.fromJson(json.decode(userInformationJson));
      _userInformationStreamController.add(userInformation);
    } else {
      _userInformationStreamController.add(UserInformation.empty());
    }
  }

  /// Removes [UserInformation] from local storage if it matches [id]
  /// The [UserInformation].empty replaces the [UserInformation] variable, if successful
  /// A [UserInformationNotFoundException] is thrown otherwise.
  @override
  Future<void> deleteUserInformation(String id)  {
    final userInformationJson = _getValue(kUserInformationKey);
    if (userInformationJson != null) {
      final UserInformation storedUserInformation =
      UserInformation.fromJson(json.decode(userInformationJson));
      if(storedUserInformation.id != id){
        throw UserInformationNotFoundException();
      }
    }

    _userInformationStreamController.add(UserInformation.empty());
    return _setValue(kUserInformationKey, json.encode(UserInformation.empty()));
  }

  @override
  Stream<UserInformation> getUserInformation() => _userInformationStreamController.asBroadcastStream();


  /// stores [UserInformation] in local storage
  /// if the [UserInformation] does not exist in local storage,
  /// a [UserInformationNotFoundException] is thrown.
  @override
  Future<void> setUserInformation(UserInformation userInformation) {
    final userInformationJson = _getValue(kUserInformationKey);
    if (userInformationJson != null) {
      final UserInformation storedUserInformation =
      UserInformation.fromJson(json.decode(userInformationJson));
      if(storedUserInformation.id != userInformation.id){
        throw UserInformationNotFoundException();
      }
    }

    _userInformationStreamController.add(userInformation);
    return _setValue(kUserInformationKey, json.encode(userInformation));
  }
}
