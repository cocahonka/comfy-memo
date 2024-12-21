import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_with_due_entity.dart';

extension FlashcardEntityExtension on FlashcardEntity {
  FlashcardWithDueEntity withDue(DateTime due) => FlashcardWithDueEntity(
        id: id,
        title: title,
        term: term,
        definition: definition,
        selfVerifyType: selfVerifyType,
        due: due,
      );
}

extension FlashcardWithDueEntityExtension on FlashcardWithDueEntity {
  FlashcardEntity toEntity() => FlashcardEntity(
        id: id,
        title: title,
        term: term,
        definition: definition,
        selfVerifyType: selfVerifyType,
      );
}
