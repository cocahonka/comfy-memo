import 'package:comfy_memo/src/common/dependencies.dart';
import 'package:flutter/widgets.dart';

base class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  final Dependencies dependencies;

  static Dependencies of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DependenciesScope>()!
      .dependencies;

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) =>
      !identical(dependencies, oldWidget.dependencies);
}
