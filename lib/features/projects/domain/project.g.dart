// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      rows: (json['rows'] as num).toInt(),
      columns: (json['columns'] as num).toInt(),
      tabs: (json['tabs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, ProjectTab.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rows': instance.rows,
      'columns': instance.columns,
      'tabs': instance.tabs.map((k, e) => MapEntry(k, e.toJson())),
    };
