import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:comfy_memo/domain/algorithm/fsrs/entity/learning_state.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fsrs_review_dto.freezed.dart';

@freezed
class FsrsReviewDto with _$FsrsReviewDto {
  const factory FsrsReviewDto({
    required DateTime review,
    required RepeatRating rating,
    required LearningState state,
  }) = _FsrsReviewDto;
}
