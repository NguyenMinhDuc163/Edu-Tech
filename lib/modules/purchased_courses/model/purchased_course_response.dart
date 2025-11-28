class PurchasedCourseResponse {
  PurchasedCourseResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final int? status;
  final String? message;
  final List<PurchasedCourse> data;

  factory PurchasedCourseResponse.fromJson(Map<String, dynamic> json) {
    return PurchasedCourseResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<PurchasedCourse>.from(
              json["data"]!.map((x) => PurchasedCourse.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class PurchasedCourse {
  PurchasedCourse({
    required this.registrationId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.courseDuration,
    required this.teacher,
    required this.courseDescription,
    required this.thumbnailUrl,
    required this.progress,
    required this.purchaseDate,
    required this.amountPaid,
  });

  final String? registrationId;
  final String? courseId;
  final String? title;
  final String? description;
  final String? price;
  final String? currency;
  final String? category;
  final String? courseDuration;
  final String? teacher;
  final String? courseDescription;
  final String? thumbnailUrl;
  final String? progress;
  final DateTime? purchaseDate;
  final String? amountPaid;

  factory PurchasedCourse.fromJson(Map<String, dynamic> json) {
    return PurchasedCourse(
      registrationId: json["registrationId"],
      courseId: json["courseId"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      currency: json["currency"],
      category: json["category"],
      courseDuration: json["courseDuration"],
      teacher: json["teacher"],
      courseDescription: json["courseDescription"],
      thumbnailUrl: json["thumbnailUrl"],
      progress: json["progress"],
      purchaseDate: DateTime.tryParse(json["purchaseDate"] ?? ""),
      amountPaid: json["amountPaid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "registrationId": registrationId,
        "courseId": courseId,
        "title": title,
        "description": description,
        "price": price,
        "currency": currency,
        "category": category,
        "courseDuration": courseDuration,
        "teacher": teacher,
        "courseDescription": courseDescription,
        "thumbnailUrl": thumbnailUrl,
        "progress": progress,
        "purchaseDate": purchaseDate?.toIso8601String(),
        "amountPaid": amountPaid,
      };

  double get progressPercentage {
    if (progress == null) return 0.0;
    return double.tryParse(progress!) ?? 0.0;
  }
}
