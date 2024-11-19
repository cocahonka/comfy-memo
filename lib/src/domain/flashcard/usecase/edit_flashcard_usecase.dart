import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:meta/meta.dart';

@immutable
final class EditFlashcardUsecase {
  const EditFlashcardUsecase({
    required IFlashcardRepository flashcardRepository,
  }) : _flashcardRepository = flashcardRepository;

  final IFlashcardRepository _flashcardRepository;

  Future<void> call({
    required int flashcardIdForEditing,
    required FlashcardEditDto flashcardEditData,
  }) async {
    return _flashcardRepository.update(
      flashcardIdForEditing,
      flashcardEditData,
    );
  }
}
