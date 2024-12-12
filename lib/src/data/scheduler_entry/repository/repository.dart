import 'package:comfy_memo/src/data/scheduler_entry/source/data_source.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/dto/fsrs_scheduler_update_dto.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';

base class SchedulerEntryRepository implements ISchedulerEntryRepository {
  SchedulerEntryRepository({required SchedulerEntryInMemoryDataSource source})
      : _source = source;

  final SchedulerEntryInMemoryDataSource _source;

  @override
  Future<void> create(int cardId) async {
    return _source.create(cardId);
  }

  @override
  Future<void> delete(int cardId) async {
    return _source.delete(cardId);
  }

  @override
  Future<FsrsSchedulerEntryEntity> fetchFsrs(int cardId) async {
    return _source.fetchFsrs(cardId);
  }

  @override
  Future<void> updateFsrs(int cardId, FsrsSchedulerUpdateDto params) async {
    return _source.updateFsrs(cardId, params);
  }
}
