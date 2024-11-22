import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/algorithm/fsrs/fsrs.dart' as fsrs;
import 'package:comfy_memo/src/domain/review_log/dto/fsrs_review_dto.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/dto/fsrs_scheduler_update_dto.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';
import 'package:meta/meta.dart';

enum LearningState {
  newState(0),
  learning(1),
  review(2),
  relearning(3);

  const LearningState(this.number);

  final int number;
}

@immutable
final class FsrsAlgorithmUsecase {
  FsrsAlgorithmUsecase({fsrs.Fsrs? algorithm})
      : _algorithm = algorithm ?? fsrs.Fsrs();

  final fsrs.Fsrs _algorithm;

  ({FsrsSchedulerUpdateDto schedulerUpdateDto, FsrsReviewDto reviewDto}) call({
    required FsrsSchedulerEntryEntity scheduler,
    required LearningRating rating,
    DateTime? repeatTime,
  }) {
    final inputCard = _toCard(scheduler);
    final inputRating = _toRating(rating);

    final (:card, :reviewLog) = _algorithm.reviewCard(
      card: inputCard,
      rating: inputRating,
      repeatTime: repeatTime,
    );

    final schedulerUpdateDto = _toSchedulerUpdateDto(card);
    final reviewDto = _toFsrsReviewDto(reviewLog);

    return (schedulerUpdateDto: schedulerUpdateDto, reviewDto: reviewDto);
  }

  fsrs.State _toState(LearningState state) => switch (state) {
        LearningState.newState => fsrs.State.newState,
        LearningState.learning => fsrs.State.learning,
        LearningState.review => fsrs.State.review,
        LearningState.relearning => fsrs.State.relearning,
      };

  LearningState _toLearningState(fsrs.State state) => switch (state) {
        fsrs.State.newState => LearningState.newState,
        fsrs.State.learning => LearningState.learning,
        fsrs.State.review => LearningState.review,
        fsrs.State.relearning => LearningState.relearning,
      };

  fsrs.Rating _toRating(LearningRating rating) => switch (rating) {
        LearningRating.forgot => fsrs.Rating.again,
        LearningRating.hard => fsrs.Rating.hard,
        LearningRating.good => fsrs.Rating.good,
        LearningRating.perfect => fsrs.Rating.easy,
      };

  LearningRating _toLearningRating(fsrs.Rating rating) => switch (rating) {
        fsrs.Rating.again => LearningRating.forgot,
        fsrs.Rating.hard => LearningRating.hard,
        fsrs.Rating.good => LearningRating.good,
        fsrs.Rating.easy => LearningRating.perfect,
      };

  fsrs.Card _toCard(FsrsSchedulerEntryEntity scheduler) => fsrs.Card(
        due: scheduler.due,
        stability: scheduler.stability,
        difficulty: scheduler.difficulty,
        elapsedDays: scheduler.elapsedDays,
        scheduledDays: scheduler.scheduledDays,
        reps: scheduler.reps,
        lapses: scheduler.lapses,
        state: _toState(scheduler.learningState),
        lastReview: scheduler.lastReview,
      );

  FsrsSchedulerUpdateDto _toSchedulerUpdateDto(fsrs.Card card) =>
      FsrsSchedulerUpdateDto(
        due: card.due,
        scheduledDays: card.scheduledDays,
        elapsedDays: card.elapsedDays,
        reps: card.reps,
        lapses: card.lapses,
        lastReview: card.lastReview,
        stability: card.stability,
        difficulty: card.difficulty,
        learningState: _toLearningState(card.state),
      );

  FsrsReviewDto _toFsrsReviewDto(fsrs.ReviewLog reviewLog) => FsrsReviewDto(
        review: reviewLog.review,
        rating: _toLearningRating(reviewLog.rating),
        learningState: _toLearningState(reviewLog.state),
      );
}
