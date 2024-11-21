import 'dart:collection';
import 'dart:math';

import 'package:meta/meta.dart';

enum State {
  newState(0),
  learning(1),
  review(2),
  relearning(3);

  const State(this.number);

  final int number;
}

enum Rating {
  again(1),
  hard(2),
  good(3),
  easy(4);

  const Rating(this.number);

  final int number;
}

@immutable
base class ReviewLog {
  const ReviewLog({
    required this.rating,
    required this.scheduledDays,
    required this.elapsedDays,
    required this.review,
    required this.state,
  });

  final Rating rating;
  final int scheduledDays;
  final int elapsedDays;
  final DateTime review;
  final State state;
}

base class Card {
  Card({
    DateTime? due,
    this.stability = 0,
    this.difficulty = 0,
    this.elapsedDays = 0,
    this.scheduledDays = 0,
    this.reps = 0,
    this.lapses = 0,
    this.state = State.newState,
    this.lastReview,
  }) : due = due ?? DateTime.now().toUtc();

  DateTime due;
  double stability;
  double difficulty;
  int elapsedDays;
  int scheduledDays;
  int reps;
  int lapses;
  State state;
  DateTime? lastReview;

  Card copyWith({
    DateTime? due,
    double? stability,
    double? difficulty,
    int? elapsedDays,
    int? scheduledDays,
    int? reps,
    int? lapses,
    State? state,
    DateTime? lastReview,
  }) {
    return Card(
      due: due ?? this.due,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      state: state ?? this.state,
      lastReview: lastReview ?? this.lastReview,
    );
  }

  double getRetrievability(DateTime? now) {
    const decay = -0.5;
    final factor = pow(0.9, 1 / decay) - 1;

    final time = now ?? DateTime.now().toUtc();

    switch (state) {
      case State.learning || State.review || State.relearning:
        final elapsedDays = max(0, time.difference(lastReview!).inDays);
        return pow(1 + factor * elapsedDays / stability, decay).toDouble();
      case State.newState:
        return 0;
    }
  }
}

@immutable
base class SchedulingInfo {
  const SchedulingInfo({
    required this.card,
    required this.reviewLog,
  });

  final Card card;
  final ReviewLog reviewLog;
}

@immutable
base class SchedulingCards {
  SchedulingCards({
    required Card again,
    required Card hard,
    required Card good,
    required Card easy,
  })  : again = again.copyWith(),
        hard = hard.copyWith(),
        good = good.copyWith(),
        easy = easy.copyWith();

  final Card again;
  final Card hard;
  final Card good;
  final Card easy;

  void updateState(State state) {
    switch (state) {
      case State.newState:
        again.state = State.learning;
        hard.state = State.learning;
        good.state = State.learning;
        easy.state = State.review;
      case State.learning || State.relearning:
        again.state = state;
        hard.state = state;
        good.state = State.review;
        easy.state = State.review;
      case State.review:
        again.state = State.relearning;
        hard.state = State.review;
        good.state = State.review;
        easy.state = State.review;
        again.lapses++;
    }
  }

  void schedule({
    required DateTime now,
    required int hardInterval,
    required int goodInterval,
    required int easyInterval,
  }) {
    again.scheduledDays = 0;
    hard.scheduledDays = hardInterval;
    good.scheduledDays = goodInterval;
    easy.scheduledDays = easyInterval;
    again.due = now.add(const Duration(minutes: 5));
    if (hardInterval > 0) {
      hard.due = now.add(Duration(days: hardInterval));
    } else {
      hard.due = now.add(const Duration(minutes: 10));
    }
    good.due = now.add(Duration(days: goodInterval));
    easy.due = now.add(Duration(days: easyInterval));
  }

  Map<Rating, SchedulingInfo> recordLog({
    required Card card,
    required DateTime now,
  }) {
    return {
      Rating.again: SchedulingInfo(
        card: again,
        reviewLog: ReviewLog(
          rating: Rating.again,
          scheduledDays: again.scheduledDays,
          elapsedDays: card.elapsedDays,
          review: now,
          state: card.state,
        ),
      ),
      Rating.hard: SchedulingInfo(
        card: hard,
        reviewLog: ReviewLog(
          rating: Rating.hard,
          scheduledDays: hard.scheduledDays,
          elapsedDays: card.elapsedDays,
          review: now,
          state: card.state,
        ),
      ),
      Rating.good: SchedulingInfo(
        card: good,
        reviewLog: ReviewLog(
          rating: Rating.good,
          scheduledDays: good.scheduledDays,
          elapsedDays: card.elapsedDays,
          review: now,
          state: card.state,
        ),
      ),
      Rating.easy: SchedulingInfo(
        card: easy,
        reviewLog: ReviewLog(
          rating: Rating.easy,
          scheduledDays: easy.scheduledDays,
          elapsedDays: card.elapsedDays,
          review: now,
          state: card.state,
        ),
      ),
    };
  }
}

@immutable
base class Parameters {
  Parameters({
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
