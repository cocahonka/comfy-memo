import 'package:flutter/foundation.dart';

enum LearningState implements Comparable<LearningState> {
  newState(0),
  learning(1),
  review(2),
  relearning(3);

  const LearningState(this.number);

  final int number;

  @override
  int compareTo(LearningState other) => number.compareTo(other.number);
}

@immutable
final class FsrsReviewLog implements Comparable<FsrsReviewLog> {
  const FsrsReviewLog({
    required this.id,
    required this.reviewLogId,
    required this.learningState,
  });

  factory FsrsReviewLog.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'id': final int id,
        'reviewLogId': final int reviewLogId,
        'learningState': final int learningStateNumber,
      } =>
        FsrsReviewLog(
          id: id,
          reviewLogId: reviewLogId,
          learningState: LearningState.values.singleWhere(
              (learningState) => learningState.number == learningStateNumber),
        ),
      _ => throw FormatException('Invalid JSON Schema for FsrsReviewLog: $json')
    };
  }

  final int id;
  final int reviewLogId;
  final LearningState learningState;

  Map<String, Object?> toJson() => {
        'id': id,
        'reviewLogId': reviewLogId,
        'learningState': learningState.number,
      };

  FsrsReviewLog copyWith({
    int? id,
    int? reviewLogId,
    LearningState? learningState,
  }) {
    return FsrsReviewLog(
      id: id ?? this.id,
      reviewLogId: reviewLogId ?? this.reviewLogId,
      learningState: learningState ?? this.learningState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsReviewLog &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          reviewLogId == other.reviewLogId &&
          learningState == other.learningState;

  @override
  int get hashCode => Object.hashAll([id, reviewLogId, learningState]);

  @override
  int compareTo(FsrsReviewLog other) => id.compareTo(other.id);

  @override
  String toString() => 'FsrsReviewLog{id: $id, reviewLogId: $reviewLogId, '
      'learningState: $learningState}';
}
