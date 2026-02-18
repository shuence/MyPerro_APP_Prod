// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollarImpl _$$CollarImplFromJson(Map<String, dynamic> json) => _$CollarImpl(
      imei: json['imei'] as String,
      collarToken: json['collarToken'] as String,
      deviceName: json['deviceName'] as String,
      petId: json['petId'] as String,
      status: $enumDecodeNullable(_$CollarStatusEnumMap, json['status']) ??
          CollarStatus.disconnected,
      firmwareVersion: json['firmwareVersion'] as String?,
      batteryLevel: (json['batteryLevel'] as num?)?.toInt(),
      lastSync: json['lastSync'] == null
          ? null
          : DateTime.parse(json['lastSync'] as String),
      wifiSSID: json['wifiSSID'] as String?,
      geofenceOutThreshold: (json['geofenceOutThreshold'] as num?)?.toInt(),
      geofenceInThreshold: (json['geofenceInThreshold'] as num?)?.toInt(),
      isLost: json['isLost'] as bool? ?? false,
    );

Map<String, dynamic> _$$CollarImplToJson(_$CollarImpl instance) =>
    <String, dynamic>{
      'imei': instance.imei,
      'collarToken': instance.collarToken,
      'deviceName': instance.deviceName,
      'petId': instance.petId,
      'status': _$CollarStatusEnumMap[instance.status]!,
      'firmwareVersion': instance.firmwareVersion,
      'batteryLevel': instance.batteryLevel,
      'lastSync': instance.lastSync?.toIso8601String(),
      'wifiSSID': instance.wifiSSID,
      'geofenceOutThreshold': instance.geofenceOutThreshold,
      'geofenceInThreshold': instance.geofenceInThreshold,
      'isLost': instance.isLost,
    };

const _$CollarStatusEnumMap = {
  CollarStatus.disconnected: 'disconnected',
  CollarStatus.scanning: 'scanning',
  CollarStatus.connecting: 'connecting',
  CollarStatus.connected: 'connected',
  CollarStatus.pairing: 'pairing',
  CollarStatus.ready: 'ready',
  CollarStatus.error: 'error',
};
