import 'package:meta/meta.dart';

enum SelfVerifyType { none, written }

@immutable
base class FlashcardEntity {
  const FlashcardEntity({
    required this.id,
    required this.title,
    required this.term,
    required this.definition,
    required this.selfVerifyType,
  });

  final int id;
  final String title;
  final String term;
  final String definition;
  final SelfVerifyType selfVerifyType;

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        term,
        definition,
        selfVerifyType,
      ]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardEntity &&
          id == other.id &&
          title == other.title &&
          term == other.term &&
          definition == other.definition &&
          selfVerifyType == other.selfVerifyType;

  @override
  String toString() => 'FlashcardEntity('
      'id: $id, '
      'title: $title, '
      'term: $term, '
      'definition: $definition, '
      'selfVerifyType: $selfVerifyType'
      ')';
}
