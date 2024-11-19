import 'package:meta/meta.dart';

enum SelfVerifyType { none, written }

@immutable
class FlashcardEntity {
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
  String toString() => 'FlashcardEntity(id: $id, title: $title, term: $term, '
      'definition: $definition, selfVerifyType: $selfVerifyType)';
}
