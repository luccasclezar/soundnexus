import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/features/projects/domain/project_info.dart';

part 'projects_repository.g.dart';

@riverpod
Stream<List<ProjectInfo>> projects(ProjectsRef ref) {
  return ref.watch(projectsRepositoryProvider).streamProjects();
}

@riverpod
Stream<Project> project(ProjectRef ref, String projectId) {
  return ref.watch(projectsRepositoryProvider).streamProject(
        projectId,
        (sub) => ref.onDispose(sub),
      );
}

@riverpod
AudioFile? audioFile(AudioFileRef ref, String projectId, int x, int y) {
  final project = ref.watch(projectProvider(projectId));

  if (project.isLoading || project.hasError) {
    return null;
  }

  return project.value!.audioFiles['$x:$y'];
}

@riverpod
ProjectsRepository projectsRepository(ProjectsRepositoryRef ref) {
  return LocalProjectsRepository();
}

abstract class ProjectsRepository {
  void dispose();

  Future<void> addProject(ProjectInfo value);
  Future<void> deleteProject(String id);
  Future<Project> getProject(String projectId);
  Stream<Project> streamProject(
    String projectId,
    void Function(void Function()) subscriptionCallback,
  );
  Stream<List<ProjectInfo>> streamProjects();
  Future<void> updateProject(Project value);

  Future<void> moveAudioFile(
    String projectId,
    AudioFile audio,
    int newX,
    int newY,
  );
  Future<void> setAudioFile(String projectId, AudioFile? audio, int x, int y);
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
    AudioFile audio,
    int newX,
    int newY,
  ) async {
    final project = await getProject(projectId);

    final audioFiles = {...project.audioFiles};
    final oldX = audio.positionX;
    final oldY = audio.positionY;

    audioFiles.remove('$oldX:$oldY');
    audioFiles['$newX:$newY'] =
        audio.copyWith(positionX: newX, positionY: newY);

    await _getStorage.write(
      'project_$projectId',
      project.copyWith(audioFiles: audioFiles).toJson(),
    );
  }

  @override
  Future<void> setAudioFile(
    String projectId,
    AudioFile? audio,
    int x,
    int y,
  ) async {
    final project = await getProject(projectId);

    final audioFiles = {...project.audioFiles};

    if (audio == null) {
      audioFiles.remove('$x:$y');
    } else {
      audioFiles['$x:$y'] = audio;
    }

    await _getStorage.write(
      'project_$projectId',
      project.copyWith(audioFiles: audioFiles).toJson(),
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
  Stream<Project> streamProject(
    String projectId,
    void Function(void Function()) subscriptionCallback,
  ) {
    final controller = StreamController<Project>();

    // Send the subscription as a callback so that the provider can dispose it.
    subscriptionCallback(
      _getStorage.listenKey(
        'project_$projectId',
        (value) => controller.add(
          Project.fromJson(value as Map<String, dynamic>? ?? {}),
        ),
      ),
    );

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
