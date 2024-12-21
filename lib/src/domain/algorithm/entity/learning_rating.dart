enum LearningRating {
  forgot(1),
  hard(2),
  good(3),
  perfect(4);

  const LearningRating(this.score);

  final int score;
}
