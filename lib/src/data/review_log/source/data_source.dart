import 'package:comfy_memo/src/domain/review_log/dto/fsrs_review_dto.dart';
import 'package:comfy_memo/src/domain/review_log/entity/fsrs_review_log_entity.dart';

base class ReviewLogInMemoryDataSource {
  final Map<int, List<FsrsReviewLogEntity>> _fsrsLogs = {};

  int _elementsForAllTime = 0;
  int get _nextId => _elementsForAllTime++;

  Future<void> delete(int cardId) async {
    _fsrsLogs.remove(cardId);
  }

  Future<List<FsrsReviewLogEntity>> fetchFsrs(int cardId) async {
    return _fsrsLogs[cardId] ?? [];
  }

  Future<void> logFsrs(int cardId, FsrsReviewDto params) async {
    final id = _nextId;
    final log = FsrsReviewLogEntity(
      cardId: cardId,
      review: params.review,
      rating: params.rating,
      reviewLogId: id,
      learningState: params.learningState,
    );

    _fsrsLogs.putIfAbsent(cardId, () => []).add(log);
  }
}
