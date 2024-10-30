// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AudioFileImpl _$$AudioFileImplFromJson(Map<String, dynamic> json) =>
    _$AudioFileImpl(
      id: json['id'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
      positionX: (json['positionX'] as num).toInt(),
      positionY: (json['positionY'] as num).toInt(),
      volume: (json['volume'] as num).toDouble(),
    );

Map<String, dynamic> _$$AudioFileImplToJson(_$AudioFileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'name': instance.name,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'volume': instance.volume,
    };
