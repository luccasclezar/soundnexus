import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppDragType {
  /// On Desktop, it resolves to [instant]; on mobile, to [delayed].
  adaptive,

  /// Starts the drag as soon as the user makes contact with the widget.
  instant,

  /// Needs a long click/press to start the drag.
  delayed;

  /// If this is [adaptive], resolves to [instant] on desktop and [delayed] on
  /// mobile.
  AppDragType resolve() => this == adaptive
      ? (Platform.isLinux || Platform.isWindows || Platform.isMacOS
          ? instant
          : delayed)
      : this;
}

/// A draggable widget that uses either a [Draggable] or an
/// [AppLongPressDraggable] depending on [type].
class AppDraggable<T extends Object> extends StatelessWidget {
  /// Constructs an [AppDraggable] either using a [Draggable] or an
  /// [AppLongPressDraggable] depending on [type].
  ///
  /// All other fields are inherited from [Draggable].
  const AppDraggable({
    required this.feedback,
    required this.type,
    required this.child,
    super.key,
    this.centerDesktopFeedback = false,
    this.childWhenDragging,
    this.data,
    this.enabled = true,
    this.ignoringFeedbackPointer = true,
    this.rootOverlay = false,
    this.onDragCompleted,
    this.onDragEnd,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
  });

  final T? data;
  final bool enabled;
  final bool ignoringFeedbackPointer;
  final bool rootOverlay;

  final void Function()? onDragCompleted;
  final void Function(DraggableDetails details)? onDragEnd;
  final void Function()? onDragStarted;
  final void Function(DragUpdateDetails details)? onDragUpdate;
  final void Function(Velocity velocity, Offset offset)? onDraggableCanceled;

  /// Determines if [feedback] will be centered in the pointer when dragging
  /// on desktop.
  ///
  /// If this is false, the [feedback] will be displayed with its top-left
  /// corner anchored to the pointer instead of its center.
  ///
  /// Mobile devices are always centered and moved a little up for the user to
  /// be able to see what's being dragged with their finger atop it.
  final bool centerDesktopFeedback;

  /// The widget below this widget in the tree.
  ///
  /// This widget displays [child] when zero drags are under way. If
  /// [childWhenDragging] is non-null, this widget instead displays
  /// [childWhenDragging] when one or more drags are underway. Otherwise, this
  /// widget always displays [child].
  ///
  /// The [feedback] widget is shown under the pointer when a drag is under way.
  final Widget child;

  /// The widget to display instead of [child] when one or more drags are under
  /// way.
  ///
  /// If this is null, then this widget will always display [child] (and so the
  /// drag source representation will not change while a drag is under
  /// way).
  ///
  /// The [feedback] widget is shown under the pointer when a drag is under way.
  final Widget? childWhenDragging;

  /// The widget to show under the pointer when a drag is under way.
  ///
  /// A [FractionalTranslation] is already added automatically when [type]
  /// resolves to [AppDragType.delayed] (touch pointers) to center the feedback
  /// on the finger with a negative Y offset for the user to see the feedback
  /// while dragging.
  ///
  /// See [child] and [childWhenDragging] for information about what is shown
  /// at the location of the [Draggable] itself when a drag is under way.
  final Widget feedback;

  /// The type of this Draggable.
  ///
  /// Depending on this value, either a [Draggable] or an
  /// [AppLongPressDraggable] will be built.
  ///
  /// To build a [Draggable] on desktop and an [AppLongPressDraggable] on
  /// mobile, set this to [AppDragType.adaptive].
  final AppDragType type;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      final resolvedType = type.resolve();

      if (resolvedType == AppDragType.instant) {
        return Draggable<T>(
          data: data,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: FractionalTranslation(
            translation:
                centerDesktopFeedback ? const Offset(-.5, -.5) : Offset.zero,
            child: feedback,
          ),
          ignoringFeedbackPointer: ignoringFeedbackPointer,
          onDragStarted: () {
            HapticFeedback.vibrate();
            onDragStarted?.call();
          },
          onDragCompleted: onDragCompleted,
          onDragEnd: onDragEnd,
          onDragUpdate: onDragUpdate,
          onDraggableCanceled: onDraggableCanceled,
          rootOverlay: rootOverlay,
          childWhenDragging: childWhenDragging,
          child: child,
        );
      } else {
        return AppLongPressDraggable<T>(
          data: data,
          dragAnchorStrategy: (draggable, context, position) {
            return const Offset(0, 24);
          },
          feedback: FractionalTranslation(
            translation: const Offset(-.5, -.7),
            child: feedback,
          ),
          hapticFeedbackOnStart: false,
          ignoringFeedbackPointer: ignoringFeedbackPointer,
          onDragStarted: () {
            HapticFeedback.vibrate();
            onDragStarted?.call();
          },
          onDragCompleted: onDragCompleted,
          onDragEnd: onDragEnd,
          onDragUpdate: onDragUpdate,
          onDraggableCanceled: onDraggableCanceled,
          rootOverlay: rootOverlay,
          childWhenDragging: childWhenDragging,
          child: child,
        );
      }
    } else {
      return child;
    }
  }
}

/// Makes its child draggable starting from long press.
///
/// See also:
///
///  * [Draggable], similar to the [LongPressDraggable] widget but happens
/// immediately.
///  * [DragTarget], a widget that receives data when a [Draggable] widget is
///  dropped.
class AppLongPressDraggable<T extends Object> extends Draggable<T> {
  /// Creates a widget that can be dragged starting from long press.
  ///
  /// The [child] and [feedback] arguments must not be null. If
  /// [maxSimultaneousDrags] is non-null, it must be non-negative.
  const AppLongPressDraggable({
    required super.child,
    required super.feedback,
    super.key,
    super.data,
    super.axis,
    super.childWhenDragging,
    super.feedbackOffset,
    super.dragAnchorStrategy,
    super.maxSimultaneousDrags,
    super.rootOverlay,
    super.onDragStarted,
    super.onDragUpdate,
    super.onDraggableCanceled,
    super.onDragEnd,
    super.onDragCompleted,
    this.hapticFeedbackOnStart = true,
    super.ignoringFeedbackSemantics,
    super.ignoringFeedbackPointer,
    this.delay = kLongPressTimeout,
  });

  /// Whether haptic feedback should be triggered on drag start.
  final bool hapticFeedbackOnStart;

  /// The duration that a user has to press down before a long press is
  /// registered.
  ///
  /// Defaults to [kLongPressTimeout].
  final Duration delay;

  @override
  DelayedMultiDragGestureRecognizer createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) {
    return DelayedMultiDragGestureRecognizer(delay: delay)
      ..onStart = (Offset position) {
        final result = onStart(position);
        if (result != null && hapticFeedbackOnStart) {
          HapticFeedback.selectionClick();
        }
        return result;
      };
  }
}
