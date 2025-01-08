import 'package:flutter/material.dart';

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
