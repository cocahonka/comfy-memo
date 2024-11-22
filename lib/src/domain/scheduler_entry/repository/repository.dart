import 'package:comfy_memo/src/domain/scheduler_entry/dto/fsrs_scheduler_update_dto.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';

abstract interface class ISchedulerEntryRepository {
  Future<void> create(int cardId);

  Future<FsrsSchedulerEntryEntity> fetchFsrs(int cardId);

  Future<void> updateFsrs(int cardId, FsrsSchedulerUpdateDto params);

  Future<void> delete(int cardId);
}
