import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:meta/meta.dart';

@immutable
final class FlashcardWithDueEntity extends FlashcardEntity {
  const FlashcardWithDueEntity({
    required super.id,
    required super.title,
    required super.term,
    required super.definition,
    required super.selfVerifyType,
    required this.due,
  });

  final DateTime due;

  bool get isRepetitionTime => due.isBefore(DateTime.now());

  @override
  String toString() => 'FlashcardWithDueEntity('
      'id: $id, '
      'title: $title, '
      'term: $term, '
      'definition: $definition, '
      'selfVerifyType: $selfVerifyType, '
      'due: $due'
      ')';
}
