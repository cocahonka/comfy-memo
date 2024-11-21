import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';

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
  int get hashCode => Object.hashAll([
        id,
        title,
        term,
        definition,
        selfVerifyType,
        due,
      ]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardWithDueEntity &&
          id == other.id &&
          title == other.title &&
          term == other.term &&
          definition == other.definition &&
          selfVerifyType == other.selfVerifyType &&
          due == other.due;

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
