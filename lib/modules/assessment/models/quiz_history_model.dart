class QuizHistoryModel {
  QuizHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
  final String? message;
  final List<QuizHistoryItem> data;

  factory QuizHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuizHistoryModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<QuizHistoryItem>.from(json["data"]!.map((x) => QuizHistoryItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class QuizHistoryItem {
  QuizHistoryItem({
    required this.resultId,
    required this.attemptId,
    required this.attemptNumber,
    required this.status,
    required this.score,
    required this.isPassed,
    required this.startedAt,
    required this.completedAt,
    required this.timeSpentMinutes,
  });

  final String? resultId;
  final String? attemptId;
  final num? attemptNumber;
  final String? status;
  final String? score;
  final bool? isPassed;
  final String? startedAt;
  final String? completedAt;
  final num? timeSpentMinutes;

  factory QuizHistoryItem.fromJson(Map<String, dynamic> json) {
    return QuizHistoryItem(
      resultId: json["resultId"],
      attemptId: json["attemptId"],
      attemptNumber: json["attemptNumber"],
      status: json["status"],
      score: json["score"],
      isPassed: json["isPassed"],
      startedAt: json["startedAt"],
      completedAt: json["completedAt"],
      timeSpentMinutes: json["timeSpentMinutes"],
    );
  }

  Map<String, dynamic> toJson() => {
    "resultId": resultId,
    "attemptId": attemptId,
    "attemptNumber": attemptNumber,
    "status": status,
    "score": score,
    "isPassed": isPassed,
    "startedAt": startedAt,
    "completedAt": completedAt,
    "timeSpentMinutes": timeSpentMinutes,
  };
}
