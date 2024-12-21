import 'package:comfy_memo/src/data/review_log/source/data_source.dart';
import 'package:comfy_memo/src/domain/review_log/dto/fsrs_review_dto.dart';
import 'package:comfy_memo/src/domain/review_log/entity/fsrs_review_log_entity.dart';
import 'package:comfy_memo/src/domain/review_log/repository/repository.dart';

base class ReviewLogRepository implements IReviewLogRepository {
  ReviewLogRepository({
    required ReviewLogInMemoryDataSource source,
  }) : _source = source;

  final ReviewLogInMemoryDataSource _source;

  @override
  Future<void> delete(int cardId) => _source.delete(cardId);

  @override
  Future<List<FsrsReviewLogEntity>> fetchFsrs(int cardId) =>
      _source.fetchFsrs(cardId);

  @override
  Future<void> logFsrs(int cardId, FsrsReviewDto params) =>
      _source.logFsrs(cardId, params);
}
