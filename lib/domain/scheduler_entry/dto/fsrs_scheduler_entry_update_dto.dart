import 'package:comfy_memo/domain/algorithm/fsrs/entity/learning_state.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fsrs_scheduler_entry_update_dto.freezed.dart';

@freezed
class FsrsSchedulerEntryUpdateDto with _$FsrsSchedulerEntryUpdateDto {
  const factory FsrsSchedulerEntryUpdateDto({
    required DateTime due,
    required int scheduledDays,
    required int elapsedDays,
    required int reps,
    required int lapses,
    required DateTime? lastReview,
    required double stability,
    required double difficulty,
    required LearningState state,
  }) = _FsrsSchedulerEntryUpdateDto;
}
