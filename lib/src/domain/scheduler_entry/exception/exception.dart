import 'package:meta/meta.dart';

@immutable
sealed class SchedulerEntryDomainException implements Exception {
  const SchedulerEntryDomainException({
    required this.message,
    required this.cause,
  });

  final String message;
  final Object? cause;
}
