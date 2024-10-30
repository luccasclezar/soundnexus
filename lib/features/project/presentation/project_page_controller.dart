import 'package:audioplayers/audioplayers.dart';
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
  late final repo = ref.read(projectsRepositoryProvider);

  final Map<String, AudioPlayer> players = {};

  @override
  ProjectControllerModel build(String projectId) {
    ref.onCancel(() {
      for (final player in players.values) {
        player.dispose();
      }
    });

    final project = ref.watch(projectProvider(projectId)).value;
    final model = ProjectControllerModel(project: project);

    final idsUpdates = <String>[];

    if (project != null) {
      // Update all project audios.
      for (final audio in project.audioFiles.values) {
        _updatePlayer(audio, model);
        idsUpdates.add(audio.id);
      }

      // Dispose of all players that weren't updated (meaning their audio
      // doesn't exist in the project anymore).
      for (final id in players.keys.toList()) {
        if (!idsUpdates.contains(id)) {
          players[id]?.dispose();
          players.remove(id);
        }
      }
    }

    return model;
  }

  void _updatePlayer(AudioFile audio, [ProjectControllerModel? state]) {
    state ??= this.state;
    final id = audio.id;
    var player = players[id];

    player ??= players[id] = AudioPlayer();

    final targetVolume = audio.volume * state.volume;

    // Update source
    if ((player.source as DeviceFileSource?)?.path != audio.path) {
      player.setSource(DeviceFileSource(audio.path));
    }

    // Update volume
    if (player.volume != targetVolume) {
      player.setVolume(targetVolume);
    }
  }

  @override
  bool updateShouldNotify(
    ProjectControllerModel previous,
    ProjectControllerModel next,
  ) =>
      previous != next;

  Future<void> deleteAudioFile(int x, int y) async {
    final audioId = ref.read(audioFileProvider(projectId, x, y))?.id;

    if (audioId == null) {
      return;
    }

    await players[audioId]?.stop();
    players.remove(audioId);

    await repo.setAudioFile(projectId, null, x, y);
  }

  Future<void> moveAudioFile(AudioFile audio, int newX, int newY) async {
    return repo.moveAudioFile(projectId, audio, newX, newY);
  }

  Future<void> setAudioFile(AudioFile? audio, int x, int y) async {
    if (audio != null) {
      _updatePlayer(audio);
    }

    await repo.setAudioFile(projectId, audio, x, y);
  }

  void setVolume(double value) {
    final newState = state.copyWith(volume: value.toFixed(2));

    // When setting global volume, update the volume of all the AudioPlayers.
    for (final audio in state.project!.audioFiles.values) {
      _updatePlayer(audio, newState);
    }

    for (final entry in players.entries) {
      final id = entry.key;
      final audio = ref
          .read(projectProvider(projectId))
          .value!
          .audioFiles
          .values
          .firstWhere((e) => e.id == id);
      final player = entry.value;

      player.setVolume(audio.volume * value);
    }

    state = newState;
  }

  void stop() {
    for (final player in players.values) {
      player.stop();
    }

    state = state.copyWith(isPlaying: false);
  }

  void toggleAudio(int x, int y) {
    final audio = ref.read(audioFileProvider(projectId, x, y));

    if (audio == null) {
      return;
    }

    var player = players[audio.id];

    if (player == null) {
      player = players[audio.id] = AudioPlayer();
      player.setSource(DeviceFileSource(audio.path));
    }

    if (player.state == PlayerState.playing) {
      player.pause();
    } else {
      player.resume();
    }
  }

  Future<void> updateProject(Project value) {
    return repo.updateProject(value);
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
