import 'dart:math';

import 'package:comfy_memo/src/domain/algorithm/fsrs/src/models.dart';

import 'package:meta/meta.dart';

@immutable
base class Fsrs {
  Fsrs({Parameters? parameters}) : parameters = parameters ?? Parameters();

  final Parameters parameters;
  final double decay = -0.5;
  late final double factor = pow(0.9, 1 / decay) - 1;

  ({Card card, ReviewLog reviewLog}) reviewCard({
    required Card card,
    required Rating rating,
    DateTime? repeatTime,
  }) {
    final schedulingCards = repeat(inputCard: card, repeatTime: repeatTime);
    final newCard = schedulingCards[rating]!.card;
    final reviewLog = schedulingCards[rating]!.reviewLog;

    return (card: newCard, reviewLog: reviewLog);
  }

  Map<Rating, SchedulingInfo> repeat({
    required Card inputCard,
    DateTime? repeatTime,
  }) {
    final now = repeatTime ?? DateTime.now().toUtc();

    if (!now.isUtc) {
      throw ArgumentError(
        'datetime must be timezone-aware and set to UTC',
        'repeatTime',
      );
    }

    final card = inputCard.copyWith();
    if (card.state == State.newState) {
      card.elapsedDays = 0;
    } else {
      card.elapsedDays = now.difference(card.lastReview!).inDays;
    }
    card.lastReview = now;
    card.reps++;
    final schedulingCards = SchedulingCards(card: card);
    schedulingCards.updateState(card.state);

    switch (card.state) {
      case State.newState:
        initDifficultyAndStability(schedulingCards: schedulingCards);

        schedulingCards.again.due = now.add(const Duration(minutes: 1));
        schedulingCards.hard.due = now.add(const Duration(minutes: 5));
        schedulingCards.good.due = now.add(const Duration(minutes: 10));
        final easyInterval =
            nextInterval(stability: schedulingCards.easy.stability);
        schedulingCards.easy.scheduledDays = easyInterval;
        schedulingCards.easy.due = now.add(Duration(days: easyInterval));
      case State.learning || State.relearning:
        final interval = card.elapsedDays;
        final lastDifficulty = card.difficulty;
        final lastStability = card.stability;
        final retrievability =
            forgettingCurve(elapsedDays: interval, stability: lastStability);
        nextDifficultyAndStability(
          schedulingCards: schedulingCards,
          lastDifficulty: lastDifficulty,
          lastStability: lastStability,
          retrievability: retrievability,
          state: card.state,
        );

        const hardInterval = 0;
        final goodInterval =
            nextInterval(stability: schedulingCards.good.stability);
        final easyInterval = max(
          nextInterval(stability: schedulingCards.easy.stability),
          goodInterval + 1,
        );
        schedulingCards.schedule(
          now: now,
          hardInterval: hardInterval,
          goodInterval: goodInterval,
          easyInterval: easyInterval,
        );
      case State.review:
        final interval = card.elapsedDays;
        final lastDifficulty = card.difficulty;
        final lastStability = card.stability;
        final retrievability =
            forgettingCurve(elapsedDays: interval, stability: lastStability);
        nextDifficultyAndStability(
          schedulingCards: schedulingCards,
          lastDifficulty: lastDifficulty,
          lastStability: lastStability,
          retrievability: retrievability,
          state: card.state,
        );

        var hardInterval =
            nextInterval(stability: schedulingCards.hard.stability);
        var goodInterval =
            nextInterval(stability: schedulingCards.good.stability);
        hardInterval = min(hardInterval, goodInterval);
        goodInterval = max(goodInterval, hardInterval + 1);
        final easyInterval = max(
          nextInterval(stability: schedulingCards.easy.stability),
          goodInterval + 1,
        );
        schedulingCards.schedule(
          now: now,
          hardInterval: hardInterval,
          goodInterval: goodInterval,
          easyInterval: easyInterval,
        );
    }

    return schedulingCards.recordLog(card: card, now: now);
  }

  void initDifficultyAndStability({required SchedulingCards schedulingCards}) {
    schedulingCards.again.difficulty = initDifficulty(rating: Rating.again);
    schedulingCards.hard.difficulty = initDifficulty(rating: Rating.hard);
    schedulingCards.good.difficulty = initDifficulty(rating: Rating.good);
    schedulingCards.easy.difficulty = initDifficulty(rating: Rating.easy);

    schedulingCards.again.stability = initStability(rating: Rating.again);
    schedulingCards.hard.stability = initStability(rating: Rating.hard);
    schedulingCards.good.stability = initStability(rating: Rating.good);
    schedulingCards.easy.stability = initStability(rating: Rating.easy);
  }

  void nextDifficultyAndStability({
    required SchedulingCards schedulingCards,
    required double lastDifficulty,
    required double lastStability,
    required double retrievability,
    required State state,
  }) {
    schedulingCards.again.difficulty =
        nextDifficulty(difficulty: lastDifficulty, rating: Rating.again);
    schedulingCards.hard.difficulty =
        nextDifficulty(difficulty: lastDifficulty, rating: Rating.hard);
    schedulingCards.good.difficulty =
        nextDifficulty(difficulty: lastDifficulty, rating: Rating.good);
    schedulingCards.easy.difficulty =
        nextDifficulty(difficulty: lastDifficulty, rating: Rating.easy);

    switch (state) {
      case State.learning || State.relearning:
        schedulingCards.again.stability =
            shortTermStability(stability: lastStability, rating: Rating.again);
        schedulingCards.hard.stability =
            shortTermStability(stability: lastStability, rating: Rating.hard);
        schedulingCards.good.stability =
            shortTermStability(stability: lastStability, rating: Rating.good);
        schedulingCards.easy.stability =
            shortTermStability(stability: lastStability, rating: Rating.easy);
      case State.review:
        schedulingCards.again.stability = nextForgetStability(
          difficulty: lastDifficulty,
          stability: lastStability,
          retrievability: retrievability,
        );
        schedulingCards.hard.stability = nextRecallStability(
          difficulty: lastDifficulty,
          stability: lastStability,
          retrievability: retrievability,
          rating: Rating.hard,
        );
        schedulingCards.good.stability = nextRecallStability(
          difficulty: lastDifficulty,
          stability: lastStability,
          retrievability: retrievability,
          rating: Rating.good,
        );
        schedulingCards.easy.stability = nextRecallStability(
          difficulty: lastDifficulty,
          stability: lastStability,
          retrievability: retrievability,
          rating: Rating.easy,
        );
      case State.newState:
    }
  }

  double initStability({required Rating rating}) {
    return max(parameters.weights[rating.number - 1], 0.1);
  }

  double initDifficulty({required Rating rating}) {
    return min(
      max(
        parameters.weights[4] -
            exp(parameters.weights[5] * (rating.number - 1)) +
            1,
        1,
      ),
      10,
    );
  }

  double forgettingCurve({
    required int elapsedDays,
    required double stability,
  }) {
    return pow(1 + factor * elapsedDays / stability, decay).toDouble();
  }

  int nextInterval({required double stability}) {
    final newInterval =
        stability / factor * (pow(parameters.requestRetention, 1 / decay) - 1);
    return min(max(newInterval.round(), 1), parameters.maximumInterval);
  }

  double nextDifficulty({
    required double difficulty,
    required Rating rating,
  }) {
    final nextDifficulty =
        difficulty - parameters.weights[6] * (rating.number - 3);

    return min(
      max(
        meanReversion(
          init: initDifficulty(rating: Rating.easy),
          current: nextDifficulty,
        ),
        1,
      ),
      10,
    );
  }

  double shortTermStability({
    required double stability,
    required Rating rating,
  }) {
    return stability *
        exp(
          parameters.weights[17] * (rating.number - 3 + parameters.weights[18]),
        );
  }

  double meanReversion({
    required double init,
    required double current,
  }) {
    return parameters.weights[7] * init + (1 - parameters.weights[7]) * current;
  }

  double nextRecallStability({
    required double difficulty,
    required double stability,
    required double retrievability,
    required Rating rating,
  }) {
    final hardPenalty = rating == Rating.hard ? parameters.weights[15] : 1;
    final easyBonus = rating == Rating.easy ? parameters.weights[16] : 1;
    return stability *
        (1 +
            exp(parameters.weights[8]) *
                (11 - difficulty) *
                pow(stability, -parameters.weights[9]) *
                (exp((1 - retrievability) * parameters.weights[10]) - 1) *
                hardPenalty *
                easyBonus);
  }

  double nextForgetStability({
    required double difficulty,
    required double stability,
    required double retrievability,
  }) {
    return parameters.weights[11] *
        pow(difficulty, -parameters.weights[12]) *
        (pow(stability + 1, parameters.weights[13]) - 1) *
        exp((1 - retrievability) * parameters.weights[14]);
  }
}
