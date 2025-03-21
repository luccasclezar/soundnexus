import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soundnexus/features/projects/domain/project_tab.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required int rows,
    required int columns,
    required Map<String, ProjectTab> tabs,
  }) = _Project;

  factory Project.empty({required String id, required String name}) {
    return Project(
      id: id,
      name: name,
      tabs: {
        'default': const ProjectTab(
          id: 'default',
          audioFiles: {},
          index: 0,
          name: 'Main',
        ),
      },
      columns: 3,
      rows: 3,
    );
  }

  factory Project.fromJson(Map<String, dynamic> map) => _$ProjectFromJson(map);
}
