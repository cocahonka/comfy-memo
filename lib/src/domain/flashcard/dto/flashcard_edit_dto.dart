import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:meta/meta.dart';

@immutable
final class FlashcardEditDto {
  const FlashcardEditDto({
    required this.title,
    required this.term,
    required this.definition,
    required this.selfVerifyType,
  });

  final String? title;
  final String? term;
  final String? definition;
  final SelfVerifyType? selfVerifyType;

  @override
  int get hashCode => Object.hashAll([title, term, definition, selfVerifyType]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardEditDto &&
          title == other.title &&
          term == other.term &&
          definition == other.definition &&
          selfVerifyType == other.selfVerifyType;

  @override
  String toString() => 'FlashcardEditDto('
      'title: $title, '
      'term: $term, '
      'definition: $definition, '
      'selfVerifyType: $selfVerifyType'
      ')';
}
