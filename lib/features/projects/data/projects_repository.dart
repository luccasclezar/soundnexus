import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/features/projects/domain/project_info.dart';
import 'package:soundnexus/features/projects/domain/project_tab.dart';

abstract class ProjectsRepository {
  void dispose();

  Future<void> addProject(ProjectInfo value);
  Future<void> deleteProject(String id);
  Future<Project> getProject(String projectId);
  Stream<Project> streamProject(String projectId);
  Stream<List<ProjectInfo>> streamProjects();
  Future<void> updateProject(Project value);

  /// Updates the project with the given [projectId] and adds the [tab] to it.
  Future<void> addTab(String projectId, ProjectTab tab);

  Future<void> moveAudioFile(
    String projectId,
    ProjectTab tab,
    AudioFile audio,
    int newX,
    int newY,
  );
  Future<void> setAudioFile(
    String projectId,
    ProjectTab tab,
    AudioFile? audio,
    int x,
    int y,
  );
}

class LocalProjectsRepository implements ProjectsRepository {
  final _getStorage = GetStorage();
  final List<void Function()> _subscriptions = [];

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s();
    }
  }

  @override
  Future<void> addProject(ProjectInfo value) async {
    final projects = (_getStorage.read<List<dynamic>>('projects') ?? [])
        .map((e) => ProjectInfo.fromJson(e as Map<String, dynamic>))
        .toList();

    await _getStorage.write(
      'projects',
      [...projects, value].map((e) => e.toJson()).toList(),
    );
    await _getStorage.write(
      'project_${value.id}',
      Project.empty(id: value.id, name: value.name).toJson(),
    );
  }

  @override
  Future<void> addTab(String projectId, ProjectTab tab) async {
    final project = await getProject(projectId);

    return _getStorage.write(
      'project_$projectId',
      project.copyWith(tabs: {...project.tabs}..[tab.id] = tab).toJson(),
    );
  }

  @override
  Future<void> deleteProject(String id) async {
    final projects = (_getStorage.read<List<dynamic>>('projects') ?? [])
        .map((e) => ProjectInfo.fromJson(e as Map<String, dynamic>))
        .toList();

    await _getStorage.remove('project_$id');
    await _getStorage.write(
      'projects',
      (projects.toList()..removeWhere((e) => e.id == id))
          .map((e) => e.toJson())
          .toList(),
    );
  }

  @override
  Future<Project> getProject(String projectId) async {
    return Project.fromJson(
      _getStorage.read<Map<String, dynamic>>('project_$projectId') ?? {},
    );
  }

  @override
  Future<void> moveAudioFile(
    String projectId,
    ProjectTab tab,
    AudioFile audio,
    int newX,
    int newY,
  ) async {
    final project = await getProject(projectId);

    final audioFiles = {...tab.audioFiles};
    final oldX = audio.positionX;
    final oldY = audio.positionY;

    audioFiles.remove('$oldX:$oldY');
    audioFiles['$newX:$newY'] =
        audio.copyWith(positionX: newX, positionY: newY);

    await _getStorage.write(
      'project_$projectId',
      project
          .copyWith(
            tabs: {...project.tabs}..[tab.id] =
                tab.copyWith(audioFiles: audioFiles),
          )
          .toJson(),
    );
  }

  @override
  Future<void> setAudioFile(
    String projectId,
    ProjectTab tab,
    AudioFile? audio,
    int x,
    int y,
  ) async {
    final project = await getProject(projectId);

    final audioFiles = {...tab.audioFiles};

    if (audio == null) {
      audioFiles.remove('$x:$y');
    } else {
      audioFiles['$x:$y'] = audio;
    }

    await _getStorage.write(
      'project_$projectId',
      project
          .copyWith(
            tabs: {...project.tabs}..[tab.id] =
                tab.copyWith(audioFiles: audioFiles),
          )
          .toJson(),
    );
  }

  @override
  Stream<List<ProjectInfo>> streamProjects() {
    final controller = StreamController<List<ProjectInfo>>();
    _subscriptions.add(
      _getStorage.listenKey(
        'projects',
        (value) => controller.add(
          (value as List<dynamic>)
              .map((e) => ProjectInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    );

    controller.add(
      (_getStorage.read<List<dynamic>>('projects') ?? [])
          .map((e) => ProjectInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return controller.stream;
  }

  @override
  Stream<Project> streamProject(String projectId) {
    final controller = StreamController<Project>();

    // Send the subscription as a callback so that the provider can dispose it.
    final getStorageListenSub = _getStorage.listenKey(
      'project_$projectId',
      (value) => controller.add(
        Project.fromJson(value as Map<String, dynamic>? ?? {}),
      ),
    );

    controller.onCancel = getStorageListenSub;

    controller.add(
      Project.fromJson(
        _getStorage.read<Map<String, dynamic>>('project_$projectId') ?? {},
      ),
    );

    return controller.stream;
  }

  @override
  Future<void> updateProject(Project value) {
    return _getStorage.write('project_${value.id}', value.toJson());
  }
}
