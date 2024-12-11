import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/dto/fsrs_scheduler_update_dto.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';

base class SchedulerEntryInMemoryDataSource {
  final Map<int, FsrsSchedulerEntryEntity> _fsrsEntries = {};

  int _elementsForAllTime = 0;
  int get _nextId => _elementsForAllTime++;

  Future<void> create(int cardId) async {
    final id = _nextId;
    final entry = FsrsSchedulerEntryEntity(
      cardId: cardId,
      due: DateTime.now().toUtc(),
      scheduledDays: 0,
      elapsedDays: 0,
      reps: 0,
      lapses: 0,
      lastReview: null,
      schedulerId: id,
      stability: 0,
      difficulty: 0,
      learningState: LearningState.newState,
    );

    _fsrsEntries[cardId] = entry;
  }

  Future<void> delete(int cardId) async {
    _fsrsEntries.remove(cardId);
  }

  Future<FsrsSchedulerEntryEntity> fetchFsrs(int cardId) async {
    return _fsrsEntries[cardId]!;
  }

  Future<void> updateFsrs(int cardId, FsrsSchedulerUpdateDto params) async {
    final entry = _fsrsEntries[cardId]!;
    final updatedEntry = FsrsSchedulerEntryEntity(
      cardId: cardId,
      due: params.due,
      scheduledDays: params.scheduledDays,
      elapsedDays: params.elapsedDays,
      reps: params.reps,
      lapses: params.lapses,
      lastReview: params.lastReview,
      schedulerId: entry.schedulerId,
      stability: params.stability,
      difficulty: params.difficulty,
      learningState: params.learningState,
    );

    _fsrsEntries[cardId] = updatedEntry;
  }
}
