import 'package:flutter/foundation.dart';

abstract base class Controller<State> extends ValueNotifier<State> {
  Controller(State state) : super(state);

  @protected
  // For a functional approach
  // ignore: use_setters_to_change_properties
  void setState(State state) {
    value = state;
  }

  @protected
  Future<void> handle(Future<void> Function() action);
}
