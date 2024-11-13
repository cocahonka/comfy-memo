import 'package:flutter/foundation.dart';

@immutable
final class SchedulerEntry implements Comparable<SchedulerEntry> {
  const SchedulerEntry({
    required this.id,
    required this.cardId,
    required this.due,
    required this.scheduledDays,
    required this.elapsedDays,
    required this.reps,
    required this.lapses,
    required this.lastReview,
  });

  factory SchedulerEntry.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'id': final int id,
        'card_id': final int cardId,
        'due': final String dueIsoString,
        'scheduled_days': final int scheduledDays,
        'elapsed_days': final int elapsedDays,
        'reps': final int reps,
        'lapses': final int lapses,
        'last_review': final String lastReviewIsoString,
      } =>
        SchedulerEntry(
          id: id,
          cardId: cardId,
          due: DateTime.parse(dueIsoString),
          scheduledDays: scheduledDays,
          elapsedDays: elapsedDays,
          reps: reps,
          lapses: lapses,
          lastReview: DateTime.parse(lastReviewIsoString),
        ),
      _ =>
        throw FormatException('Invalid JSON Schema for SchedulerEntry: $json')
    };
  }

  final int id;
  final int cardId;
  final DateTime due;
  final int scheduledDays;
  final int elapsedDays;
  final int reps;
  final int lapses;
  final DateTime lastReview;

  Map<String, Object?> toJson() => {
        'id': id,
        'card_id': cardId,
        'due': due.toIso8601String(),
        'scheduled_days': scheduledDays,
        'elapsed_days': elapsedDays,
        'reps': reps,
        'lapses': lapses,
        'last_review': lastReview.toIso8601String(),
      };

  SchedulerEntry copyWith({
    int? id,
    int? cardId,
    DateTime? due,
    int? scheduledDays,
    int? elapsedDays,
    int? reps,
    int? lapses,
    DateTime? lastReview,
  }) =>
      SchedulerEntry(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        due: due ?? this.due,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        elapsedDays: elapsedDays ?? this.elapsedDays,
        reps: reps ?? this.reps,
        lapses: lapses ?? this.lapses,
        lastReview: lastReview ?? this.lastReview,
      );

  @override
  int get hashCode => Object.hashAll([
        id,
        cardId,
        due,
        scheduledDays,
        elapsedDays,
        reps,
        lapses,
        lastReview,
      ]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchedulerEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cardId == other.cardId &&
          due == other.due &&
          scheduledDays == other.scheduledDays &&
          elapsedDays == other.elapsedDays &&
          reps == other.reps &&
          lapses == other.lapses &&
          lastReview == other.lastReview;

  @override
  int compareTo(SchedulerEntry other) => id.compareTo(other.id);

  @override
  String toString() => 'SchedulerEntry(id: $id, cardId: $cardId, due: $due, '
      'scheduledDays: $scheduledDays, elapsedDays: $elapsedDays, '
      'reps: $reps, lapses: $lapses, lastReview: $lastReview)';
}
