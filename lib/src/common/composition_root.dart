import 'package:comfy_memo/src/common/dependencies.dart';
import 'package:comfy_memo/src/data/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/data/flashcard/source/data_source.dart';
import 'package:comfy_memo/src/data/preferences/repository/repository.dart';
import 'package:comfy_memo/src/data/review_log/repository/repository.dart';
import 'package:comfy_memo/src/data/review_log/source/data_source.dart';
import 'package:comfy_memo/src/data/scheduler_entry/repository/repository.dart';
import 'package:comfy_memo/src/data/scheduler_entry/source/data_source.dart';
import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/create_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/delete_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/edit_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/get_flashcards_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/rate_flashcard_usecase.dart';
import 'package:meta/meta.dart';

@immutable
final class CompositionRoot {
  Future<Dependencies> compose() async {
    final flashcardRepository =
        FlashcardRepository(source: FlashcardInMemoryDataSource());
    final schedulerEntryRepository =
        SchedulerEntryRepository(source: SchedulerEntryInMemoryDataSource());
    final reviewLogRepository =
        ReviewLogRepository(source: ReviewLogInMemoryDataSource());
    final preferencesRepository = PreferencesRepository();

    final createFlashcardUsecase = CreateFlashcardUsecase(
      flashcardRepository: flashcardRepository,
      schedulerEntryRepository: schedulerEntryRepository,
    );
    final deleteFlashcardUsecase = DeleteFlashcardUsecase(
      flashcardRepository: flashcardRepository,
      schedulerEntryRepository: schedulerEntryRepository,
      reviewLogRepository: reviewLogRepository,
    );
    final editFlashcardUsecase =
        EditFlashcardUsecase(flashcardRepository: flashcardRepository);
    final getFlashcardsUsecase = GetFlashcardsUsecase(
      flashcardRepository: flashcardRepository,
      schedulerEntryRepository: schedulerEntryRepository,
      preferencesRepository: preferencesRepository,
    );
    final fsrsAlgorithmUsecase = FsrsAlgorithmUsecase();
    final rateFlashcardUsecase = RateFlashcardUsecase(
      flashcardRepository: flashcardRepository,
      schedulerEntryRepository: schedulerEntryRepository,
      reviewLogRepository: reviewLogRepository,
      preferencesRepository: preferencesRepository,
      fsrsAlgorithmUsecase: fsrsAlgorithmUsecase,
    );

    return Dependencies(
      createFlashcardUsecase: createFlashcardUsecase,
      deleteFlashcardUsecase: deleteFlashcardUsecase,
      editFlashcardUsecase: editFlashcardUsecase,
      getFlashcardsUsecase: getFlashcardsUsecase,
      rateFlashcardUsecase: rateFlashcardUsecase,
    );
  }
}
