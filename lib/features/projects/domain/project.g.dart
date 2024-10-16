// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      columns: (json['columns'] as num).toInt(),
      rows: (json['rows'] as num).toInt(),
      audioFiles: (json['audioFiles'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, AudioFile.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'columns': instance.columns,
      'rows': instance.rows,
      'audioFiles': instance.audioFiles.map((k, e) => MapEntry(k, e.toJson())),
    };
