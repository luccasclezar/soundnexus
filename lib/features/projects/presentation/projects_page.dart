import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/project_info.dart';
import 'package:soundnexus/features/projects/presentation/projects_page_controller.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsPageController = ref.watch(projectsPageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SoundNexus'),
      ),
      body: ref.watch(projectsProvider).when(
        data: (projects) {
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

              return ListTile(
                title: Text(project.name),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem<void>(
                      onTap: () =>
                          projectsPageController.deleteProject(project.id),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
                onTap: () => context.go('/project/${project.id}'),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text('There was an error loading the projects'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () async {
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

          await projectsPageController
              .addProject(ProjectInfo.empty(name: result));
        },
      ),
    );
  }
}
