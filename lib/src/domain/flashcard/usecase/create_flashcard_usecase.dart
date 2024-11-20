import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/exception/exception.dart';
import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:meta/meta.dart';

@immutable
final class CreateFlashcardUsecase {
  const CreateFlashcardUsecase({
    required IFlashcardRepository flashcardRepository,
    required ISchedulerEntryRepository schedulerEntryRepository,
  })  : _flashcardRepository = flashcardRepository,
        _schedulerEntryRepository = schedulerEntryRepository;

  final IFlashcardRepository _flashcardRepository;
  final ISchedulerEntryRepository _schedulerEntryRepository;

  Future<void> call({
    required FlashcardCreateDto flashcardCreateData,
  }) async {
    if (flashcardCreateData.title.trim().isEmpty) {
      throw const FlashcardValidationException(
        message: 'Title cannot be empty',
      );
    }

    if (flashcardCreateData.term.trim().isEmpty) {
      throw const FlashcardValidationException(
        message: 'Term cannot be empty',
      );
    }

    if (flashcardCreateData.definition.trim().isEmpty) {
      throw const FlashcardValidationException(
        message: 'Definition cannot be empty',
      );
    }

    final flashcard = await _flashcardRepository.create(flashcardCreateData);
    await _schedulerEntryRepository.create(flashcard.id);
  }
}
