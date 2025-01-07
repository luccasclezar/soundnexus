import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/project_info.dart';

class ProjectsPageViewModel extends ChangeNotifier {
  ProjectsPageViewModel(this._projectsRepository) {
    init();
  }

  List<ProjectInfo> _projects = [];
  final ProjectsRepository _projectsRepository;
  late final StreamSubscription<List<ProjectInfo>> _projectsSubscription;

  String error = '';
  bool isLoadingProjects = true;

  List<ProjectInfo> get projects => List.unmodifiable(_projects);

  @override
  void dispose() {
    _projectsSubscription.cancel();
    super.dispose();
  }

  Future<void> addProject(ProjectInfo value) {
    return _projectsRepository.addProject(value);
  }

  Future<void> deleteProject(String id) {
    return _projectsRepository.deleteProject(id);
  }

  Future<void> init() async {
    _projectsSubscription =
        _projectsRepository.streamProjects().listen((event) {
      _projects = event;
      isLoadingProjects = false;
      notifyListeners();
    });
  }
}
