import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/domain/review_log/repository/repository.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:meta/meta.dart';

@immutable
final class DeleteFlashcardUsecase {
  const DeleteFlashcardUsecase({
    required IFlashcardRepository flashcardRepository,
    required ISchedulerEntryRepository schedulerEntryRepository,
    required IReviewLogRepository reviewLogRepository,
  })  : _flashcardRepository = flashcardRepository,
        _schedulerEntryRepository = schedulerEntryRepository,
        _reviewLogRepository = reviewLogRepository;

  final IFlashcardRepository _flashcardRepository;
  final ISchedulerEntryRepository _schedulerEntryRepository;
  final IReviewLogRepository _reviewLogRepository;

  Future<void> call({required int cardId}) async {
    await Future.wait([
      _flashcardRepository.delete(cardId),
      _schedulerEntryRepository.delete(cardId),
      _reviewLogRepository.delete(cardId),
    ]);
  }
}
