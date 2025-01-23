import 'dart:io';
import 'dart:ui';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:soundnexus/features/project/presentation/project_page_view_model.dart';
import 'package:soundnexus/features/project/presentation/properties_drawer.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/global/globals.dart';
import 'package:soundnexus/global/widgets/app_draggable.dart';
import 'package:soundnexus/global/widgets/listenable_selector.dart';
import 'package:soundnexus/global/widgets/spin_box.dart';
import 'package:soundnexus/global/widgets/vm_state.dart';
import 'package:uuid/v4.dart';

const _maxTileSize = 160.0;
final _tileBorderRadius = BorderRadius.circular(16);

class ProjectPage extends StatefulWidget {
  const ProjectPage({required this.projectId, super.key});

  final String projectId;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends VMState<ProjectPage, ProjectPageViewModel> {
  @override
  ProjectPageViewModel createViewModel() =>
      ProjectPageViewModel(getIt<ProjectsRepository>(), widget.projectId);

  Future<void> _onSettingsPressed(BuildContext context) async {
    final project = vm.project;

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
      await vm.updateProject(newProject);
    }
  }

  @override
  Widget builder(BuildContext context, ProjectPageViewModel vm) {
    final Widget body;

    if (vm.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (vm.error.isNotEmpty) {
      body = Center(child: Text('Error: ${vm.error}'));
    } else {
      body = Row(
        children: [
          PropertiesDrawer(vm),
          Expanded(
            child: Column(
              children: [
                _ControlBar(vm),
                Expanded(child: _SoundBoard(vm)),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (vm.isReady)
            IconButton(
              onPressed: () => _onSettingsPressed(context),
              icon: const Icon(Icons.settings_rounded),
            ),
        ],
        forceMaterialTransparency: true,
        title: vm.isReady ? Text(vm.project.name) : null,
      ),
      body: body,
    );
  }
}

class _ControlBar extends StatelessWidget {
  const _ControlBar(this.vm);

  final ProjectPageViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Gap
        const Gap(8),

        // Edit button
        if (vm.isEditing)
          IconButton.filled(
            icon: const Icon(Icons.edit_rounded),
            onPressed: vm.onEditPressed,
          )
        else
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: vm.onEditPressed,
          ),

        // Gap
        const Gap(8),

        // Shortcuts button
        if (vm.isEditingShortcuts)
          IconButton.filled(
            icon: const Icon(Icons.keyboard_rounded),
            onPressed: vm.onShortcutsPressed,
          )
        else
          IconButton(
            icon: const Icon(Icons.keyboard_rounded),
            onPressed: vm.onShortcutsPressed,
          ),

        // Spacer
        const Spacer(),

        // Stop button
        IconButton.filled(
          onPressed: vm.isPlaying ? vm.stop : null,
          icon: const Icon(Icons.stop_rounded),
        ),

        const Gap(24),

        // Divider
        const SizedBox(
          height: 24,
          child: VerticalDivider(width: 1),
        ),

        // Volume Slider
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: InteractiveSlider(
            centerIcon: Text(vm.volume.toStringAsFixed(2)),
            startIcon: const Icon(Icons.volume_down_rounded),
            endIcon: const Icon(Icons.volume_up_rounded),
            iconPosition: IconPosition.inside,
            unfocusedHeight: 28,
            focusedHeight: 36,
            onChanged: vm.setVolume,
          ),
        ),
      ],
    );
  }
}

class _SoundBoard extends StatefulWidget {
  const _SoundBoard(this.vm);

  final ProjectPageViewModel vm;

  @override
  State<_SoundBoard> createState() => _SoundBoardState();
}

class _SoundBoardState extends State<_SoundBoard> {
  final ScrollController vScrollController = ScrollController();
  final ScrollController hScrollController = ScrollController();

