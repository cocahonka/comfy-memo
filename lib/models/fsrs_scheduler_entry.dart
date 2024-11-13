import 'package:comfy_memo/models/fsrs_review_log.dart';
import 'package:flutter/foundation.dart';

@immutable
final class FsrsSchedulerEntry implements Comparable<FsrsSchedulerEntry> {
  const FsrsSchedulerEntry({
    required this.id,
    required this.schedulerId,
    required this.stability,
    required this.difficulty,
    required this.learningState,
  });

  factory FsrsSchedulerEntry.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'id': final int id,
        'scheduler_id': final int schedulerId,
        'stability': final double stability,
        'difficulty': final double difficulty,
        'learningState': final int learningStateNumber,
      } =>
        FsrsSchedulerEntry(
          id: id,
          schedulerId: schedulerId,
          stability: stability,
          difficulty: difficulty,
          learningState: LearningState.values.singleWhere(
            (learningState) => learningState.number == learningStateNumber,
          ),
        ),
      _ => throw FormatException(
          'Invalid JSON Schema for FsrsSchedulerEntry: $json',
        )
    };
  }

  final int id;
  final int schedulerId;
  final double stability;
  final double difficulty;
  final LearningState learningState;

  Map<String, Object?> toJson() => {
        'id': id,
        'scheduler_id': schedulerId,
        'stability': stability,
        'difficulty': difficulty,
        'learningState': learningState.number,
      };

  FsrsSchedulerEntry copyWith({
    int? id,
    int? schedulerId,
    double? stability,
    double? difficulty,
    LearningState? learningState,
  }) {
    return FsrsSchedulerEntry(
      id: id ?? this.id,
      schedulerId: schedulerId ?? this.schedulerId,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      learningState: learningState ?? this.learningState,
    );
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        schedulerId,
        stability,
        difficulty,
        learningState,
      ]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FsrsSchedulerEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          schedulerId == other.schedulerId &&
          stability == other.stability &&
          difficulty == other.difficulty &&
          learningState == other.learningState;

  @override
  int compareTo(FsrsSchedulerEntry other) => id.compareTo(other.id);

  @override
  String toString() => 'FsrsSchedulerEntry(id: $id, schedulerId: $schedulerId, '
      'stability: $stability, difficulty: $difficulty, '
      'learningState: $learningState)';
}
