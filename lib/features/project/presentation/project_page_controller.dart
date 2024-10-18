import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/global/extensions_on_double.dart';

part 'project_page_controller.freezed.dart';
part 'project_page_controller.g.dart';

@riverpod
class ProjectPageController extends _$ProjectPageController {
  @override
  ProjectControllerModel build(String projectId) {
    final project = ref.watch(projectProvider(projectId)).value;
    return ProjectControllerModel(project: project);
  }

  @override
  bool updateShouldNotify(
    ProjectControllerModel previous,
    ProjectControllerModel next,
  ) =>
      previous != next;

  Future<void> setAudioFile(AudioFile? audio, int x, int y) async {
    await ref
        .read(projectsRepositoryProvider)
        .setAudioFile(projectId, audio, x, y);
  }

  void setVolume(double value) {
    state = state.copyWith(volume: value.toFixed(2));
  }

  void stop() {
    state = state.copyWith(isPlaying: false);
  }
}

@freezed
class ProjectControllerModel with _$ProjectControllerModel {
  const factory ProjectControllerModel({
    required Project? project,
    @Default(false) bool isPlaying,
    @Default(1.0) double volume,
  }) = _ProjectControllerModel;
}
