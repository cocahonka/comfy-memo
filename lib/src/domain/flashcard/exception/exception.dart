import 'package:meta/meta.dart';

@immutable
sealed class FlashcardDomainException implements Exception {
  const FlashcardDomainException({
    required this.message,
    required this.cause,
  });

  final String message;
  final Object? cause;
}
