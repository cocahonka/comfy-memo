import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:comfy_memo/domain/algorithm/fsrs/entity/learning_state.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fsrs_review_log.freezed.dart';

@freezed
base class FsrsReviewLog with _$FsrsReviewLog {
  const factory FsrsReviewLog({
    required int id,
    required int reviewLogId,
    required int cardId,
    required DateTime review,
    required RepeatRating rating,
    required LearningState state,
  }) = _FsrsReviewLog;
}
