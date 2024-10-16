import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required int columns,
    required int rows,
    required Map<String, AudioFile> audioFiles,
  }) = _Project;

  factory Project.empty({required String id, required String name}) {
    return Project(
      id: id,
      name: name,
      audioFiles: const {},
      columns: 3,
      rows: 3,
    );
  }

  factory Project.fromJson(Map<String, dynamic> map) => _$ProjectFromJson(map);
}
