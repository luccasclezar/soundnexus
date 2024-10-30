import 'dart:ui';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/project/presentation/project_page_controller.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/global/widgets/app_draggable.dart';
import 'package:soundnexus/global/widgets/spin_box.dart';
import 'package:soundnexus/main.dart';
import 'package:uuid/v4.dart';

const _maxTileSize = 180.0;
final _tileBorderRadius = BorderRadius.circular(16);

class ProjectPage extends ConsumerWidget {
  const ProjectPage({required this.projectId, super.key});

  final String projectId;

  Future<void> _onSettingsPressed(BuildContext context, WidgetRef ref) async {
    final controller =
        ref.read(projectPageControllerProvider(projectId).notifier);
    final project = ref.read(projectProvider(projectId)).value!;

    final newProject = await showDialog<Project>(
      context: context,
      builder: (context) {
        var newProject = project.copyWith();

        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => navigatorKey.currentContext!.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => navigatorKey.currentContext!.pop(newProject),
              child: const Text('Save'),
            ),
          ],
          title: const Text('Settings'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Columns'),
                  trailing: SpinBox(
                    initialValue: project.columns,
                    onValueChanged: (value) =>
                        newProject = newProject.copyWith(columns: value),
                  ),
                ),
                ListTile(
                  title: const Text('Rows'),
                  trailing: SpinBox(
                    initialValue: project.rows,
                    onValueChanged: (value) =>
                        newProject = newProject.copyWith(rows: value),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (newProject != null) {
      await controller.updateProject(newProject);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        actions: projectAsync.when(
          data: (data) => [
            IconButton(
              onPressed: () => _onSettingsPressed(context, ref),
              icon: const Icon(Icons.settings_rounded),
            ),
          ],
          error: (error, stackTrace) => null,
          loading: () => null,
        ),
        forceMaterialTransparency: true,
        title: projectAsync.when(
          data: (data) => Text(data.name),
          error: (error, stackTrace) => const SizedBox.shrink(),
          loading: SizedBox.shrink,
        ),
      ),
      body: projectAsync.when(
        data: (data) => Column(
          children: [
            ControlBar(projectId),
            Expanded(child: _SoundBoard(projectId)),
          ],
        ),
        error: (error, stackTrace) => const Center(
          child: Text('There was an error loading the project'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ControlBar extends ConsumerWidget {
  const ControlBar(this.projectId, {super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(projectPageControllerProvider(projectId));
    final controller =
        ref.watch(projectPageControllerProvider(projectId).notifier);

    return Row(
      children: [
        IconButton(
          onPressed: model.isPlaying ? controller.stop : null,
          icon: const Icon(Icons.pause_rounded),
        ),
        const Spacer(),
        Text(model.volume.toString()),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Slider(
            value: model.volume,
            onChanged: controller.setVolume,
          ),
        ),
      ],
    );
  }
}

class _SoundBoard extends ConsumerStatefulWidget {
  const _SoundBoard(this.projectId);

  final String projectId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SoundBoardState();
}

class _SoundBoardState extends ConsumerState<_SoundBoard> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectId = widget.projectId;

    final project = ref.watch(projectProvider(projectId)).value!;

    return Scrollbar(
      controller: scrollController,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: project.rows * _maxTileSize,
            maxWidth: project.columns * _maxTileSize,
          ),
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: project.columns,
            ),
            itemCount: project.columns * project.rows,
            itemBuilder: (context, index) {
              final x = index % project.columns;
              final y = (index / project.columns).floor();

              return _SoundBoardTile(projectId, x, y);
            },
          ),
        ),
      ),
    );
  }
}

class _SoundBoardTile extends ConsumerStatefulWidget {
  const _SoundBoardTile(this.projectId, this.x, this.y);

  final String projectId;
  final int x;
  final int y;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SoundBoardTileState();
}

class _SoundBoardTileState extends ConsumerState<_SoundBoardTile> {
  bool isDropping = false;

