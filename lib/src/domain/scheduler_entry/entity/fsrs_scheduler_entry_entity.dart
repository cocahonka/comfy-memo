import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/scheduler_entry_entity.dart';

final class FsrsSchedulerEntryEntity extends SchedulerEntryEntity {
  const FsrsSchedulerEntryEntity({
    required super.cardId,
    required super.due,
    required super.scheduledDays,
    required super.elapsedDays,
    required super.reps,
    required super.lapses,
    required super.lastReview,
    required this.schedulerId,
    required this.stability,
    required this.difficulty,
    required this.learningState,
  });

  final int schedulerId;
  final double stability;
  final double difficulty;
  final LearningState learningState;

  @override
  int get hashCode => Object.hashAll([
        cardId,
        due,
        scheduledDays,
        elapsedDays,
        reps,
        lapses,
        lastReview,
        schedulerId,
        stability,
        difficulty,
        learningState,
      ]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsSchedulerEntryEntity &&
          cardId == other.cardId &&
          due == other.due &&
          scheduledDays == other.scheduledDays &&
          elapsedDays == other.elapsedDays &&
          reps == other.reps &&
          lapses == other.lapses &&
          lastReview == other.lastReview &&
          schedulerId == other.schedulerId &&
          stability == other.stability &&
          difficulty == other.difficulty &&
          learningState == other.learningState;

  @override
  String toString() => 'FsrsSchedulerEntryEntity('
      'cardId: $cardId, '
      'due: $due, '
      'scheduledDays: $scheduledDays, '
      'elapsedDays: $elapsedDays, '
      'reps: $reps, '
      'lapses: $lapses, '
      'lastReview: $lastReview, '
      'schedulerId: $schedulerId, '
      'stability: $stability, '
      'difficulty: $difficulty, '
      'learningState: $learningState'
      ')';
}
