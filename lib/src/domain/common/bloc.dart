import 'dart:async';

import 'package:meta/meta.dart';

abstract base class Bloc<Event, State> {
  Bloc(this.initial)
      : stateContoller = StreamController.broadcast(),
        eventContoller = StreamController.broadcast() {
    stateContoller.onListen = () {
      stateContoller.add(initial);
    };
    eventContoller.stream.asyncExpand(mapEventToState).listen((state) {
      stateContoller.add(state);
      _state = state;
    });
  }

  final State initial;
  late State _state = initial;
  State get state => _state;

  @protected
  final StreamController<Event> eventContoller;
  @protected
  final StreamController<State> stateContoller;

  StreamSink<Event> get sink => eventContoller.sink;
  Stream<State> get stream => stateContoller.stream;

  @protected
  Stream<State> mapEventToState(Event event);

  @mustCallSuper
  Future<void> dispose() async {
    await eventContoller.close();
    await stateContoller.close();
  }
}
