import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:comfy_memo/domain/algorithm/exception/exception.dart';
import 'package:comfy_memo/domain/algorithm/fsrs/entity/learning_state.dart';
import 'package:comfy_memo/domain/algorithm/fsrs/src/fsrs_base.dart';
import 'package:comfy_memo/domain/algorithm/fsrs/src/models.dart';
import 'package:comfy_memo/domain/review_log/dto/fsrs_review_dto.dart';
import 'package:comfy_memo/domain/scheduler_entry/dto/fsrs_scheduler_entry_update_dto.dart';
import 'package:comfy_memo/domain/scheduler_entry/entity/fsrs_scheduler_entry.dart';
import 'package:meta/meta.dart';

@immutable
final class FsrsAlgorithm {
  const FsrsAlgorithm({required Fsrs fsrs}) : _fsrs = fsrs;

  final Fsrs _fsrs;

  ({FsrsSchedulerEntryUpdateDto schedulerUpdateDto, FsrsReviewDto reviewDto})
      process({
    required FsrsSchedulerEntry scheduler,
    required RepeatRating rating,
    DateTime? repeatTime,
  }) {
    final now = repeatTime ?? DateTime.now().toUtc();
    if (!now.isUtc) {
      throw FsrsRepeatTimeNotInUtcException(message: '$now is not in UTC');
    }

    final inputCard = _toCard(scheduler);
    final inputRating = _toRating(rating);

    final (:card, :reviewLog) = _fsrs.reviewCard(
      card: inputCard,
      rating: inputRating,
      repeatTime: now,
    );

    final schedulerUpdateDto = _toSchedulerUpdateDto(card);
    final reviewDto = _toFsrsReviewDto(reviewLog);

    return (schedulerUpdateDto: schedulerUpdateDto, reviewDto: reviewDto);
  }

  State _toState(LearningState state) => switch (state) {
        LearningState.newState => State.newState,
        LearningState.learning => State.learning,
        LearningState.review => State.review,
        LearningState.relearning => State.relearning,
      };

  LearningState _toLearningState(State state) => switch (state) {
        State.newState => LearningState.newState,
        State.learning => LearningState.learning,
        State.review => LearningState.review,
        State.relearning => LearningState.relearning,
      };

  Rating _toRating(RepeatRating rating) => switch (rating) {
        RepeatRating.forgot => Rating.again,
        RepeatRating.hard => Rating.hard,
        RepeatRating.good => Rating.good,
        RepeatRating.perfect => Rating.easy,
      };

  RepeatRating _toRepeatRating(Rating rating) => switch (rating) {
        Rating.again => RepeatRating.forgot,
        Rating.hard => RepeatRating.hard,
        Rating.good => RepeatRating.good,
        Rating.easy => RepeatRating.perfect,
      };

  Card _toCard(FsrsSchedulerEntry scheduler) => Card(
        due: scheduler.due,
        stability: scheduler.stability,
        difficulty: scheduler.difficulty,
        elapsedDays: scheduler.elapsedDays,
        scheduledDays: scheduler.scheduledDays,
        reps: scheduler.reps,
        lapses: scheduler.lapses,
        state: _toState(scheduler.state),
        lastReview: scheduler.lastReview,
      );

  FsrsSchedulerEntryUpdateDto _toSchedulerUpdateDto(Card card) =>
      FsrsSchedulerEntryUpdateDto(
        due: card.due,
        scheduledDays: card.scheduledDays,
        elapsedDays: card.elapsedDays,
        reps: card.reps,
        lapses: card.lapses,
        lastReview: card.lastReview,
        stability: card.stability,
        difficulty: card.difficulty,
        state: _toLearningState(card.state),
      );

  FsrsReviewDto _toFsrsReviewDto(ReviewLog reviewLog) => FsrsReviewDto(
        review: reviewLog.review,
        rating: _toRepeatRating(reviewLog.rating),
        state: _toLearningState(reviewLog.state),
      );
}
