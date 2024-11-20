import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/exception/exception.dart';
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
    if (flashcardEditData.title?.trim().isEmpty ?? false) {
      throw const FlashcardValidationException(
        message: 'Title cannot be empty',
      );
    }

    if (flashcardEditData.term?.trim().isEmpty ?? false) {
      throw const FlashcardValidationException(
        message: 'Term cannot be empty',
      );
    }

    if (flashcardEditData.definition?.trim().isEmpty ?? false) {
      throw const FlashcardValidationException(
        message: 'Definition cannot be empty',
      );
    }

    return _flashcardRepository.update(
      flashcardIdForEditing,
      flashcardEditData,
    );
  }
}
