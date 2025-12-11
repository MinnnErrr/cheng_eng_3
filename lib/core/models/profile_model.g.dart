// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNum: json['phoneNum'] as String,
  countryCode: json['countryCode'] as String,
  dialCode: json['dialCode'] as String,
  gender: json['gender'] as String,
  birthday: json['birthday'] == null
      ? null
      : DateTime.parse(json['birthday'] as String),
  role: json['role'] as String,
  userId: json['userId'] as String,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phoneNum': instance.phoneNum,
  'countryCode': instance.countryCode,
  'dialCode': instance.dialCode,
  'gender': instance.gender,
  'birthday': instance.birthday?.toIso8601String(),
  'role': instance.role,
  'userId': instance.userId,
  'deletedAt': instance.deletedAt?.toIso8601String(),
};
