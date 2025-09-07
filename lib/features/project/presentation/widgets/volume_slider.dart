import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({
    required this.axis,
    required this.crossAxisDraggingSize,
    required this.crossAxisSize,
    required this.volume,
    required this.onVolumeChanged,
    this.hasRoundedCorners = true,
    super.key,
  });

  final Axis axis;
  final double crossAxisDraggingSize;
  final double crossAxisSize;
  final bool hasRoundedCorners;
  final double volume;
  final void Function(double volume) onVolumeChanged;

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  bool isDragging = false;
  late double volume;

  @override
  void initState() {
    super.initState();
    volume = widget.volume;
  }

  @override
  void didUpdateWidget(covariant VolumeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.volume != widget.volume) {
      setState(() {
        volume = widget.volume;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isHorizontal = widget.axis == Axis.horizontal;

    return AnimatedContainer(
      clipBehavior: Clip.antiAlias,
      curve: Easing.standard,
      duration: Durations.medium1,
      decoration: BoxDecoration(
        borderRadius:
            widget.hasRoundedCorners ? BorderRadius.circular(24) : null,
      ),
      width: !isHorizontal
          ? (isDragging ? widget.crossAxisDraggingSize : widget.crossAxisSize)
          : null,
      height: isHorizontal
          ? (isDragging ? widget.crossAxisDraggingSize : widget.crossAxisSize)
          : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onHorizontalDragStart: (_) => setState(() => isDragging = true),
            onHorizontalDragEnd: (_) => setState(() => isDragging = false),
            onHorizontalDragUpdate: (details) {
              if (!isHorizontal) {
                return;
              }

              setState(() {
                volume = (volume + details.delta.dx / constraints.maxWidth)
                    .clamp(0.0, 1.0);
                widget.onVolumeChanged(volume);
              });
            },
            onVerticalDragStart: (_) => setState(() => isDragging = true),
            onVerticalDragEnd: (_) => setState(() => isDragging = false),
            onVerticalDragUpdate: (details) {
              if (isHorizontal) {
                return;
              }

              setState(() {
                volume = (volume - details.delta.dy / constraints.maxHeight)
                    .clamp(0.0, 1.0);
                widget.onVolumeChanged(volume);
              });
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainerHigh,
                    child: Flex(
                      direction: widget.axis,
                      children: [
                        const Gap(8),
                        Icon(
                          isHorizontal
                              ? Icons.volume_down_rounded
                              : Icons.volume_up_rounded,
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: .7),
                          size: 20,
                        ),
                        const Spacer(),
                        RotatedBox(
                          quarterTurns: isHorizontal ? 0 : -1,
                          child: Text(
                            volume.toStringAsFixed(2),
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: .7),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          isHorizontal
                              ? Icons.volume_up_rounded
                              : Icons.volume_down_rounded,
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: .7),
                          size: 20,
                        ),
                        const Gap(8),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ClipRect(
                    clipper: _ClipRect(isHorizontal, volume),
                    child: ColoredBox(
                      color: theme.colorScheme.primary,
                      child: Flex(
                        direction: widget.axis,
                        children: [
                          const Gap(8),
                          Icon(
                            isHorizontal
                                ? Icons.volume_down_rounded
                                : Icons.volume_up_rounded,
                            color: theme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          const Spacer(),
                          RotatedBox(
                            quarterTurns: isHorizontal ? 0 : -1,
                            child: Text(
                              volume.toStringAsFixed(2),
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            isHorizontal
                                ? Icons.volume_up_rounded
                                : Icons.volume_down_rounded,
                            color: theme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          const Gap(8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClipRect extends CustomClipper<Rect> {
  const _ClipRect(this.isHorizontal, this.volume);

  final bool isHorizontal;
  final double volume;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      0,
      isHorizontal ? 0 : size.height * (1 - volume),
      isHorizontal ? size.width * volume : size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    if (oldClipper is! _ClipRect) {
      return true;
    }

    if (oldClipper.isHorizontal == isHorizontal &&
        oldClipper.volume == volume) {
      return false;
    }

    return true;
  }
}
