import 'package:comfy_memo/domain/algorithm/fsrs/fsrs.dart';
import 'package:comfy_memo/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/domain/preferences/repository/repository.dart';
import 'package:comfy_memo/domain/review_log/repository/repository.dart';
import 'package:comfy_memo/domain/scheduler_entry/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dependencies.freezed.dart';

@freezed
class Dependencies with _$Dependencies {
  const factory Dependencies({
    required IFlashcardRepository flashcardRepository,
    required ISchedulerEntryRepository schedulerEntryRepository,
    required IReviewLogRepository reviewLogRepository,
    required IPreferencesRepository preferencesRepository,
    required FsrsAlgorithm fsrsAlgorithm,
  }) = _Dependencies;
}
