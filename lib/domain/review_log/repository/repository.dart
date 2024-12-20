import 'package:comfy_memo/domain/review_log/dto/fsrs_review_dto.dart';

abstract interface class IReviewLogRepository {
  Future<void> logFsrs(FsrsReviewDto dto, int cardId);
}
