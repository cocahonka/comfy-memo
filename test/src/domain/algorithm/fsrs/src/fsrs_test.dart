import 'package:comfy_memo/src/domain/algorithm/fsrs/src/fsrs.dart';
import 'package:comfy_memo/src/domain/algorithm/fsrs/src/models.dart';
import 'package:test/test.dart';

void main() {
  late List<double> weights;

  setUp(() {
    weights = [
      0.4197,
      1.1869,
      3.0412,
      15.2441,
      7.1434,
      0.6477,
      1.0007,
      0.0674,
      1.6597,
      0.1712,
      1.1178,
      2.0225,
      0.0904,
      0.3025,
      2.1214,
      0.2498,
      2.9466,
      0.4891,
      0.6468,
    ];
  });

  test('Validate scheduling of card reviews based on various ratings', () {
    final fsrs = Fsrs(parameters: Parameters(weights: weights));
    var card = Card();
    var now = DateTime.utc(2022, 11, 29, 12, 30, 0, 0);

    final ratings = [
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.again,
      Rating.again,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
    ];
    final days = <int>[];

    for (final rating in ratings) {
      card = fsrs.reviewCard(card: card, rating: rating, repeatTime: now).card;
      days.add(card.scheduledDays);
      now = card.due;
    }

    expect(
      days,
      equals([
        0,
        4,
        17,
        62,
        198,
        563,
        0,
        0,
        9,
        27,
        74,
        190,
        457,
      ]),
    );
  });

  test(
      'Test card state transitions and calculation of stability '
      'and difficulty after multiple reviews', () {
    final fsrs = Fsrs(parameters: Parameters(weights: weights));
    var card = Card();
    var now = DateTime.utc(2022, 11, 29, 12, 30, 0, 0);

    var schedulingCards = fsrs.repeat(inputCard: card, repeatTime: now);
    final ratings = [
      Rating.again,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
    ];
    final days = [0, 0, 1, 3, 8, 21];

    for (var i = 0; i < ratings.length; i++) {
      final (rating, schedulingDays) = (ratings[i], days[i]);
      card = schedulingCards[rating]!.card;
      now = now.add(Duration(days: schedulingDays));
      schedulingCards = fsrs.repeat(inputCard: card, repeatTime: now);
    }

    expect(
      schedulingCards[Rating.good]!.card.stability,
      closeTo(71.4554, 0.0001),
    );
    expect(
      schedulingCards[Rating.good]!.card.difficulty,
      closeTo(5.0976, 0.0001),
    );
  });

  test('Verify default argument behavior in the repeat function', () {
    final fsrs = Fsrs();
    final card = Card();
    final schedulingCards = fsrs.repeat(inputCard: card);

    const cardRating = Rating.good;

    final newCard = schedulingCards[cardRating]!.card;
    final due = newCard.due;
    final timeDelta = due.difference(DateTime.now().toUtc());

    expect(timeDelta.inSeconds, greaterThan(500));
  });

  test('Ensure correct handling of DateTime during card scheduling', () async {
    final fsrs = Fsrs();
    final card = Card();

    await Future<void>.delayed(const Duration(milliseconds: 1));

    expect(DateTime.now().toUtc().isAfter(card.due), isTrue);

    expect(
      () => fsrs.repeat(
        inputCard: card,
        repeatTime: DateTime.now(),
      ),
      throwsA(isA<ArgumentError>()),
    );

    final schedulingCards =
        fsrs.repeat(inputCard: card, repeatTime: DateTime.now().toUtc());
    final newCard = schedulingCards[Rating.good]!.card;

    expect(newCard.due.isUtc, isTrue);
    expect(newCard.lastReview!.isUtc, isTrue);
    expect(newCard.due.isAfter(newCard.lastReview!), isTrue);
  });

  test('Test scheduler functionality with custom algorithm parameters', () {
    final fsrs = Fsrs(
      parameters: Parameters(
        weights: const [
          0.4197,
          1.1869,
          3.0412,
          15.2441,
          7.1434,
          0.6477,
          1.0007,
          0.0674,
          1.6597,
          0.1712,
          1.1178,
          2.0225,
          0.0904,
          0.3025,
          2.1214,
          0.2498,
          2.9466,
          0,
          0.6468,
        ],
        requestRetention: 0.9,
        maximumInterval: 36500,
      ),
    );
    var card = Card();
    var now = DateTime.utc(2022, 11, 29, 12, 30, 0, 0);

    final ratings = [
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.again,
      Rating.again,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
      Rating.good,
    ];
    final days = <int>[];

    for (final rating in ratings) {
      card = fsrs.reviewCard(card: card, rating: rating, repeatTime: now).card;
      days.add(card.scheduledDays);
      now = card.due;
    }

    expect(
      days,
      equals([
        0,
        3,
        13,
        50,
        163,
        473,
        0,
        0,
        12,
        34,
        91,
        229,
        541,
      ]),
    );

    final weights2 = [
      0.1456,
      0.4186,
      1.1104,
      4.1315,
      5.2417,
      1.3098,
      0.8975,
      0.0000,
      1.5674,
      0.0567,
      0.9661,
      2.0275,
      0.1592,
      0.2446,
      1.5071,
      0.2272,
      2.8755,
      1.234,
      5.6789,
    ];
    const requestRetention2 = 0.85;
    const maximumInterval2 = 3650;
    final fsrs2 = Fsrs(
      parameters: Parameters(
        weights: weights2,
        requestRetention: requestRetention2,
        maximumInterval: maximumInterval2,
      ),
    );

    expect(fsrs2.parameters.weights, equals(weights2));
    expect(fsrs2.parameters.requestRetention, equals(requestRetention2));
    expect(fsrs2.parameters.maximumInterval, equals(maximumInterval2));
  });

  test(
      'Confirm accurate calculation of retrievability across '
      'different card states', () {
    final fsrs = Fsrs();
    var card = Card();

    expect(card.state, equals(State.newState));
    expect(card.getRetrievability(), equals(0));

    card = fsrs.reviewCard(card: card, rating: Rating.good).card;
    expect(card.state, equals(State.learning));
    expect(card.getRetrievability(), inInclusiveRange(0, 1));

    card = fsrs.reviewCard(card: card, rating: Rating.good).card;
    expect(card.state, equals(State.review));
    expect(card.getRetrievability(), inInclusiveRange(0, 1));

    card = fsrs.reviewCard(card: card, rating: Rating.again).card;
    expect(card.state, equals(State.relearning));
    expect(card.getRetrievability(), inInclusiveRange(0, 1));
  });
}
