import 'package:flutter/material.dart';

abstract class VMWidget<VM extends ChangeNotifier> extends StatelessWidget {
  const VMWidget({super.key});

  bool get isReactive => false;

  VM viewModelBuilder();

  Widget builder(BuildContext context, VM vm);

  @override
  Widget build(BuildContext context) {
    return _VMStatefulWidget(
      isReactive: isReactive,
      viewModelBuilder: viewModelBuilder,
      builder: builder,
    );
  }
}

class _VMStatefulWidget<VM extends ChangeNotifier> extends StatefulWidget {
  const _VMStatefulWidget({
    required this.isReactive,
    required this.viewModelBuilder,
    required this.builder,
  });

  final Widget Function(BuildContext context, VM vm) builder;
  final VM Function() viewModelBuilder;
  final bool isReactive;

  @override
  _VMWidgetState createState() => _VMWidgetState<VM>();
}

class _VMWidgetState<VM extends ChangeNotifier>
    extends VMState<_VMStatefulWidget, VM> {
  @override
  VM createViewModel() => widget.viewModelBuilder() as VM;

  @override
  Widget build(BuildContext context) {
    if (widget.isReactive) {
      return ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => widget.builder(context, _viewModel),
      );
    } else {
      return widget.builder(context, _viewModel);
    }
  }
}

abstract class VMState<T extends StatefulWidget, VM extends ChangeNotifier>
    extends State<T> {
  VM get vm => _viewModel;

  late VM _viewModel;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _viewModel = createViewModel();
  }

  /// Use this when creating reactive widgets. This will rebuild the widget when
  /// the ViewModel changes.
  ///
  /// If you don't want the widget to rebuild when the ViewModel changes,
  /// directly override [build].
  Widget builder(BuildContext context, VM vm) {
    throw UnimplementedError();
  }

  VM createViewModel();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) => builder(context, vm),
    );
  }
}
