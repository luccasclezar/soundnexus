import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/project/presentation/project_page_view_model.dart';
import 'package:soundnexus/features/project/presentation/properties_drawer.dart';
import 'package:soundnexus/features/project/presentation/widgets/sound_board_tile.dart';
import 'package:soundnexus/features/project/presentation/widgets/volume_slider.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/domain/project.dart';
import 'package:soundnexus/features/projects/domain/project_tab.dart';
import 'package:soundnexus/global/globals.dart';
import 'package:soundnexus/global/widgets/spin_box.dart';
import 'package:soundnexus/global/widgets/vm_state.dart';

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
              // Edit button
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
  void initState() {
    super.initState();

    HardwareKeyboard.instance.addHandler(_onKeyPress);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyPress);
    vScrollController.dispose();
    hScrollController.dispose();
    super.dispose();
  }

  bool _onKeyPress(KeyEvent event) {
    final char = event.character;

    if (char == null) {
      return false;
    }

    return widget.vm.handleShortcut(widget.vm.currentTab, char);
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
                            SoundBoardTile(vm, column, row),
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
