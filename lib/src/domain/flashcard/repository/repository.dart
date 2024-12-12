import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';

abstract interface class IFlashcardRepository {
  Future<FlashcardEntity> create(FlashcardCreateDto params);

  Future<List<FlashcardEntity>> fetchAll();
  Future<FlashcardEntity> fetch(int id);
  Stream<List<FlashcardEntity>> get flashcards;
  Future<void> updateStream();

  Future<void> update(int id, FlashcardEditDto params);

  Future<void> delete(int id);
}
