import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:meta/meta.dart';

@immutable
final class FsrsSchedulerUpdateDto {
  const FsrsSchedulerUpdateDto({
    required this.due,
    required this.scheduledDays,
    required this.elapsedDays,
    required this.reps,
    required this.lapses,
    required this.lastReview,
    required this.stability,
    required this.difficulty,
    required this.learningState,
  });

  final DateTime due;
  final int scheduledDays;
  final int elapsedDays;
  final int reps;
  final int lapses;
  final DateTime? lastReview;
  final double stability;
  final double difficulty;
  final LearningState learningState;
}
