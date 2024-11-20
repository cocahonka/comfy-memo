enum LearningState {
  newState(0),
  learning(1),
  review(2),
  relearning(3);

  const LearningState(this.number);

  final int number;
}
