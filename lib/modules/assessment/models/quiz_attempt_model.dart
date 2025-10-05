class QuizAttemptModel {
  final String id;
  final String quizId;
  final double totalScore;
  final int correctAnswers;
  final int totalQuestions;
  final int timeTaken; 
  final DateTime completedAt;
  final List<QuestionAttemptModel> questionAttempts;

  const QuizAttemptModel({
    required this.id,
    required this.quizId,
    required this.totalScore,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeTaken,
    required this.completedAt,
    required this.questionAttempts,
  });

  String get correctAnswersText => '$correctAnswers/$totalQuestions câu';
  String get timeTakenText => '$timeTaken phút';
  String get formattedDate =>
      '${completedAt.day.toString().padLeft(2, '0')}/${completedAt.month.toString().padLeft(2, '0')}/${completedAt.year}';
  String get formattedTime =>
      '${completedAt.hour.toString().padLeft(2, '0')}:${completedAt.minute.toString().padLeft(2, '0')}';
  String get fullDateTime => '$formattedDate $formattedTime';
}

class QuestionAttemptModel {
  final String id;
  final String questionId;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;

  const QuestionAttemptModel({
    required this.id,
    required this.questionId,
    this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });
}
