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
    stateContoller.onListen = () async {
      stateContoller.add(initial);
      await _subscribeUsecase();
    };
  }

  final GetFlashcardsUsecase _getFlashcardsUsecase;
  StreamSubscription<List<FlashcardWithDueEntity>>? _usecaseSubscription;
  Timer? _dueTimer;

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
    _scheduleNextDue(event.flashcards);
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

  Future<void> _subscribeUsecase() async {
    await _usecaseSubscription?.cancel();
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

  void _scheduleNextDue(List<FlashcardWithDueEntity> flashcards) {
    _dueTimer?.cancel();

    final now = DateTime.now().toUtc();
    final upcomingDueDates = flashcards
        .map((card) => card.due)
        .where((due) => due.isAfter(now))
        .toList();

    if (upcomingDueDates.isEmpty) {
      return;
    }

    upcomingDueDates.sort();
    final nearestDue = upcomingDueDates.first;
    final duration = nearestDue.difference(now);

    if (duration.isNegative || duration == Duration.zero) {
      _onDueReached();
      return;
    }

    _dueTimer = Timer(duration, _onDueReached);
  }

  void _onDueReached() {
    sink.add(FlashcardOverviewEvent$OnData(flashcards: state.flashcards));
  }

  @override
  Future<void> dispose() {
    _usecaseSubscription?.cancel();
    _dueTimer?.cancel();
    return super.dispose();
  }
}
