import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/project_info.dart';
import 'package:soundnexus/features/projects/presentation/projects_page_view_model.dart';
import 'package:soundnexus/global/app_dialogs.dart';
import 'package:soundnexus/global/globals.dart';

class ProjectsPage extends StatefulWidget {
  /// A page that shows all user's projects.
  ///
  /// If [viewModel] is not provided as parameter, one is created locally.
  ProjectsPage({ProjectsPageViewModel? viewModel, super.key}) {
    shouldDisposeViewModel = viewModel == null;
    this.viewModel =
        viewModel ?? ProjectsPageViewModel(getIt<ProjectsRepository>());
  }

  /// The [viewModel] should only be disposed if it was created by the
  /// constructor and not provided as parameter.
  late final bool shouldDisposeViewModel;

  /// The page's view model.
  late final ProjectsPageViewModel viewModel;

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  ProjectsPageViewModel get vm => widget.viewModel;

  Future<void> _onDeletePressed(ProjectInfo project) async {
    final result = await showAlert(
      context: context,
      positiveText: 'Delete',
      negativeText: 'Cancel',
      title: 'Delete ${project.name}?',
      message: 'This action cannot be undone.',
    );

    if (!result) {
      return;
    }

    await vm.deleteProject(project.id);
  }

  Future<void> _onFabPressed() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        // TODO(Luccas): Figure out how to dispose this controller.
        final controller = TextEditingController();

        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('OK'),
            ),
          ],
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(hintText: 'Name'),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          title: const Text('Add new project'),
        );
      },
    );

    if (result == null) {
      return;
    }

    await vm.addProject(ProjectInfo.empty(name: result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoundNexus'),
      ),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, child) {
          if (vm.isLoadingProjects) {
            return const Center(child: CircularProgressIndicator());
          } else if (vm.error.isNotEmpty) {
            return Center(child: Text(vm.error));
          } else {
            final projects = vm.projects;

            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ListTile(
                  title: Text(project.name),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem<void>(
                        onTap: () => _onDeletePressed(project),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () => context.go('/project/${project.id}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
