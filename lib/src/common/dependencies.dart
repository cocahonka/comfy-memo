import 'package:comfy_memo/src/domain/flashcard/usecase/create_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/delete_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/edit_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/get_flashcards_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/rate_flashcard_usecase.dart';
import 'package:meta/meta.dart';

@immutable
final class Dependencies {
  const Dependencies({
    required this.createFlashcardUsecase,
    required this.deleteFlashcardUsecase,
    required this.editFlashcardUsecase,
    required this.getFlashcardsUsecase,
    required this.rateFlashcardUsecase,
  });

  final CreateFlashcardUsecase createFlashcardUsecase;
  final DeleteFlashcardUsecase deleteFlashcardUsecase;
  final EditFlashcardUsecase editFlashcardUsecase;
  final GetFlashcardsUsecase getFlashcardsUsecase;
  final RateFlashcardUsecase rateFlashcardUsecase;
}
