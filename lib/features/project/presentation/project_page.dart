import 'dart:io';
import 'dart:ui';

import 'package:context_watch/context_watch.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/project/presentation/project_page_view_model.dart';
import 'package:soundnexus/features/project/presentation/properties_drawer.dart';
import 'package:soundnexus/features/project/presentation/widgets/volume_slider.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/features/projects/domain/project_tab.dart';
import 'package:soundnexus/global/globals.dart';
import 'package:soundnexus/global/widgets/app_draggable.dart';
import 'package:soundnexus/global/widgets/spin_box.dart';
import 'package:soundnexus/global/widgets/vm_state.dart';
import 'package:uuid/v4.dart';

const _maxTileSize = 160.0;
final _tileBorderRadius = BorderRadius.circular(16);

class ProjectPage extends VMWidget<ProjectPageViewModel> {
  const ProjectPage({required this.projectId, super.key});

  final String projectId;

  @override
  ProjectPageViewModel viewModelBuilder() =>
      ProjectPageViewModel(getIt<ProjectsRepository>(), projectId);

  Future<void> _onSettingsPressed(
    BuildContext context,
    ProjectPageViewModel vm,
  ) async {
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
    final isLoading = vm.watchOnly(context, (e) => e.isLoading);
    final isReady = vm.watchOnly(context, (e) => e.isReady);
    final error = vm.watchOnly(context, (e) => e.error);

    final theme = Theme.of(context);

    final Widget body;

    if (isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (error.isNotEmpty) {
      body = Center(child: Text('Error: $error'));
    } else {
      body = Row(
        children: [
          _ControlBar(vm),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(24)),
                color: theme.colorScheme.surfaceContainerLowest,
              ),
              child: _SoundBoard(vm),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isReady)
            IconButton(
              onPressed: () => _onSettingsPressed(context, vm),
              icon: const Icon(Icons.settings_rounded),
            ),
        ],
        forceMaterialTransparency: true,
        title: isReady ? _Titlebar(vm) : null,
      ),
      body: body,
    );
  }
}

class _Titlebar extends StatefulWidget {
  const _Titlebar(this.vm);

  final ProjectPageViewModel vm;

  @override
  State<_Titlebar> createState() => _TitlebarState();
}

