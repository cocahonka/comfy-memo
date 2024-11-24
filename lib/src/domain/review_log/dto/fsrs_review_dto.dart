import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:meta/meta.dart';

@immutable
final class FsrsReviewDto {
  const FsrsReviewDto({
    required this.review,
    required this.rating,
    required this.learningState,
  });

  final DateTime review;
  final LearningRating rating;
  final LearningState learningState;

  @override
  int get hashCode => Object.hashAll([review, rating, learningState]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsReviewDto &&
          review == other.review &&
          rating == other.rating &&
          learningState == other.learningState;

  @override
  String toString() => 'FsrsReviewDto('
      'review: $review, '
      'rating: $rating, '
      'learningState: $learningState'
      ')';
}
