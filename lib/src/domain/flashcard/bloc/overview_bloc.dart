import 'dart:async';

import 'package:comfy_memo/src/domain/common/bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_with_due_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/get_flashcards_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@immutable
sealed class FlashcardOverviewEvent {
  const FlashcardOverviewEvent();
}

final class FlashcardOverviewEvent$OnData extends FlashcardOverviewEvent {
  const FlashcardOverviewEvent$OnData({required this.flashcards});

  final List<FlashcardWithDueEntity> flashcards;
}

final class FlashcardOverviewEvent$OnError extends FlashcardOverviewEvent {
  const FlashcardOverviewEvent$OnError({
    required this.error,
    required this.flashcards,
  });

  final List<FlashcardWithDueEntity> flashcards;
  final Object error;
}

@immutable
sealed class FlashcardOverviewState {
  const FlashcardOverviewState({required this.flashcards});

  final List<FlashcardWithDueEntity> flashcards;
}

final class FlashcardOverviewState$Loading extends FlashcardOverviewState {
  const FlashcardOverviewState$Loading() : super(flashcards: const []);
}

final class FlashcardOverviewState$Idle extends FlashcardOverviewState {
  const FlashcardOverviewState$Idle({required super.flashcards});
}

final class FlashcardOverviewState$Error extends FlashcardOverviewState {
  const FlashcardOverviewState$Error({
    required super.flashcards,
    required this.message,
  });

  final String message;
}

base class FlashcardOverviewBloc
    extends Bloc<FlashcardOverviewEvent, FlashcardOverviewState> {
  FlashcardOverviewBloc({required GetFlashcardsUsecase getFlashcardsUsecase})
      : _getFlashcardsUsecase = getFlashcardsUsecase,
        super(const FlashcardOverviewState$Loading()) {
    stateContoller.onListen = () {
      stateContoller.add(initial);
      _subscribeUsecase();
    };
  }

  final GetFlashcardsUsecase _getFlashcardsUsecase;
  StreamSubscription<List<FlashcardWithDueEntity>>? _usecaseSubscription;

  @override
  Stream<FlashcardOverviewState> mapEventToState(
    FlashcardOverviewEvent event,
  ) async* {
    yield* switch (event) {
      final FlashcardOverviewEvent$OnData e => _onData(e),
      final FlashcardOverviewEvent$OnError e => _onError(e),
    };
  }

  Stream<FlashcardOverviewState> _onData(
    FlashcardOverviewEvent$OnData event,
  ) async* {
    yield FlashcardOverviewState$Idle(flashcards: event.flashcards);
  }

  Stream<FlashcardOverviewState> _onError(
    FlashcardOverviewEvent$OnError event,
  ) async* {
    yield FlashcardOverviewState$Error(
      flashcards: event.flashcards,
      message: 'Unknown error',
    );
  }

  void _subscribeUsecase() {
    _usecaseSubscription ??= _getFlashcardsUsecase().listen(
      (flashcards) {
        sink.add(FlashcardOverviewEvent$OnData(flashcards: flashcards));
      },
      onError: (Object error, StackTrace stackTrace) {
        sink.add(
          FlashcardOverviewEvent$OnError(
            error: error,
            flashcards: state.flashcards,
          ),
        );
        throw Error.throwWithStackTrace(error, stackTrace);
      },
    );
  }

  @override
  Future<void> dispose() {
    _usecaseSubscription?.cancel();
    return super.dispose();
  }
}
