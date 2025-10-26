import 'package:ed_tech/modules/assessment/models/detail_quiz_model.dart'
    as detail_model;

class QuestionModel {
  final String id;
  final String questionText;
  final List<AnswerModel> answers;
  final String? explanation;
  final int timeLimit;

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.answers,
    this.explanation,
    this.timeLimit = 0,
  });

  AnswerModel? get correctAnswer => answers.firstWhere(
    (answer) => answer.isCorrect,
    orElse: () => answers.first,
  );
}

class AnswerModel {
  final String id;
  final String text;
  final bool isCorrect;
  final String? explanation;

  const AnswerModel({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.explanation,
  });
}

class QuizSessionModel {
  final String id;
  final String quizId;
  final List<QuestionModel> questions;
  final Map<String, String?> userAnswers;
  final DateTime startTime;
  final int currentQuestionIndex;

  const QuizSessionModel({
    required this.id,
    required this.quizId,
    required this.questions,
    required this.userAnswers,
    required this.startTime,
    this.currentQuestionIndex = 0,
  });

  QuestionModel get currentQuestion => questions[currentQuestionIndex];
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  bool get isFirstQuestion => currentQuestionIndex == 0;
  int get totalQuestions => questions.length;
  int get answeredQuestions =>
      userAnswers.values.where((answer) => answer != null).length;
  double get progress {
    if (totalQuestions == 0) return 0.0;
    final p = answeredQuestions / totalQuestions;
    return p.clamp(0.0, 1.0);
  }

  QuizSessionModel copyWith({
    String? id,
    String? quizId,
    List<QuestionModel>? questions,
    Map<String, String?>? userAnswers,
    DateTime? startTime,
    int? currentQuestionIndex,
  }) {
    return QuizSessionModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      startTime: startTime ?? this.startTime,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }
}

/// Extension để convert từ API model sang UI model
extension QuestionModelExtension on detail_model.Question {
  QuestionModel toQuestionModel() {
    return QuestionModel(
      id: questionId ?? '',
      questionText: questionText ?? '',
      answers:
          answers
              .map(
                (ans) => AnswerModel(
                  id: ans.answerId ?? '',
                  text: ans.content ?? '',
                  isCorrect:
                      false, // API không trả về đáp án đúng, mặc định false
                ),
              )
              .toList(),
      timeLimit: (timeLimitSec ?? 0).toInt(),
    );
  }
}
