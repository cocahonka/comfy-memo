import 'dart:collection';

import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/review_log/entity/fsrs_review_log_entity.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';
import 'package:meta/meta.dart';

enum LearningState {
  newState(0),
  learning(1),
  review(2),
  relearning(3);

  const LearningState(this.number);

  final int number;
}

@immutable
final class FsrsParameters {
  FsrsParameters({
    double? requestRetention,
    int? maximumInterval,
    List<double>? weights,
  })  : requestRetention = requestRetention ?? 0.9,
        maximumInterval = maximumInterval ?? 36500,
        weights = weights == null
            ? UnmodifiableListView([
                0.4072,
                1.1829,
                3.1262,
                15.4722,
                7.2102,
                0.5316,
                1.0651,
                0.0234,
                1.616,
                0.1544,
                1.0824,
                1.9813,
                0.0953,
                0.2975,
                2.2042,
                0.2407,
                2.9466,
                0.5034,
                0.6567,
              ])
            : UnmodifiableListView([...weights]) {
    if (this.weights.length != 19) {
      throw ArgumentError('weights must have 19 elements', 'weights');
    }
  }

  final double requestRetention;
  final int maximumInterval;
  final UnmodifiableListView<double> weights;
}

@immutable
final class FsrsAlgorithm {
  const FsrsAlgorithm();

  (FsrsSchedulerEntryEntity, FsrsReviewLogEntity) process({
    required FsrsSchedulerEntryEntity scheduler,
    required LearningRating rating,
  }) {
    throw UnimplementedError();
  }
}
