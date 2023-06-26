// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInformation _$UserInformationFromJson(Map<String, dynamic> json) =>
    UserInformation(
      id: json['id'] as String?,
      username: json['username'] as String,
      majors: (json['majors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      minors: (json['minors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      graduationClass: json['graduationClass'] as int? ?? 0,
      educationYear: json['educationYear'] as String? ?? '',
    );

Map<String, dynamic> _$UserInformationToJson(UserInformation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'majors': instance.majors,
      'minors': instance.minors,
      'graduationClass': instance.graduationClass,
      'educationYear': instance.educationYear,
    };
