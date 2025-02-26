import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/global/extensions_on_double.dart';

enum AudioError { unknown, notFound }

enum ProjectView { normal, edit, shortcut }

class ProjectPageViewModel extends ChangeNotifier {
  ProjectPageViewModel(this._projectsRepository, this.projectId) {
    init();
  }

  String error = '';
  ProjectView view = ProjectView.normal;
  bool isLoading = true;
  bool isPlaying = false;
  bool isReady = false;
  double volume = 1;

  /// Audios that currently had an error when being loaded.
  ///
  /// The map keys are the AudioFile.id.
  Map<String, AudioError> audiosWithError = {};

  /// Audios currently selected as being edited.
  List<String> editingAudios = [];

  final String projectId;

  Project? _project;
  Project get project => _project!;

  final ProjectsRepository _projectsRepository;

  final Map<String, AudioPlayer> _players = {};
  late final StreamSubscription<Project> _projectStreamSub;

  /// Players state (playing or paused).
  ///
  /// As players states are changed asynchronically, this map is used to keep
  /// track of the players state.
  final Map<String, bool> _playersState = {};

  bool get isEditing => view == ProjectView.edit;
  bool get isEditingShortcuts => view == ProjectView.shortcut;
  bool get isNormalView => view == ProjectView.normal;

  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }

    _projectStreamSub.cancel();

    super.dispose();
  }

  void init() {
    _projectStreamSub = _projectsRepository.streamProject(projectId).listen(
      (e) {
        _project = e;
        isLoading = false;
        isReady = true;

        final audioIdsToKeep = <String>[];

        if (_project != null) {
          // Update all project audios.
          for (final audioFile in _project!.audioFiles.values) {
            _updatePlayer(audioFile);
            audioIdsToKeep.add(audioFile.id);
          }

          // Dispose of all _players that weren't updated (meaning their audio
          // doesn't exist in the project anymore).
          for (final id in _players.keys.toList()) {
            if (!audioIdsToKeep.contains(id)) {
              _players[id]?.dispose();
              _players.remove(id);
            }
          }
        }

        notifyListeners();
      },
      onError: (Object e, StackTrace stack) {
        _project = null;
        isLoading = false;
        isReady = false;
        error = e.toString();

        notifyListeners();

        FlutterError.dumpErrorToConsole(
          FlutterErrorDetails(exception: e, stack: stack),
        );
      },
    );
  }

  Future<void> deleteAudioFile(int x, int y) async {
    final audioId = getAudioFile(x, y)?.id;

    if (audioId == null) {
      return;
    }

    await _players[audioId]?.stop();
    _players.remove(audioId);

    notifyListeners();

    await _projectsRepository.setAudioFile(projectId, null, x, y);
  }

  AudioFile? getAudioFile(int x, int y) {
    return project.audioFiles['$x:$y'];
  }

  AudioFile? getAudioFileByString(String positionId) {
    return project.audioFiles[positionId];
  }

  /// Returns true if the specified audio is playing.
  ///
  /// [id] is the AudioFile.id.
  bool isAudioPlaying(String id) {
    return _playersState[id] ?? false;
  }

  Future<void> moveAudioFile(AudioFile audio, int newX, int newY) async {
    return _projectsRepository.moveAudioFile(projectId, audio, newX, newY);
  }

  void onEditPressed() {
    setView(view == ProjectView.edit ? ProjectView.normal : ProjectView.edit);
  }

  void onShortcutsPressed() {
    // TODO(luccasclezar): Implement shortcuts editing.
    setView(
      view == ProjectView.shortcut ? ProjectView.normal : ProjectView.shortcut,
    );
  }

  /// Sets [audio] as being edited.
  void selectAudio(AudioFile audio) {
    editingAudios = [audio.positionId];
    notifyListeners();
  }

  Future<void> setAudioFile(AudioFile? audio, int x, int y) async {
    if (audio != null) {
      await _updatePlayer(audio);
    }

    await _projectsRepository.setAudioFile(projectId, audio, x, y);
  }

  void setView(ProjectView view) {
    if (view != ProjectView.edit) {
      editingAudios.clear();
    }

    this.view = view;
    notifyListeners();
  }

  void setVolume(double value) {
    volume = value.toFixed(2);

    // When setting global volume, update the volume of all the Audio_players.
    for (final audio in project.audioFiles.values) {
      _updatePlayer(audio);
    }

    for (final entry in _players.entries) {
      final id = entry.key;
      final audio = project.audioFiles.values.firstWhere((e) => e.id == id);
      final player = entry.value;

      player.setVolume(audio.volume * value);
    }

    notifyListeners();
  }

  void stop() {
    for (final player in _players.values) {
      player.stop();
    }

    _playersState.clear();
    isPlaying = false;

    notifyListeners();
  }

  void toggleAudio(int x, int y) {
    final audio = getAudioFile(x, y);

    if (audio == null) {
      return;
    }

    var player = _players[audio.id];

    if (player == null) {
      player = _players[audio.id] = AudioPlayer();
      player.setSource(DeviceFileSource(audio.path));
    }

    if (player.state == PlayerState.playing) {
      player.pause();
      _playersState[audio.id] = false;
      isPlaying = false;
    } else {
      player.resume();
      _playersState[audio.id] = true;
      isPlaying = true;
    }

    notifyListeners();
  }

  Future<void> updateProject(Project value) {
    return _projectsRepository.updateProject(value);
  }

  void updateEditingAudios(AudioFile Function(AudioFile audio) callback) {
    for (final positionId in editingAudios) {
      final audio = getAudioFileByString(positionId);

      if (audio == null) {
        continue;
      }

      final position = positionId.split(':').map(int.parse).toList();

      setAudioFile(callback(audio), position[0], position[1]);
    }
  }

  Future<void> _updatePlayer(AudioFile audio) async {
    final id = audio.id;
    var player = _players[id];

    player ??= _players[id] = AudioPlayer();

    final targetVolume = audio.volume * volume;
    final targetReleaseMode = audio.loop ? ReleaseMode.loop : ReleaseMode.stop;

    try {
      // Update source
      if ((player.source as DeviceFileSource?)?.path != audio.path) {
        await player.setSource(DeviceFileSource(audio.path));
      }

      // Update volume
      if (player.volume != targetVolume) {
        await player.setVolume(targetVolume);
      }

      // Update volume
      if (player.releaseMode != targetReleaseMode) {
        await player.setReleaseMode(targetReleaseMode);
      }

      final removedError = audiosWithError.remove(audio.id);
      if (removedError != null) {
        notifyListeners();
      }
    } catch (ex) {
      // TODO(luccasclezar): Better handle errors when loading players.
      audiosWithError[audio.id] = AudioError.unknown;
      notifyListeners();
    }
  }
}
