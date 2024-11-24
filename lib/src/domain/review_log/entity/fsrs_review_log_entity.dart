import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:comfy_memo/src/domain/review_log/entity/review_log_entity.dart';

final class FsrsReviewLogEntity extends ReviewLogEntity {
  const FsrsReviewLogEntity({
    required super.cardId,
    required super.review,
    required super.rating,
    required this.reviewLogId,
    required this.learningState,
  });

  final int reviewLogId;
  final LearningState learningState;

  @override
  int get hashCode =>
      Object.hashAll([cardId, review, rating, reviewLogId, learningState]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsReviewLogEntity &&
          cardId == other.cardId &&
          review == other.review &&
          rating == other.rating &&
          reviewLogId == other.reviewLogId &&
          learningState == other.learningState;

  @override
  String toString() => 'FsrsReviewLogEntity('
      'cardId: $cardId, '
      'review: $review, '
      'rating: $rating, '
      'reviewLogId: $reviewLogId, '
      'learningState: $learningState'
      ')';
}
