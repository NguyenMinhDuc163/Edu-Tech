class ReviewResponse {
  ReviewResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  final num? status;
  final String? message;
  final ReviewData? data;

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : ReviewData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class ReviewData {
  ReviewData({
    required this.reviews,
    required this.pagination,
  });

  final List<Review> reviews;
  final Pagination? pagination;

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviews: json["reviews"] == null
          ? []
          : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : Pagination.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "reviews": reviews.map((x) => x.toJson()).toList(),
    "pagination": pagination?.toJson(),
  };
}

class Review {
  Review({
    required this.reviewId,
    required this.rating,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.comments,
  });

  final String? reviewId;
  final num? rating;
  final String? title;
  final String? content;
  final String? createdAt;
  final String? updatedAt;
  final ReviewUser? user;
  final List<ReviewComment> comments;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json["review_id"],
      rating: json["rating"],
      title: json["title"],
      content: json["content"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      user: json["user"] == null ? null : ReviewUser.fromJson(json["user"]),
      comments: json["comments"] == null
          ? []
          : List<ReviewComment>.from(
              json["comments"]!.map((x) => ReviewComment.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "review_id": reviewId,
    "rating": rating,
    "title": title,
    "content": content,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user?.toJson(),
    "comments": comments.map((x) => x.toJson()).toList(),
  };
}

class ReviewUser {
  ReviewUser({
    required this.id,
    required this.username,
  });

  final String? id;
  final String? username;

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json["id"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}

class ReviewComment {
  ReviewComment({
    required this.commentId,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  final String? commentId;
  final String? content;
  final String? createdAt;
  final ReviewUser? user;

  factory ReviewComment.fromJson(Map<String, dynamic> json) {
    return ReviewComment(
      commentId: json["comment_id"],
      content: json["content"],
      createdAt: json["created_at"],
      user: json["user"] == null ? null : ReviewUser.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "comment_id": commentId,
    "content": content,
    "created_at": createdAt,
    "user": user?.toJson(),
  };
}

class Pagination {
  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final num? page;
  final num? limit;
  final num? total;
  final num? totalPages;

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPages: json["totalPages"],
    );
  }

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPages": totalPages,
  };
}
