import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm.dart';
import 'package:meta/meta.dart';

@immutable
final class FsrsReviewDto {
  const FsrsReviewDto({
    required this.review,
    required this.rating,
    required this.state,
  });

  final DateTime review;
  final LearningRating rating;
  final LearningState state;
}
