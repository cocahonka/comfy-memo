import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_log.freezed.dart';

@freezed
class ReviewLog with _$ReviewLog {
  const factory ReviewLog({
    required int id,
    required int cardId,
    required DateTime review,
    required RepeatRating rating,
  }) = _ReviewLog;
}
