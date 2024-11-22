import 'package:meta/meta.dart';

@immutable
sealed class AlgorithmDomainException implements Exception {
  const AlgorithmDomainException({
    required this.message,
    required this.cause,
  });

  final String message;
  final Object? cause;
}

final class FsrsRepeatTimeNotInUtcException extends AlgorithmDomainException {
  const FsrsRepeatTimeNotInUtcException({
    required super.message,
    super.cause,
  });
}
