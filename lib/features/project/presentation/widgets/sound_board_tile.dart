import 'dart:io';
import 'dart:ui';

import 'package:context_watch/context_watch.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/project/presentation/project_page_view_model.dart';
import 'package:soundnexus/features/project/presentation/widgets/volume_slider.dart';
import 'package:soundnexus/features/projects/domain/audio_file.dart';
import 'package:soundnexus/global/widgets/app_draggable.dart';
import 'package:uuid/v4.dart';

const _maxTileSize = 160.0;
final _tileBorderRadius = BorderRadius.circular(16);

class SoundBoardTile extends StatefulWidget {
  const SoundBoardTile(this.vm, this.x, this.y, {super.key});

  final ProjectPageViewModel vm;
  final int x;
  final int y;

  @override
  State<SoundBoardTile> createState() => _SoundBoardTileState();
}

class _SoundBoardTileState extends State<SoundBoardTile> {
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
