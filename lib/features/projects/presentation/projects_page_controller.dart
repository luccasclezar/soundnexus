import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/project_info.dart';

part 'projects_page_controller.g.dart';

@riverpod
ProjectsPageController projectsPageController(ProjectsPageControllerRef ref) {
  return ProjectsPageController(ref);
}

class ProjectsPageController {
  ProjectsPageController(this.ref);

  Ref ref;

  Future<void> addProject(ProjectInfo value) {
    return ref.read(projectsRepositoryProvider).addProject(value);
  }

  Future<void> deleteProject(String id) {
    return ref.read(projectsRepositoryProvider).deleteProject(id);
  }
}
