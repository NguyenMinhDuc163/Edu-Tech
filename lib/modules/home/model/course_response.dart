class CourseResponse {
  CourseResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int? status;
  final String? message;
  final Data? data;

  factory CourseResponse.fromJson(Map<String, dynamic> json){
    return CourseResponse(
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

  final int? code;
  final String? message;
  final List<DataCourse> data;
  final dynamic error;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      code: json["code"],
      message: json["message"],
      data: json["data"] == null ? [] : List<DataCourse>.from(json["data"]!.map((x) => DataCourse.fromJson(x))),
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

class DataCourse {
  DataCourse({
    required this.courseId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.categoryId,
    required this.status,
    required this.visibility,
    required this.courseDuration,
    required this.teacher,
    required this.discountAmount,
    required this.courseDescription,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.isRegistered,
    required this.progress,
  });

  final String? courseId;
  final String? title;
  final String? description;
  final String? price;
  final String? currency;
  final dynamic category;
  final String? categoryId;
  final String? status;
  final String? visibility;
  final dynamic courseDuration;
  final dynamic teacher;
  final String? discountAmount;
  final dynamic courseDescription;
  final dynamic thumbnailUrl;
  final DateTime? createdAt;
  final bool? isRegistered;
  final int? progress;

  factory DataCourse.fromJson(Map<String, dynamic> json){
    return DataCourse(
      courseId: json["courseId"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      currency: json["currency"],
      category: json["category"],
      categoryId: json["categoryId"],
      status: json["status"],
      visibility: json["visibility"],
      courseDuration: json["courseDuration"],
      teacher: json["teacher"],
      discountAmount: json["discountAmount"],
      courseDescription: json["courseDescription"],
      thumbnailUrl: json["thumbnailUrl"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      isRegistered: json["isRegistered"],
      progress: json["progress"],
    );
  }

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "title": title,
    "description": description,
    "price": price,
    "currency": currency,
    "category": category,
    "categoryId": categoryId,
    "status": status,
    "visibility": visibility,
    "courseDuration": courseDuration,
    "teacher": teacher,
    "discountAmount": discountAmount,
    "courseDescription": courseDescription,
    "thumbnailUrl": thumbnailUrl,
    "createdAt": createdAt?.toIso8601String(),
    "isRegistered": isRegistered,
    "progress": progress,
  };

  @override
  String toString(){
    return "$courseId, $title, $description, $price, $currency, $category, $categoryId, $status, $visibility, $courseDuration, $teacher, $discountAmount, $courseDescription, $thumbnailUrl, $createdAt, $isRegistered, $progress, ";
  }
}