  @override
  void dispose() {
    vScrollController.dispose();
    hScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    final project = vm.project;

    return Scrollbar(
      controller: vScrollController,
      child: Scrollbar(
        controller: hScrollController,
        notificationPredicate: (notif) => notif.depth == 1,
        child: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  for (int row = 0; row < project.rows; row++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        for (var column = 0; column < project.columns; column++)
                          _SoundBoardTile(vm, column, row),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoundBoardTile extends StatefulWidget {
  const _SoundBoardTile(this.vm, this.x, this.y);

  final ProjectPageViewModel vm;
  final int x;
  final int y;

  @override
  State<_SoundBoardTile> createState() => _SoundBoardTileState();
}

class _SoundBoardTileState
    extends SelectorState<_SoundBoardTile, ProjectPageViewModel, AudioFile?> {
  @override
  ValueListenableView<ProjectPageViewModel, AudioFile?> get listenable =>
      widget.vm.select((e) => e.getAudioFile(widget.x, widget.y));

  bool isDropping = false;

  Future<void> _onAcceptDrag(
    BuildContext context,
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

    await widget.vm.moveAudioFile(draggedAudioFile, x, y);
  }

  void _onNativeDragDone(DropDoneDetails details) {
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
    final name = file.path.split(Platform.pathSeparator).last.split('.').first;

    widget.vm.setAudioFile(
      AudioFile(
        id: const UuidV4().generate(),
        name: name,
        path: file.path,
        positionX: x,
        positionY: y,
        volume: 1,
      ),
      x,
      y,
    );
  }

  @override
  Widget builder(BuildContext context, AudioFile? audioFile) {
    final theme = Theme.of(context);

    final x = widget.x;
    final y = widget.y;

    final vm = widget.vm;

    return SizedBox(
      height: _maxTileSize,
      width: _maxTileSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropTarget(
            onDragEntered: (details) => setState(() => isDropping = true),
            onDragExited: (details) => setState(() => isDropping = false),
            onDragDone: _onNativeDragDone,
            child: DragTarget<AudioFile>(
              onAcceptWithDetails: (details) =>
                  _onAcceptDrag(context, details, audioFile),
              onWillAcceptWithDetails: (details) => details.data != audioFile,
              builder: (context, candidateData, rejectedData) {
                return AppDraggable(
                  centerDesktopFeedback: true,
                  data: audioFile,
                  enabled: audioFile != null,
                  feedback: Container(
                    height: constraints.maxWidth,
                    width: constraints.maxWidth,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: _tileBorderRadius,
                      color: Colors.black.withValues(alpha: .6),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: _SoundBoardTileContent(
                        audioFile: audioFile,
                        isDroppingAudio: isDropping || candidateData.isNotEmpty,
                        vm: vm,
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
                      vm: vm,
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

class _SoundBoardTileContent extends StatelessWidget {
  const _SoundBoardTileContent({
    required this.audioFile,
    required this.isDroppingAudio,
    required this.vm,
    required this.x,
    required this.y,
  });

  final AudioFile? audioFile;
  final bool isDroppingAudio;
  final ProjectPageViewModel vm;
  final int x;
  final int y;

  Future<void> _onDelete() async {
    await vm.setAudioFile(null, x, y);
  }

  Future<void> _onTap() async {
    if (vm.isEditing) {
      vm.selectAudio(audioFile!);
    } else if (vm.isNormalView) {
      vm.toggleAudio(x, y);
    }
  }

  Future<void> _onSecondaryTap(
    BuildContext context,
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
          onTap: _onDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final audioFile = this.audioFile;

    final isEditing =
        audioFile != null && vm.editingAudios.contains(audioFile.positionId);

    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: _tileBorderRadius,
        side: BorderSide(
          color:
              isEditing ? theme.colorScheme.primary : theme.colorScheme.outline,
          width: isEditing ? 2 : 1,
        ),
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
                  onTap: _onTap,
                  onSecondaryTapUp: (d) => _onSecondaryTap(context, d),
                  child: Builder(
                    builder: (context) {
                      final audioFile = this.audioFile;

                      if (audioFile != null) {
                        return Stack(
                          children: [
                            Column(
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
                                if (vm.isNormalView)
                                  Slider(
                                    value: audioFile.volume,
                                    onChanged: (value) => vm.setAudioFile(
                                      audioFile.copyWith(volume: value),
                                      x,
                                      y,
                                    ),
                                  ),
                              ],
                            ),

                            // Icons row
                            Positioned(
                              top: 6,
                              left: 6,
                              right: 6,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  if (vm.audiosWithError[audioFile.id] != null)
                                    const Tooltip(
                                      message: 'Audio failed to load',
                                      child: Icon(
                                        Icons.warning_rounded,
                                        size: 20,
                                      ),
                                    ),
                                ],
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
