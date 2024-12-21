import 'package:meta/meta.dart';

@immutable
sealed class ReviewLogDomainException implements Exception {
  const ReviewLogDomainException({
    required this.message,
    required this.cause,
  });

  final String message;
  final Object? cause;
}
