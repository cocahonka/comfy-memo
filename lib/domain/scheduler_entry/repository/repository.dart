import 'package:comfy_memo/domain/scheduler_entry/dto/fsrs_scheduler_entry_update_dto.dart';
import 'package:comfy_memo/domain/scheduler_entry/entity/fsrs_scheduler_entry.dart';

abstract interface class ISchedulerEntryRepository {
  Future<FsrsSchedulerEntry> fetchFsrs(int cardId);
  Future<void> updateFsrs(FsrsSchedulerEntryUpdateDto dto, int cardId);
}
