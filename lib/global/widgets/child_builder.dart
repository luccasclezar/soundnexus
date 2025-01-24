import 'package:flutter/material.dart';

class ChildBuilder extends StatelessWidget {
  const ChildBuilder({required this.builder, required this.child, super.key});

  final Widget Function(BuildContext context, Widget child) builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
