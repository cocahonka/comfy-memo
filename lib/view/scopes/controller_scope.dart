import 'package:flutter/widgets.dart';

extension ControllerScopeBuildContextExtension on BuildContext {
  C controllerOf<C extends Listenable>({bool listen = false}) =>
      ControllerScope.of<C>(this, listen: listen);
}

base class ControllerScope<C extends Listenable> extends InheritedWidget {
  const ControllerScope({
    required C controller,
    required super.child,
    super.key,
  }) : _controller = controller;

  final C _controller;

  static C of<C extends Listenable>(
    BuildContext context, {
    bool listen = false,
  }) =>
      maybeOf<C>(context, listen: listen) ??
      _notFoundInheritedWidgetOfExactType();

  static C? maybeOf<C extends Listenable>(
    BuildContext context, {
    bool listen = false,
  }) {
    final element =
        context.getElementForInheritedWidgetOfExactType<ControllerScope<C>>();
    if (listen && element != null) context.dependOnInheritedElement(element);
    return element is _ControllerScopeElement<C> ? element._controller : null;
  }

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a ControllerScope of the exact type',
        'out_of_scope',
      );

  @override
  InheritedElement createElement() => _ControllerScopeElement(this);

  @override
  bool updateShouldNotify(ControllerScope oldWidget) =>
      _controller != oldWidget._controller;
}

base class _ControllerScopeElement<C extends Listenable>
    extends InheritedElement {
  _ControllerScopeElement(ControllerScope<C> super.widget);

  C get _controller => (widget as ControllerScope<C>)._controller;

  @override
  void unmount() {
    final controller = _controller;
    if (controller is ChangeNotifier) controller.dispose();

    super.unmount();
  }
}
