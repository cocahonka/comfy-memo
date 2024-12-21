import 'package:comfy_memo/domain/algorithm/fsrs/entity/learning_state.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fsrs_scheduler_entry.freezed.dart';

@freezed
class FsrsSchedulerEntry with _$FsrsSchedulerEntry {
  const factory FsrsSchedulerEntry({
    required int id,
    required int schedulerId,
    required int cardId,
    required DateTime due,
    required int scheduledDays,
    required int elapsedDays,
    required int reps,
    required int lapses,
    required DateTime? lastReview,
    required double stability,
    required double difficulty,
    required LearningState state,
  }) = _FsrsSchedulerEntry;
}
