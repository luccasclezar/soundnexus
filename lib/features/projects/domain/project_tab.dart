import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';

part 'project_tab.freezed.dart';
part 'project_tab.g.dart';

@freezed
class ProjectTab with _$ProjectTab {
  const factory ProjectTab({
    required Map<String, AudioFile> audioFiles,
    required String id,
    required int index,
    required String name,
  }) = _ProjectTab;

  factory ProjectTab.fromJson(Map<String, dynamic> json) =>
      _$ProjectTabFromJson(json);
}
