import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheduler_entry.freezed.dart';

@freezed
base class SchedulerEntry with _$SchedulerEntry {
  const factory SchedulerEntry({
    required int id,
    required int cardId,
    required DateTime due,
    required int scheduledDays,
    required int elapsedDays,
    required int reps,
    required int lapses,
    required DateTime? lastReview,
  }) = _SchedulerEntry;
}
