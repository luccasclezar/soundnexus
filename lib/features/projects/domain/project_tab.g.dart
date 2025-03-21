// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_tab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectTabImpl _$$ProjectTabImplFromJson(Map<String, dynamic> json) =>
    _$ProjectTabImpl(
      audioFiles: (json['audioFiles'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, AudioFile.fromJson(e as Map<String, dynamic>)),
      ),
      id: json['id'] as String,
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ProjectTabImplToJson(_$ProjectTabImpl instance) =>
    <String, dynamic>{
      'audioFiles': instance.audioFiles.map((k, e) => MapEntry(k, e.toJson())),
      'id': instance.id,
      'index': instance.index,
      'name': instance.name,
    };