class _TitlebarState extends State<_Titlebar> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.vm.updateTabController(this, widget.vm.project.tabs.length);
  }

  Future<void> _onAddTabPressed() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        var tabName = '';

        return AlertDialog(
          title: const Text('New Tab'),
          content: TextField(
            onChanged: (value) => tabName = value,
            decoration: const InputDecoration(hintText: 'Tab name'),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => context.pop(tabName),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (result == null) {
      return;
    }

    widget.vm.addTab(result);
    widget.vm.currentTabIndex = widget.vm.project.tabs.length;
    widget.vm.updateTabController(this, widget.vm.project.tabs.length + 1);
  }

  Future<void> _onTabSecondaryTap(TapUpDetails details, ProjectTab tab) async {
    final vm = widget.vm;

    final offset = details.globalPosition;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, 0),
      items: [
        PopupMenuItem<void>(
          onTap: () {
            vm.deleteTab(tab);
            vm.updateTabController(this, vm.project.tabs.length - 1);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tabs = widget.vm.watchOnly(context, (e) => e.tabs);

    return Row(
      children: [
        // Title
        Text(widget.vm.watchOnly(context, (e) => e.project.name)),

        // Divider
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: 24,
            width: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(color: theme.dividerColor),
            ),
          ),
        ),

        // Tabs
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tabs
                TabBar(
                  controller: widget.vm.tabController,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  tabs: [
                    for (final tab in tabs)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onSecondaryTapUp: (details) =>
                            _onTabSecondaryTap(details, tab),
                        child: Tab(
                          text: tab.name,
                        ),
                      ),
                  ],
                ),

                // Gap
                const Gap(16),

                // Add new tab button
                TextButton.icon(
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add new tab'),
                  onPressed: _onAddTabPressed,
                ),
              ],
            ),
          ),
        ),
      ],
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
        // Control bar
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Edit button`
              Builder(
                builder: (context) {
                  final isEditing = vm.watchOnly(context, (e) => e.isEditing);

                  if (isEditing) {
                    return IconButton.filled(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: vm.onEditPressed,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: vm.onEditPressed,
                    );
                  }
                },
              ),

              // Gap
              const Gap(8),

              // Shortcuts button
              Builder(
                builder: (context) {
                  final isEditingShortcuts =
                      vm.watchOnly(context, (e) => e.isEditingShortcuts);

                  if (isEditingShortcuts) {
                    return IconButton.filled(
                      icon: const Icon(Icons.keyboard_rounded),
                      onPressed: vm.onShortcutsPressed,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.keyboard_rounded),
                      onPressed: vm.onShortcutsPressed,
                    );
                  }
                },
              ),

              // Spacer
              const Spacer(),

              // Stop button
              Builder(
                builder: (context) {
                  final isPlaying = vm.watchOnly(context, (e) => e.isPlaying);

                  return IconButton.filled(
                    onPressed: isPlaying ? vm.stop : null,
                    icon: const Icon(Icons.stop_rounded),
                  );
                },
              ),

              const Gap(16),

              // Volume Slider
              SizedBox(
                height: 300,
                child: VolumeSlider(
                  axis: Axis.vertical,
                  crossAxisDraggingSize: 36,
                  crossAxisSize: 28,
                  volume: vm.volume,
                  onVolumeChanged: vm.setVolume,
                ),
              ),

              // Gap
              const Gap(8),
            ],
          ),
        ),

        // Properties panel
        Builder(
          builder: (context) {
            final isEditing = vm.watchOnly(context, (e) => e.isEditing);

            return AnimatedAlign(
              alignment: Alignment.centerLeft,
              curve: Easing.standard,
              duration: Durations.medium1,
              widthFactor: isEditing ? 1 : 0,
              child: PropertiesDrawer(vm),
            );
          },
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

    final columns = vm.watchOnly(context, (e) => e.project.columns);
    final rows = vm.watchOnly(context, (e) => e.project.rows);

    return Scrollbar(
      controller: vScrollController,
      child: Scrollbar(
        controller: hScrollController,
        notificationPredicate: (notif) => notif.depth == 1,
        child: Center(
          child: SingleChildScrollView(
            controller: vScrollController,
            child: SingleChildScrollView(
              controller: hScrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    for (int row = 0; row < rows; row++)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16,
                        children: [
                          for (var column = 0; column < columns; column++)
                            _SoundBoardTile(vm, column, row),
                        ],
                      ),
                  ],
                ),
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

class _SoundBoardTileState extends State<_SoundBoardTile> {
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
  Widget build(BuildContext context) {
    final vm = widget.vm;

    final x = widget.x;
    final y = widget.y;

    final audioFile = vm.watchOnly(
      context,
      (e) => e.getAudioFile(e.currentTab, widget.x, widget.y),
    );

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
                  child: SizedBox(
                    height: constraints.maxWidth,
                    width: constraints.maxWidth,
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
    // TODO(luccasclezar): Move this to the ViewModel.
    if (vm.isEditing) {
      vm.selectAudio(audioFile!);
    } else if (vm.isNormalView) {
      vm.toggleAudio(vm.currentTab, x, y);
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

    final isEditing = audioFile != null &&
        vm.watchOnly(
          context,
          (e) => e.editingAudios.contains(audioFile.positionId),
        );

    final Widget child;

    if (isDroppingAudio) {
      child = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded),
            Gap(8),
            Text('Add audio here'),
          ],
        ),
      );
    } else if (audioFile != null) {
      final isPlaying =
          vm.watchOnly(context, (e) => e.isAudioPlaying(audioFile.id));
      final showLoadWarningIcon =
          vm.watchOnly(context, (e) => e.audiosWithError[audioFile.id] != null);
      final hasIcons = showLoadWarningIcon;

      child = Column(
        children: [
          // Button & content
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // BG Icon
                if (isPlaying)
                  Positioned.fill(
                    child: Icon(
                      Icons.multitrack_audio_rounded,
                      color: theme.colorScheme.primary.withValues(alpha: .06),
                      size: 120,
                    ),
                  ),

                InkWell(
                  onTap: _onTap,
                  onSecondaryTapUp: (d) => _onSecondaryTap(context, d),
                  child: Column(
                    children: [
                      // Icons row
                      if (hasIcons)
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Spacer(),
                              if (showLoadWarningIcon)
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

                      // Title
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Volume slider
          VolumeSlider(
            axis: Axis.horizontal,
            crossAxisDraggingSize: 32,
            crossAxisSize: 24,
            hasRoundedCorners: false,
            volume: audioFile.volume,
            onVolumeChanged: (volume) => vm.setAudioFile(
              audioFile.copyWith(volume: volume),
              x,
              y,
            ),
          ),
        ],
      );
    } else {
      child = const SizedBox.shrink();
    }

    return AnimatedScale(
      curve: Easing.standard,
      duration: Durations.medium1,
      scale: isDroppingAudio ? 1.1 : 1,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: _tileBorderRadius,
          side: BorderSide(
            color: isEditing
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isEditing ? 2 : 1,
          ),
        ),
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
