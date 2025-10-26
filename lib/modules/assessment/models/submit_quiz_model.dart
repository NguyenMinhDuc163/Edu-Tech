class SubmitQuizModel {
  SubmitQuizModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
  final String? message;
  final Data? data;

  factory SubmitQuizModel.fromJson(Map<String, dynamic> json) {
    return SubmitQuizModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString() {
    return "$status, $message, $data, ";
  }
}

class Data {
  Data({
    required this.attemptId,
    required this.quizId,
    required this.score,
    required this.isPassed,
    required this.passingScore,
    required this.timeSpentMinutes,
    required this.submittedAt,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.questionResults,
  });

  final String? attemptId;
  final String? quizId;
  final String? score;
  final bool? isPassed;
  final String? passingScore;
  final num? timeSpentMinutes;
  final DateTime? submittedAt;
  final num? totalQuestions;
  final num? correctAnswers;
  final List<QuestionResult> questionResults;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      attemptId: json["attemptId"],
      quizId: json["quizId"],
      score: json["score"],
      isPassed: json["isPassed"],
      passingScore: json["passingScore"],
      timeSpentMinutes: json["timeSpentMinutes"],
      submittedAt: DateTime.tryParse(json["submittedAt"] ?? ""),
      totalQuestions: json["totalQuestions"],
      correctAnswers: json["correctAnswers"],
      questionResults:
          json["questionResults"] == null
              ? []
              : List<QuestionResult>.from(
                json["questionResults"]!.map((x) => QuestionResult.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "attemptId": attemptId,
    "quizId": quizId,
    "score": score,
    "isPassed": isPassed,
    "passingScore": passingScore,
    "timeSpentMinutes": timeSpentMinutes,
    "submittedAt": submittedAt?.toIso8601String(),
    "totalQuestions": totalQuestions,
    "correctAnswers": correctAnswers,
    "questionResults": questionResults.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString() {
    return "$attemptId, $quizId, $score, $isPassed, $passingScore, $timeSpentMinutes, $submittedAt, $totalQuestions, $correctAnswers, $questionResults, ";
  }
}

class QuestionResult {
  QuestionResult({
    required this.questionId,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswerId,
    required this.isCorrect,
    required this.pointsEarned,
  });

  final String? questionId;
  final String? questionText;
  final UserAnswer? userAnswer;
  final String? correctAnswerId;
  final bool? isCorrect;
  final String? pointsEarned;

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json["questionId"],
      questionText: json["questionText"],
      userAnswer:
          json["userAnswer"] == null
              ? null
              : UserAnswer.fromJson(json["userAnswer"]),
      correctAnswerId: json["correctAnswerId"],
      isCorrect: json["isCorrect"],
      pointsEarned: json["pointsEarned"],
    );
  }

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "questionText": questionText,
    "userAnswer": userAnswer?.toJson(),
    "correctAnswerId": correctAnswerId,
    "isCorrect": isCorrect,
    "pointsEarned": pointsEarned,
  };

  @override
  String toString() {
    return "$questionId, $questionText, $userAnswer, $correctAnswerId, $isCorrect, $pointsEarned, ";
  }
}

class UserAnswer {
  UserAnswer({required this.answerId, required this.textAnswer});

  final String? answerId;
  final dynamic textAnswer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      answerId: json["answerId"],
      textAnswer: json["textAnswer"],
    );
  }

  Map<String, dynamic> toJson() => {
    "answerId": answerId,
    "textAnswer": textAnswer,
  };

  @override
  String toString() {
    return "$answerId, $textAnswer, ";
  }
}
