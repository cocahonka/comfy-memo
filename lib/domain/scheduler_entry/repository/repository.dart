import 'package:comfy_memo/domain/scheduler_entry/dto/fsrs_scheduler_entry_update_dto.dart';
import 'package:comfy_memo/domain/scheduler_entry/entity/fsrs_scheduler_entry.dart';

abstract interface class ISchedulerEntryRepository {
  Future<void> create(int cardId);
  Future<FsrsSchedulerEntry> fetchFsrs(int cardId);
  Future<void> updateFsrs(FsrsSchedulerEntryUpdateDto dto, int cardId);
  Future<void> delete(int cardId);
}
