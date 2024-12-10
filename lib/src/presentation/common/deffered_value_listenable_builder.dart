import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

base class DefferedValueListenableBuilder<T> extends StatefulWidget {
  const DefferedValueListenableBuilder({
    required this.valueListenable,
    required this.builder,
    super.key,
    this.child,
  });

  final ValueListenable<T> valueListenable;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  State<StatefulWidget> createState() =>
      _DefferedValueListenableBuilderState<T>();
}

base class _DefferedValueListenableBuilderState<T>
    extends State<DefferedValueListenableBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(DefferedValueListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    value = widget.valueListenable.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
