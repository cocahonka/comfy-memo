import 'package:comfy_memo/data/flashcard/repository.dart';
import 'package:comfy_memo/data/preferences/repository.dart';
import 'package:comfy_memo/data/review_log/repository.dart';
import 'package:comfy_memo/data/scheduler_entry/repository.dart';
import 'package:comfy_memo/domain/algorithm/fsrs/fsrs.dart';
import 'package:comfy_memo/domain/initialization/dependencies.dart';
import 'package:meta/meta.dart';

@immutable
final class CompositionRoot {
  Future<Dependencies> compose() async {
    final flashcardRepository = FlashcardRepositoryImpl();
    final schedulerEntryRepository = SchedulerEntryRepositoryImpl();
    final reviewLogRepository = ReviewLogRepositoryImpl();
    final preferencesRepository = PreferencesRepositoryImpl();
    final fsrsAlgorithm = FsrsAlgorithm(fsrs: Fsrs());

    return Dependencies(
      flashcardRepository: flashcardRepository,
      schedulerEntryRepository: schedulerEntryRepository,
      reviewLogRepository: reviewLogRepository,
      preferencesRepository: preferencesRepository,
      fsrsAlgorithm: fsrsAlgorithm,
    );
  }
}
