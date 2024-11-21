import 'package:comfy_memo/src/domain/review_log/dto/fsrs_review_dto.dart';
import 'package:comfy_memo/src/domain/review_log/entity/fsrs_review_log_entity.dart';

abstract interface class IReviewLogRepository {
  Future<void> logFsrs(int cardId, FsrsReviewDto params);

  Future<List<FsrsReviewLogEntity>> fetchFsrs(int cardId);

  Future<void> delete(int cardId);
}
