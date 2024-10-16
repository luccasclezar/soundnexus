import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'project_info.freezed.dart';
part 'project_info.g.dart';

@freezed
class ProjectInfo with _$ProjectInfo {
  const factory ProjectInfo({
    required String id,
    required String name,
  }) = _ProjectInfo;

  factory ProjectInfo.empty({required String name}) {
    return ProjectInfo(id: const Uuid().v4(), name: name);
  }

  factory ProjectInfo.fromJson(Map<String, dynamic> map) =>
      _$ProjectInfoFromJson(map);
}
