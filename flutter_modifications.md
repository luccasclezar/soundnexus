## Updating DesktopMouseTracker

DesktopMouseTracker is a class that prevents the cursor from becoming a pointer
when hovering buttons (as it is natively) on desktop platforms.

This class is actually copied almost in its entirety from Flutter's
MouseTracker file, but with a simple change that prevents the pointer cursor.

To update the DesktopMouseTracker class, follow these instructions:

1. Copy the whole `mouse_tracker.dart` file from Flutter
(`flutter/lib/source/rendering/mouse_tracker.dart`) to
`desktop_mouse_tracker.dart`.

2. Add these ignores as the first line:

```dart
// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, comment_references, prefer_collection_literals, require_trailing_commas, prefer_asserts_with_message, cascade_invocations
```

3. Rename `MouseTracker` to `DesktopMouseTracker`.

4. Change the super class from `ChangeNotifier` to `MouseTracker` (import
`flutter/rendering.dart`).

5. Instead of using the super parameter on the `MouseTracker` ctor, use a
static method like this:

```dart
DesktopMouseTracker()
  : _hitTestInView = defaultHitTestInView,
    super(defaultHitTestInView);

static HitTestResult defaultHitTestInView(Offset position, int viewId) {
  final result = HitTestResult();
  RendererBinding.instance.hitTestInView(result, position, viewId);
  return result;
}
```

6. Add `@overrides` (saving should add them automatically).

7. Find `_handleDeviceUpdate` method and update the callback for the cursor
type to this:

```dart
details.nextAnnotations.keys.map(
  (MouseTrackerAnnotation annotation) =>
      annotation.cursor != SystemMouseCursors.click
          ? annotation.cursor
          : SystemMouseCursors.basic,
),
```
