import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/common/bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/rate_flashcard_usecase.dart';
import 'package:meta/meta.dart';

@immutable
sealed class FlashcardRepeatEvent {
  const FlashcardRepeatEvent();
}

final class FlashcardRepeatEvent$Rate extends FlashcardRepeatEvent {
  const FlashcardRepeatEvent$Rate({required this.rating, required this.cardId});

  final LearningRating rating;
  final int cardId;
}

@immutable
sealed class FlashcardRepeatState {
  const FlashcardRepeatState();
}

final class FlashcardRepeatState$Idle extends FlashcardRepeatState {
  const FlashcardRepeatState$Idle();
}

final class FlashcardRepeatState$Loading extends FlashcardRepeatState {
  const FlashcardRepeatState$Loading();
}

final class FlashcardRepeatState$Success extends FlashcardRepeatState {
  const FlashcardRepeatState$Success(this.nextDue);

  final DateTime nextDue;
}

final class FlashcardRepeatState$Error extends FlashcardRepeatState {
  const FlashcardRepeatState$Error(this.message);

  final String message;
}

base class FlashcardRepeatBloc
    extends Bloc<FlashcardRepeatEvent, FlashcardRepeatState> {
  FlashcardRepeatBloc({required RateFlashcardUsecase rateFlashcardUsecase})
      : _rateFlashcardUsecase = rateFlashcardUsecase,
        super(const FlashcardRepeatState$Idle());

  final RateFlashcardUsecase _rateFlashcardUsecase;

  @override
  Stream<FlashcardRepeatState> mapEventToState(
    FlashcardRepeatEvent event,
  ) async* {
    yield* switch (event) {
      final FlashcardRepeatEvent$Rate e => _rate(e),
    };
  }

  Stream<FlashcardRepeatState> _rate(FlashcardRepeatEvent$Rate event) async* {
    yield const FlashcardRepeatState$Loading();
    final DateTime nextDue;
    try {
      nextDue = await _rateFlashcardUsecase(
        cardId: event.cardId,
        rating: event.rating,
      );
    } on Object {
      yield const FlashcardRepeatState$Error('Unknown error');
      rethrow;
    }
    yield FlashcardRepeatState$Success(nextDue);
  }
}
