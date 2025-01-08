import 'package:flutter/foundation.dart'
    show ChangeNotifier, Listenable, ValueListenable, VoidCallback;
import 'package:flutter/material.dart';

/// Selector from [Listenable]
typedef ListenableSelectorDelegate<Controller extends Listenable, Value> = Value
    Function(Controller controller);

/// Filter for [Listenable]
typedef ListenableFilterDelegate<Value> = bool Function(Value prev, Value next);

class ListenableSelector<Controller extends Listenable, Value>
    extends StatefulWidget {
  const ListenableSelector({
    required this.listenable,
    required this.builder,
    this.child,
    super.key,
  });

  final ValueListenableView<Controller, Value> listenable;
  final Widget Function(BuildContext context, Value value, Widget? child)
      builder;
  final Widget? child;

  @override
  State<ListenableSelector<Controller, Value>> createState() =>
      _ListenableSelectorState();
}

class _ListenableSelectorState<Controller extends Listenable, Value>
    extends State<ListenableSelector<Controller, Value>> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.listenable,
      builder: widget.builder,
      child: widget.child,
    );
  }
}

abstract class SelectorStatelessWidget<Controller extends Listenable, Value>
    extends StatelessWidget {
  const SelectorStatelessWidget({super.key});

  ValueListenableView<Controller, Value> get listenable;
  Widget Function(BuildContext context, Value value) get builder;

  @override
  Widget build(BuildContext context) {
    return ListenableSelector(
      listenable: listenable,
      builder: (context, value, child) => builder(context, value),
    );
  }
}

abstract class SelectorState<T extends StatefulWidget,
    Controller extends Listenable, Value> extends State<T> {
  ValueListenableView<Controller, Value> get listenable;

  Widget builder(BuildContext context, Value value);

  @override
  Widget build(BuildContext context) {
    return ListenableSelector(
      listenable: listenable,
      builder: (context, value, child) => builder(context, value),
    );
  }
}

extension ListenableSelectorExtension<Controller extends Listenable>
    on Controller {
  /// Selects a specific value from the [Listenable] using [selector] for
  /// subsequent use in a ValueListenableBuilder.
  ///
  /// If [test] is provided, only when it returns false notifyListeners won't be
  /// called. Else, it's not called only when this Listenable changes but
  /// [selector] returns an identical object.
  ///
  /// For example:
  /// ```dart
  /// ValueListenableBuilder<Locale>(
  ///   valueListenable: appModel.select<Locale>(
  ///     (cn) => cn.locale,
  ///     (prev, next) => prev.languageCode != next.languageCode
  ///   ),
  ///   builder: (context, locale, child) => Text(locale.languageCode),
  /// )
  /// ```
  ValueListenableView<Controller, Value> select<Value>(
    ListenableSelectorDelegate<Controller, Value> selector, [
    ListenableFilterDelegate<Value>? test,
  ]) =>
      ValueListenableView<Controller, Value>(this, selector, test);
}

/// A view into a [Listenable], using a selector to listen to specific
/// properties of the controller.
class ValueListenableView<Controller extends Listenable, Value>
    with ChangeNotifier
    implements ValueListenable<Value> {
  /// Transforms [controller] into a ValueListenable by using [selector] to
  /// isolate a property from [controller].
  ///
  /// If [test] is provided, only when it returns false notifyListeners won't be
  /// called. Else, it's not called only when [controller] changes but
  /// [selector] returns an identical object.
  ValueListenableView(
    Controller controller,
    ListenableSelectorDelegate<Controller, Value> selector,
    ListenableFilterDelegate<Value>? test,
  )   : _controller = controller,
        _selector = selector,
        _test = test;

  final Controller _controller;
  final ListenableSelectorDelegate<Controller, Value> _selector;
  final ListenableFilterDelegate<Value>? _test;

  @override
  Value get value => hasListeners ? _$value : _selector(_controller);

  late Value _$value;

  void _update() {
    final newValue = _selector(_controller);
    if (identical(_$value, newValue)) return;
    if (!(_test?.call(_$value, newValue) ?? true)) return;
    _$value = newValue;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) {
      _$value = _selector(_controller);
      _controller.addListener(_update);
    }
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) _controller.removeListener(_update);
  }

  @override
  void dispose() {
    _controller.removeListener(_update);
    super.dispose();
  }
}
