import 'package:flutter/material.dart';

class SpinBoxController {
  _SpinBoxState? _state;

  int get value => _state!.value;
  set value(int value) {
    _state!.value = value;
  }
}

class SpinBox extends StatefulWidget {
  const SpinBox({
    required this.initialValue,
    this.controller,
    this.onValueChanged,
    super.key,
  });

  final SpinBoxController? controller;
  final int initialValue;
  final void Function(int value)? onValueChanged;

  @override
  State<SpinBox> createState() => _SpinBoxState();
}

class _SpinBoxState extends State<SpinBox> {
  late SpinBoxController _controller;
  late int value = widget.initialValue;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? SpinBoxController();
    _controller._state = this;
  }

  @override
  void didUpdateWidget(covariant SpinBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller._state = null;

      _controller = widget.controller ?? SpinBoxController();
      _controller._state = this;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              value--;
              widget.onValueChanged?.call(value);
            });
          },
          icon: const Icon(Icons.remove_rounded),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            value.toString(),
            style: theme.textTheme.titleSmall,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              value++;
              widget.onValueChanged?.call(value);
            });
          },
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}
