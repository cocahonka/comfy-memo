import 'package:comfy_memo/domain/algorithm/fsrs/entity/learning_state.dart';
import 'package:comfy_memo/domain/scheduler_entry/dto/fsrs_scheduler_entry_update_dto.dart';
import 'package:comfy_memo/domain/scheduler_entry/entity/fsrs_scheduler_entry.dart';
import 'package:comfy_memo/domain/scheduler_entry/repository/repository.dart';

base class SchedulerEntryRepositoryImpl implements ISchedulerEntryRepository {
  final Map<int, FsrsSchedulerEntry> _schedulers = {};

  int _elementsForAllTime = 0;
  int get _nextId => _elementsForAllTime++;

  @override
  Future<void> create(int cardId) async {
    final id = _nextId;
    _schedulers[cardId] = FsrsSchedulerEntry(
      id: id,
      schedulerId: id,
      cardId: cardId,
      due: DateTime.now().toUtc(),
      scheduledDays: 0,
      elapsedDays: 0,
      reps: 0,
      lapses: 0,
      lastReview: null,
      stability: 0,
      difficulty: 0,
      state: LearningState.newState,
    );
  }

  @override
  Future<FsrsSchedulerEntry> fetchFsrs(int cardId) async {
    return _schedulers[cardId]!;
  }

  @override
  Future<void> updateFsrs(FsrsSchedulerEntryUpdateDto dto, int cardId) async {
    _schedulers[cardId] = FsrsSchedulerEntry(
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

  @override
  Future<void> delete(int cardId) async {
    _schedulers.remove(cardId);
  }
}
