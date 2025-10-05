class QuizResultModel {
  final String id;
  final String quizId;
  final String quizTitle;
  final double totalScore;
  final double maxScore;
  final double multipleChoiceScore;
  final double essayScore;
  final List<QuestionResultModel> questionResults;
  final DateTime completedAt;
  final Duration timeTaken;
  final String performanceMessage;

  const QuizResultModel({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.totalScore,
    required this.maxScore,
    required this.multipleChoiceScore,
    required this.essayScore,
    required this.questionResults,
    required this.completedAt,
    required this.timeTaken,
    required this.performanceMessage,
  });

  double get percentage => (totalScore / maxScore) * 100;
  String get percentageText => '${percentage.round()}%';

  List<QuestionResultModel> get multipleChoiceQuestions =>
      questionResults
          .where((q) => q.questionType == QuestionType.multipleChoice)
          .toList();

  List<QuestionResultModel> get essayQuestions =>
      questionResults
          .where((q) => q.questionType == QuestionType.essay)
          .toList();

  int get correctAnswers => questionResults.where((q) => q.isCorrect).length;
  int get totalQuestions => questionResults.length;
  int get correctMultipleChoice =>
      multipleChoiceQuestions.where((q) => q.isCorrect).length;
  int get totalMultipleChoice => multipleChoiceQuestions.length;
  int get correctEssay => essayQuestions.where((q) => q.isCorrect).length;
  int get totalEssay => essayQuestions.length;
}

class QuestionResultModel {
  final String id;
  final int questionNumber;
  final String questionText;
  final QuestionType questionType;
  final double score;
  final double maxScore;
  final bool isCorrect;
  final String? userAnswer;
  final String? correctAnswer;
  final String? explanation;

  const QuestionResultModel({
    required this.id,
    required this.questionNumber,
    required this.questionText,
    required this.questionType,
    required this.score,
    required this.maxScore,
    required this.isCorrect,
    this.userAnswer,
    this.correctAnswer,
    this.explanation,
  });

  String get scoreText => '$score/$maxScore';
  String get questionHeader => 'Câu $questionNumber ($score/$maxScore điểm)';
}

enum QuestionType { multipleChoice, essay }
