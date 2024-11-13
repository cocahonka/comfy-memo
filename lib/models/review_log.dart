import 'package:flutter/foundation.dart';

enum Rating implements Comparable<Rating> {
  forgot(1),
  hard(2),
  good(3),
  perfect(4);

  const Rating(this.score);

  final int score;

  @override
  int compareTo(Rating other) => score.compareTo(other.score);
}

@immutable
final class ReviewLog implements Comparable<ReviewLog> {
  const ReviewLog({
    required this.id,
    required this.cardId,
    required this.review,
    required this.rating,
  });

  factory ReviewLog.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'id': final int id,
        'cardId': final int cardId,
        'review': final String reviewIsoString,
        'rating': final int ratingScore,
      } =>
        ReviewLog(
          id: id,
          cardId: cardId,
          review: DateTime.parse(reviewIsoString),
          rating: Rating.values
              .singleWhere((rating) => rating.score == ratingScore),
        ),
      _ => throw FormatException('Invalid JSON Schema for ReviewLog: $json')
    };
  }

  final int id;
  final int cardId;
  final DateTime review;
  final Rating rating;

  Map<String, Object?> toJson() => {
        'id': id,
        'cardId': cardId,
        'review': review.toIso8601String(),
        'rating': rating.score,
      };

  ReviewLog copyWith({
    int? id,
    int? cardId,
    DateTime? review,
    Rating? rating,
  }) =>
      ReviewLog(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        review: review ?? this.review,
        rating: rating ?? this.rating,
      );

  @override
  int get hashCode => Object.hashAll([id, cardId, review, rating]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ReviewLog &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            cardId == other.cardId &&
            review == other.review &&
            rating == other.rating;
  }

  @override
  int compareTo(ReviewLog other) => id.compareTo(other.id);

  @override
  String toString() =>
      'ReviewLog(id: $id, cardId: $cardId, review: $review, rating: $rating)';
}
