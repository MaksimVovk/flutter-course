class QuizQuestions {
  const QuizQuestions(this.text, this.answers);
  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffeldList = List.of(answers);
    shuffeldList.shuffle();

    return shuffeldList;
  }
}
