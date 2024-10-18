import 'package:audioplayers/audioplayers.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/project/presentation/project_page_controller.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/global/widgets/spin_box.dart';
import 'package:soundnexus/main.dart';

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
            max: 1.2,
            value: model.volume,
            onChanged: controller.setVolume,
          ),
        ),
      ],
    );
  }
}

class _SoundBoard extends ConsumerWidget {
  const _SoundBoard(this.projectId);

  static const double maxTileSize = 140;

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider(projectId)).value!;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: project.rows * maxTileSize,
          maxWidth: project.columns * maxTileSize,
        ),
        child: GridView.builder(
          itemCount: project.columns * project.rows,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: project.columns,
          ),
          itemBuilder: (context, index) {
            final x = index % project.columns;
            final y = (index / project.columns).floor();

            return _SoundBoardTile(projectId, x, y);
          },
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
  final player = AudioPlayer();
  bool isDropping = false;

  @override
  Future<void> dispose() async {
    await player.release();
    await player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final x = widget.x;
    final y = widget.y;

    final controller =
        ref.watch(projectPageControllerProvider(widget.projectId).notifier);

    final model = ref.watch(projectPageControllerProvider(widget.projectId));
    final audioFile = ref.watch(audioFileProvider(widget.projectId, x, y));

    ref.listen(
      audioFileProvider(widget.projectId, x, y),
      (previous, next) {
        if (next == null) {
          player.stop();
          return;
        }

        // TODO(Luccas): Implement the other AudioFile properties.
        if (previous?.volume != next.volume) {
          player.setVolume(next.volume * model.volume);
        }
      },
    );
    ref.listen(
      projectPageControllerProvider(widget.projectId),
      (previous, next) {
        if (previous == null) {
          return;
        }

        if (previous.volume != next.volume) {
          player.setVolume((audioFile?.volume ?? 1) * next.volume);
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropTarget(
            onDragEntered: (details) => setState(() => isDropping = true),
            onDragExited: (details) => setState(() => isDropping = false),
            onDragDone: (details) {
              setState(() => isDropping = false);

              if (details.files.length != 1) {
                return;
              }

              final file = details.files.first;
              final extension = file.path.split('.').last;

              if (!{'wav', 'mp3', 'm4a'}.contains(extension)) {
                return;
              }

              final name = file.path.split('/').last.split('.').first;

              controller.setAudioFile(
                AudioFile(
                  path: file.path,
                  name: name,
                  positionX: x,
                  positionY: y,
                  volume: 1,
                ),
                x,
                y,
              );
            },
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                clipBehavior: Clip.hardEdge,
                type: MaterialType.transparency,
                child: isDropping
                    ? const Center(child: Text('Add audio here'))
                    : (audioFile != null
                        ? _SoundBoardTileContent(
                            audioFile: audioFile,
                            player: player,
                            projectId: widget.projectId,
                            x: x,
                            y: y,
                          )
                        : null),
              ),
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
    required this.player,
    required this.projectId,
    required this.x,
    required this.y,
  });

  final AudioFile audioFile;
  final AudioPlayer player;
  final String projectId;
  final int x;
  final int y;

  Future<void> _onDelete(WidgetRef ref) async {
    await ref
        .read(projectPageControllerProvider(projectId).notifier)
        .setAudioFile(null, x, y);
  }

  Future<void> _onTap() async {
    if (player.state == PlayerState.playing) {
      await player.pause();
    } else {
      await player.play(DeviceFileSource(audioFile.path));
    }
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
    final controller =
        ref.watch(projectPageControllerProvider(projectId).notifier);

    return InkWell(
      onTap: _onTap,
      onSecondaryTapUp: (d) => _onSecondaryTap(context, ref, d),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(audioFile.name),
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
      ),
    );
  }
}
