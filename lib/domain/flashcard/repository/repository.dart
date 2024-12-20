import 'package:comfy_memo/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';

abstract interface class IFlashcardRepository {
  Future<void> create(FlashcardCreateDto dto);
  Future<List<Flashcard>> fetch();
  Future<void> update(FlashcardEditDto dto, int cardId);
  Future<void> delete(int cardId);
}
