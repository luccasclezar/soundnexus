// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AudioFileImpl _$$AudioFileImplFromJson(Map<String, dynamic> json) =>
    _$AudioFileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      positionX: (json['positionX'] as num).toInt(),
      positionY: (json['positionY'] as num).toInt(),
      volume: (json['volume'] as num).toDouble(),
      loop: json['loop'] as bool? ?? false,
      shortcut: json['shortcut'] as String? ?? '',
    );

Map<String, dynamic> _$$AudioFileImplToJson(_$AudioFileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'volume': instance.volume,
      'loop': instance.loop,
      'shortcut': instance.shortcut,
    };
