import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/algorithm/exception/exception.dart';
import 'package:comfy_memo/src/domain/algorithm/fsrs/fsrs.dart' as fsrs;
import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';
import 'package:test/test.dart';

void main() {
  late FsrsAlgorithmUsecase usecase;
  late fsrs.Fsrs algorithm;

  setUp(() {
    algorithm = fsrs.Fsrs();
    usecase = FsrsAlgorithmUsecase();
  });

  test('FsrsAlgorithmUsecase correct mapping objects', () {
    final initialDue = DateTime.now().toUtc();
    var card = fsrs.Card(due: initialDue);
    var scheduler = FsrsSchedulerEntryEntity(
      cardId: 0,
      due: initialDue,
      scheduledDays: 0,
      elapsedDays: 0,
      reps: 0,
      lapses: 0,
      lastReview: null,
      schedulerId: 0,
      stability: 0,
      difficulty: 0,
      learningState: LearningState.newState,
    );
    var now = DateTime.utc(2022, 11, 29, 12, 30, 0, 0);

    final ratings = [
      (fsrs.Rating.good, LearningRating.good),
      (fsrs.Rating.easy, LearningRating.perfect),
      (fsrs.Rating.good, LearningRating.good),
      (fsrs.Rating.hard, LearningRating.hard),
      (fsrs.Rating.again, LearningRating.forgot),
      (fsrs.Rating.good, LearningRating.good),
      (fsrs.Rating.good, LearningRating.good),
    ];

    for (final (fsrsRating, domainRating) in ratings) {
      final (card: fsrsCard, reviewLog: fsrsReviewLog) = algorithm.reviewCard(
        card: card,
        rating: fsrsRating,
        repeatTime: now,
      );
      final (:reviewDto, :schedulerUpdateDto) = usecase(
        scheduler: scheduler,
        rating: domainRating,
        repeatTime: now,
      );

      card = fsrsCard;
      scheduler = FsrsSchedulerEntryEntity(
        cardId: 0,
        due: schedulerUpdateDto.due,
        scheduledDays: schedulerUpdateDto.scheduledDays,
        elapsedDays: schedulerUpdateDto.elapsedDays,
        reps: schedulerUpdateDto.reps,
        lapses: schedulerUpdateDto.lapses,
        lastReview: schedulerUpdateDto.lastReview,
        schedulerId: 0,
        stability: schedulerUpdateDto.stability,
        difficulty: schedulerUpdateDto.difficulty,
        learningState: schedulerUpdateDto.learningState,
      );
      now = card.due;

      expect(
        [
          fsrsCard.due,
          fsrsCard.scheduledDays,
          fsrsCard.elapsedDays,
          fsrsCard.reps,
          fsrsCard.lapses,
          fsrsCard.lastReview,
          fsrsCard.stability,
          fsrsCard.difficulty,
          fsrsCard.state.number,
        ],
        equals([
          schedulerUpdateDto.due,
          schedulerUpdateDto.scheduledDays,
          schedulerUpdateDto.elapsedDays,
          schedulerUpdateDto.reps,
          schedulerUpdateDto.lapses,
          schedulerUpdateDto.lastReview,
          schedulerUpdateDto.stability,
          schedulerUpdateDto.difficulty,
          schedulerUpdateDto.learningState.number,
        ]),
      );
      expect(
        [
          fsrsReviewLog.review,
          fsrsReviewLog.rating.number,
          fsrsReviewLog.state.number,
        ],
        equals([
          reviewDto.review,
          reviewDto.rating.score,
          reviewDto.learningState.number,
        ]),
      );
    }
  });

  test(
    'FsrsAlgorithmUsecase thrown exception when repeat time not in UTC',
    () {
      final fakeScheduler = FsrsSchedulerEntryEntity(
        cardId: 0,
        due: DateTime.now(),
        scheduledDays: 0,
        elapsedDays: 0,
        reps: 0,
        lapses: 0,
        lastReview: null,
        schedulerId: 0,
        stability: 0,
        difficulty: 0,
        learningState: LearningState.newState,
      );

      expect(
        () => usecase(
          repeatTime: DateTime.now().toLocal(),
          rating: LearningRating.forgot,
          scheduler: fakeScheduler,
        ),
        throwsA(isA<FsrsRepeatTimeNotInUtcException>()),
      );
    },
  );
}
