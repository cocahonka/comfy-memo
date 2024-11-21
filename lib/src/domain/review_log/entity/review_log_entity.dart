import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:meta/meta.dart';

@immutable
base class ReviewLogEntity {
  const ReviewLogEntity({
    required this.cardId,
    required this.review,
    required this.rating,
  });

  final int cardId;
  final DateTime review;
  final LearningRating rating;

  @override
  int get hashCode => Object.hashAll([
        cardId,
        review,
        rating,
      ]);

  @override
  String toString() => 'ReviewLogEntity('
      'cardId: $cardId, '
      'review: $review, '
      'rating: $rating'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewLogEntity &&
          cardId == other.cardId &&
          review == other.review &&
          rating == other.rating;
}
