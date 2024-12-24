import 'package:flutter/foundation.dart';

typedef ListenableSelector<C extends Listenable, V> = V Function(
  C controller,
);

typedef ListenableFilter<V> = bool Function(V prev, V next);

extension ListenableSelectorExtension<C extends Listenable> on C {
  ValueListenable<V> select<V>(
    ListenableSelector<C, V> selector, [
    ListenableFilter<V>? test,
  ]) =>
      _ValueListenableView<C, V>(this, selector, test);
}

final class _ValueListenableView<C extends Listenable, V>
    extends ValueListenable<V> with ChangeNotifier {
  _ValueListenableView(
    C controller,
    ListenableSelector<C, V> selector,
    ListenableFilter<V>? test,
  )   : _controller = controller,
        _selector = selector,
        _test = test;

  final C _controller;
  final ListenableSelector<C, V> _selector;
  final ListenableFilter<V>? _test;

  @override
  V get value => hasListeners ? _value : _selector(_controller);

  late V _value;

  void _update() {
    final newValue = _selector(_controller);
    if (identical(_value, newValue)) return;
    if (!(_test?.call(_value, newValue) ?? true)) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) {
      _value = _selector(_controller);
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
