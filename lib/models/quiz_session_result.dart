import 'word.dart';

class QuizWrongAnswer {
  const QuizWrongAnswer({
    required this.word,
    required this.selectedAnswer,
    required this.correctAnswer,
  });

  final Word word;
  final String selectedAnswer;
  final String correctAnswer;
}

class QuizSessionResult {
  const QuizSessionResult({
    required this.totalWords,
    required this.correctCount,
    required this.wrongAnswers,
  });

  final int totalWords;
  final int correctCount;
  final List<QuizWrongAnswer> wrongAnswers;

  int get accuracyPercent =>
      totalWords == 0 ? 0 : (correctCount / totalWords * 100).round();
}