  Future<void> _onAcceptDrag(
    BuildContext context,
    ProjectPageController controller,
    DragTargetDetails<AudioFile> details,
    AudioFile? audioFile,
  ) async {
    final draggedAudioFile = details.data;

    if (audioFile != null) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('Overwrite'),
            ),
          ],
          content: const Text(
            "This will overwrite this tile's current audio.",
          ),
          title: const Text('Are you sure?'),
        ),
      );

      if (result != true) {
        return;
      }
    }

    final x = widget.x;
    final y = widget.y;

    await controller.moveAudioFile(draggedAudioFile, x, y);
  }

  void _onNativeDragDone(
    DropDoneDetails details,
    ProjectPageController controller,
  ) {
    setState(() => isDropping = false);

    if (details.files.length != 1) {
      return;
    }

    final x = widget.x;
    final y = widget.y;

    final file = details.files.first;
    final extension = file.path.split('.').last;

    // Supported file types. Untested on Windows.
    if (!{'wav', 'mp3', 'm4a', 'aac', 'mp4'}.contains(extension)) {
      return;
    }

    // Take the file name without extension as the AudioFile's initial name.
    final name = file.path.split('/').last.split('.').first;

    controller.setAudioFile(
      AudioFile(
        id: const UuidV4().generate(),
        path: file.path,
        name: name,
        positionX: x,
        positionY: y,
        volume: 1,
      ),
      x,
      y,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final x = widget.x;
    final y = widget.y;

    final controller =
        ref.watch(projectPageControllerProvider(widget.projectId).notifier);

    final audioFile = ref.watch(audioFileProvider(widget.projectId, x, y));

    return Padding(
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropTarget(
            onDragEntered: (details) => setState(() => isDropping = true),
            onDragExited: (details) => setState(() => isDropping = false),
            onDragDone: (details) => _onNativeDragDone(details, controller),
            child: DragTarget<AudioFile>(
              onAcceptWithDetails: (details) =>
                  _onAcceptDrag(context, controller, details, audioFile),
              onWillAcceptWithDetails: (details) => details.data != audioFile,
              builder: (context, candidateData, rejectedData) {
                return AppDraggable(
                  data: audioFile,
                  enabled: audioFile != null,
                  feedback: Container(
                    height: constraints.maxWidth,
                    width: constraints.maxWidth,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: _tileBorderRadius,
                      color: Colors.black.withOpacity(.6),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: _SoundBoardTileContent(
                        audioFile: audioFile,
                        isDroppingAudio: isDropping || candidateData.isNotEmpty,
                        projectId: widget.projectId,
                        x: x,
                        y: y,
                      ),
                    ),
                  ),
                  type: AppDragType.adaptive,
                  child: Container(
                    height: constraints.maxWidth,
                    width: constraints.maxWidth,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: _tileBorderRadius,
                      color: candidateData.isNotEmpty
                          ? theme.colorScheme.surfaceContainer
                          : null,
                    ),
                    child: _SoundBoardTileContent(
                      audioFile: audioFile,
                      isDroppingAudio: isDropping || candidateData.isNotEmpty,
                      projectId: widget.projectId,
                      x: x,
                      y: y,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SoundBoardTileContent extends ConsumerWidget {
  const _SoundBoardTileContent({
    required this.audioFile,
    required this.isDroppingAudio,
    required this.projectId,
    required this.x,
    required this.y,
  });

  final AudioFile? audioFile;
  final bool isDroppingAudio;
  final String projectId;
  final int x;
  final int y;

  Future<void> _onDelete(WidgetRef ref) async {
    await ref
        .read(projectPageControllerProvider(projectId).notifier)
        .setAudioFile(null, x, y);
  }

  Future<void> _onTap(ProjectPageController controller) async {
    controller.toggleAudio(x, y);
  }

  Future<void> _onSecondaryTap(
    BuildContext context,
    WidgetRef ref,
    TapUpDetails details,
  ) async {
    final dx = details.globalPosition.dx;
    final dy = details.globalPosition.dy;
    final position = RelativeRect.fromLTRB(
      dx,
      dy,
      dx,
      0,
    );

    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<void>(
          child: const Text('Delete'),
          onTap: () => _onDelete(ref),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final controller =
        ref.watch(projectPageControllerProvider(projectId).notifier);

    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: _tileBorderRadius,
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      type: MaterialType.transparency,
      child: isDroppingAudio
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded),
                  Gap(8),
                  Text('Add audio here'),
                ],
              ),
            )
          : (audioFile != null
              ? InkWell(
                  onTap: audioFile == null ? null : () => _onTap(controller),
                  onSecondaryTapUp: audioFile == null
                      ? null
                      : (d) => _onSecondaryTap(context, ref, d),
                  child: Builder(
                    builder: (context) {
                      final audioFile = this.audioFile;

                      if (audioFile != null) {
                        return Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    audioFile.name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Slider(
                              value: audioFile.volume,
                              onChanged: (value) => controller.setAudioFile(
                                audioFile.copyWith(volume: value),
                                x,
                                y,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                )
              : null),
    );
  }
}
