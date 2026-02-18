// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationRequestImpl _$$RegistrationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationRequestImpl(
      imei: json['imei'] as String,
      userId: json['userId'] as String,
      userToken: json['userToken'] as String,
    );

Map<String, dynamic> _$$RegistrationRequestImplToJson(
        _$RegistrationRequestImpl instance) =>
    <String, dynamic>{
      'imei': instance.imei,
      'userId': instance.userId,
      'userToken': instance.userToken,
    };

_$RegistrationResponseImpl _$$RegistrationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationResponseImpl(
      status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
      collarToken: json['collarToken'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$RegistrationResponseImplToJson(
        _$RegistrationResponseImpl instance) =>
    <String, dynamic>{
      'status': _$RegistrationStatusEnumMap[instance.status]!,
      'collarToken': instance.collarToken,
      'message': instance.message,
    };

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.alreadyRegisteredCurrentUser:
      'alreadyRegisteredCurrentUser',
  RegistrationStatus.alreadyRegisteredOtherUser: 'alreadyRegisteredOtherUser',
  RegistrationStatus.newlyRegistered: 'newlyRegistered',
};
