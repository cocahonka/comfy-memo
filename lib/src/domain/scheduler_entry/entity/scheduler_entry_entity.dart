import 'package:meta/meta.dart';

@immutable
base class SchedulerEntryEntity {
  const SchedulerEntryEntity({
    required this.cardId,
    required this.due,
    required this.scheduledDays,
    required this.elapsedDays,
    required this.reps,
    required this.lapses,
    required this.lastReview,
  });

  final int cardId;
  final DateTime due;
  final int scheduledDays;
  final int elapsedDays;
  final int reps;
  final int lapses;
  final DateTime lastReview;

  @override
  String toString() => 'SchedulerEntryEntity('
      'cardId: $cardId, '
      'due: $due, '
      'scheduledDays: $scheduledDays, '
      'elapsedDays: $elapsedDays, '
      'reps: $reps, '
      'lapses: $lapses, '
      'lastReview: $lastReview'
      ')';
}
