class ListQuizModel {
  ListQuizModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
  final String? message;
  final Data? data;

  factory ListQuizModel.fromJson(Map<String, dynamic> json){
    return ListQuizModel(
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
  String toString(){
    return "$status, $message, $data, ";
  }
}

class Data {
  Data({
    required this.code,
    required this.message,
    required this.data,
    required this.error,
  });

  final num? code;
  final String? message;
  final List<Datum> data;
  final dynamic error;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
    "error": error,
  };

  @override
  String toString(){
    return "$code, $message, $data, $error, ";
  }
}

class Datum {
  Datum({
    required this.quizId,
    required this.quizTitle,
    required this.quizDescription,
    required this.quizType,
    required this.passingScore,
    required this.maxAttempts,
    required this.startTime,
    required this.endTime,
    required this.isRequired,
    required this.courseInfo,
  });

  final String? quizId;
  final String? quizTitle;
  final String? quizDescription;
  final String? quizType;
  final String? passingScore;
  final num? maxAttempts;
  final dynamic startTime;
  final dynamic endTime;
  final bool? isRequired;
  final CourseInfo? courseInfo;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      quizId: json["quizId"],
      quizTitle: json["quizTitle"],
      quizDescription: json["quizDescription"],
      quizType: json["quizType"],
      passingScore: json["passingScore"],
      maxAttempts: json["maxAttempts"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      isRequired: json["isRequired"],
      courseInfo: json["courseInfo"] == null ? null : CourseInfo.fromJson(json["courseInfo"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "quizId": quizId,
    "quizTitle": quizTitle,
    "quizDescription": quizDescription,
    "quizType": quizType,
    "passingScore": passingScore,
    "maxAttempts": maxAttempts,
    "startTime": startTime,
    "endTime": endTime,
    "isRequired": isRequired,
    "courseInfo": courseInfo?.toJson(),
  };

  @override
  String toString(){
    return "$quizId, $quizTitle, $quizDescription, $quizType, $passingScore, $maxAttempts, $startTime, $endTime, $isRequired, $courseInfo, ";
  }
}

class CourseInfo {
  CourseInfo({
    required this.courseId,
    required this.courseTitle,
    required this.sectionId,
    required this.sectionTitle,
    required this.lessonId,
    required this.lessonTitle,
  });

  final String? courseId;
  final String? courseTitle;
  final String? sectionId;
  final String? sectionTitle;
  final String? lessonId;
  final String? lessonTitle;

  factory CourseInfo.fromJson(Map<String, dynamic> json){
    return CourseInfo(
      courseId: json["courseId"],
      courseTitle: json["courseTitle"],
      sectionId: json["sectionId"],
      sectionTitle: json["sectionTitle"],
      lessonId: json["lessonId"],
      lessonTitle: json["lessonTitle"],
    );
  }

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "courseTitle": courseTitle,
    "sectionId": sectionId,
    "sectionTitle": sectionTitle,
    "lessonId": lessonId,
    "lessonTitle": lessonTitle,
  };

  @override
  String toString(){
    return "$courseId, $courseTitle, $sectionId, $sectionTitle, $lessonId, $lessonTitle, ";
  }
}
