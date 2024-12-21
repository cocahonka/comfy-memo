import 'package:comfy_memo/domain/review_log/dto/fsrs_review_dto.dart';
import 'package:comfy_memo/domain/review_log/entity/fsrs_review_log.dart';
import 'package:comfy_memo/domain/review_log/repository/repository.dart';

base class ReviewLogRepositoryImpl implements IReviewLogRepository {
  final Map<int, List<FsrsReviewLog>> _logs = {};

  @override
  Future<void> logFsrs(FsrsReviewDto dto, int cardId) async {
    final logs = _logs[cardId] ??= [];
    logs.add(
      FsrsReviewLog(
        id: logs.length,
        reviewLogId: 0,
        cardId: cardId,
        review: dto.review,
        rating: dto.rating,
        state: dto.state,
      ),
    );
  }

  @override
  Future<void> delete(int cardId) async {
    _logs.remove(cardId);
  }
}
