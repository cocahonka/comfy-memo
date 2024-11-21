enum Rating {
  forgot(1),
  hard(2),
  good(3),
  perfect(4);

  const Rating(this.score);

  final int score;
}
