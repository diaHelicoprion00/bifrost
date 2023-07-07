import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_information_api/user_information_api.dart';
import 'package:uuid/uuid.dart';

part 'user_information.g.dart';

/// The type definition for a JSON-serializable [Map].
typedef JsonMap = Map<String, dynamic>;

/// {@template user_information}
/// A single user's information.
///
/// Contains [id], [username], [major], [minor], [education_year] and [graduationClass].
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one will be generated.
///
/// [user_information]'s are immutable and can be copied using [copyWith], in addition to being
/// serialized and deserialized using [Json]
@immutable
@JsonSerializable()
class UserInformation extends Equatable {
  /// {@macro user_information}
  UserInformation({ String? id,
    required String this.username,
    this.majors = const [],
    this.minors = const [],
    this.graduationClass = 0,
    this.educationYear = ''})
      : assert(
  id == null || id.isNotEmpty,
  'id can either be null or not empty',
  ),
        id = id ?? const Uuid().v4();

  final String id;
  final String username;
  final List<String> majors;
  final List<String> minors;
  final int graduationClass;
  final String educationYear;


  /// Returns a copy of [UserInformation] with the given values updated.
  UserInformation copyWith({String? id,
    String? username,
    List<String>? majors,
    List<String>? minors,
    int? graduationClass,
    String? educationYear}) {
    return UserInformation(id: id ?? this.id,
        username: username ?? this.username,
        majors: majors ?? this.majors,
        minors: minors ?? this.minors,
        graduationClass: graduationClass ?? this.graduationClass,
        educationYear: educationYear ?? this.educationYear);

  }

  /// returns an empty UserInformation object
  static UserInformation empty() =>  UserInformation(id: '0000', username: '');

  /// Deserializes the given [JsonMap] into a [UserInformation].
  static UserInformation fromJson(JsonMap json) => _$UserInformationFromJson(json);


  /// Converts this [UserInformation] into a [JsonMap].
  JsonMap toJson() => _$UserInformationToJson(this);

  /// Uses the list of given properties to compare multiple [UserInformation] objects
  @override
  List<Object?> get props => [id, username,
     majors,
    minors,
    graduationClass,
    educationYear];
}
