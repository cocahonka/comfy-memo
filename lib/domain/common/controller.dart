import 'package:flutter/foundation.dart';

abstract base class Controller<State> extends ValueListenable<State>
    with ChangeNotifier {
  Controller(State state) : _state = state;

  State _state;
  State get state => _state;

  @override
  State get value => _state;

  @protected
  void setState(State state) {
    _state = state;
    notifyListeners();
  }

  @protected
  Future<void> handle(Future<void> Function() action);
}
