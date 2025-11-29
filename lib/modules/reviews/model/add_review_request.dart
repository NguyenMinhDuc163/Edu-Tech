class AddReviewRequest {
  AddReviewRequest({
    required this.rating,
    required this.title,
    required this.content,
  });

  final num rating;
  final String title;
  final String content;

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "title": title,
    "content": content,
  };
}

class AddReviewResponse {
  AddReviewResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
  final String? message;
  final AddReviewData? data;

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) {
    return AddReviewResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : AddReviewData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class AddReviewData {
  AddReviewData({
    required this.courseId,
    required this.userId,
    required this.rating,
    required this.title,
    required this.content,
    required this.reviewId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? courseId;
  final String? userId;
  final num? rating;
  final String? title;
  final String? content;
  final String? reviewId;
  final String? createdAt;
  final String? updatedAt;

  factory AddReviewData.fromJson(Map<String, dynamic> json) {
    return AddReviewData(
      courseId: json["course_id"],
      userId: json["user_id"],
      rating: json["rating"],
      title: json["title"],
      content: json["content"],
      reviewId: json["review_id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "course_id": courseId,
    "user_id": userId,
    "rating": rating,
    "title": title,
    "content": content,
    "review_id": reviewId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
