class DetailQuizModel {
  DetailQuizModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
  final String? message;
  final DetailQuizModelData? data;

  factory DetailQuizModel.fromJson(Map<String, dynamic> json){
    return DetailQuizModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : DetailQuizModelData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  String toString(){
    return "$status, $message, $data, ";
  }
}

class DetailQuizModelData {
  DetailQuizModelData({
    required this.code,
    required this.message,
    required this.data,
    required this.error,
  });

  final num? code;
  final String? message;
  final DataData? data;
  final dynamic error;

  factory DetailQuizModelData.fromJson(Map<String, dynamic> json){
    return DetailQuizModelData(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "error": error,
  };

  @override
  String toString(){
    return "$code, $message, $data, $error, ";
  }
}

class DataData {
  DataData({
    required this.attemptId,
    required this.quizInfo,
    required this.questions,
  });

  final String? attemptId;
  final QuizInfo? quizInfo;
  final List<Question> questions;

  factory DataData.fromJson(Map<String, dynamic> json){
    return DataData(
      attemptId: json["attemptId"],
      quizInfo: json["quizInfo"] == null ? null : QuizInfo.fromJson(json["quizInfo"]),
      questions: json["questions"] == null ? [] : List<Question>.from(json["questions"]!.map((x) => Question.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "attemptId": attemptId,
    "quizInfo": quizInfo?.toJson(),
    "questions": questions.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$attemptId, $quizInfo, $questions, ";
  }
}

class Question {
  Question({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.timeLimitSec,
    required this.answers,
  });

  final String? questionId;
  final String? questionText;
  final String? questionType;
  final num? timeLimitSec;
  final List<Answer> answers;

  factory Question.fromJson(Map<String, dynamic> json){
    return Question(
      questionId: json["questionId"],
      questionText: json["questionText"],
      questionType: json["questionType"],
      timeLimitSec: json["timeLimitSec"],
      answers: json["answers"] == null ? [] : List<Answer>.from(json["answers"]!.map((x) => Answer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "questionText": questionText,
    "questionType": questionType,
    "timeLimitSec": timeLimitSec,
    "answers": answers.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$questionId, $questionText, $questionType, $timeLimitSec, $answers, ";
  }
}

class Answer {
  Answer({
    required this.answerId,
    required this.content,
  });

  final String? answerId;
  final String? content;

  factory Answer.fromJson(Map<String, dynamic> json){
    return Answer(
      answerId: json["answerId"],
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() => {
    "answerId": answerId,
    "content": content,
  };

  @override
  String toString(){
    return "$answerId, $content, ";
  }
}

class QuizInfo {
  QuizInfo({
    required this.quizId,
    required this.quizTitle,
    required this.quizDescription,
    required this.quizType,
    required this.passingScore,
    required this.maxAttempts,
    required this.remainingAttempts,
    required this.startTime,
    required this.endTime,
    required this.isRequired,
  });

  final String? quizId;
  final String? quizTitle;
  final String? quizDescription;
  final String? quizType;
  final String? passingScore;
  final num? maxAttempts;
  final num? remainingAttempts;
  final dynamic startTime;
  final dynamic endTime;
  final bool? isRequired;

  factory QuizInfo.fromJson(Map<String, dynamic> json){
    return QuizInfo(
      quizId: json["quizId"],
      quizTitle: json["quizTitle"],
      quizDescription: json["quizDescription"],
      quizType: json["quizType"],
      passingScore: json["passingScore"],
      maxAttempts: json["maxAttempts"],
      remainingAttempts: json["remainingAttempts"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      isRequired: json["isRequired"],
    );
  }

  Map<String, dynamic> toJson() => {
    "quizId": quizId,
    "quizTitle": quizTitle,
    "quizDescription": quizDescription,
    "quizType": quizType,
    "passingScore": passingScore,
    "maxAttempts": maxAttempts,
    "remainingAttempts": remainingAttempts,
    "startTime": startTime,
    "endTime": endTime,
    "isRequired": isRequired,
  };

  @override
  String toString(){
    return "$quizId, $quizTitle, $quizDescription, $quizType, $passingScore, $maxAttempts, $remainingAttempts, $startTime, $endTime, $isRequired, ";
  }
}
