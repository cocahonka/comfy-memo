import 'package:comfy_memo/domain/scheduler_entry/dto/fsrs_scheduler_entry_update_dto.dart';
import 'package:comfy_memo/domain/scheduler_entry/entity/fsrs_scheduler_entry.dart';
import 'package:comfy_memo/domain/scheduler_entry/repository/repository.dart';

base class SchedulerEntryRepositoryImpl implements ISchedulerEntryRepository {
  final Map<int, FsrsSchedulerEntry> _flashcards = {};

  @override
  Future<FsrsSchedulerEntry> fetchFsrs(int cardId) async {
    return _flashcards[cardId]!;
  }

  @override
  Future<void> updateFsrs(FsrsSchedulerEntryUpdateDto dto, int cardId) async {
    _flashcards[cardId] = FsrsSchedulerEntry(
      id: 0,
      schedulerId: 0,
      cardId: cardId,
      due: dto.due,
      scheduledDays: dto.scheduledDays,
      elapsedDays: dto.elapsedDays,
      reps: dto.reps,
      lapses: dto.lapses,
      lastReview: dto.lastReview,
      stability: dto.stability,
      difficulty: dto.difficulty,
      state: dto.state,
    );
  }
}
