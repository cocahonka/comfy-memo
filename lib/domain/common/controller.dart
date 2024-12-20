import 'package:flutter/foundation.dart';

abstract base class Controller<State> extends ValueNotifier<State> {
  Controller(State state) : super(state);

  @protected
  void setState(State state) {
    value = state;
    notifyListeners();
  }

  @protected
  Future<void> handle(Future<void> Function() action);
}
