class SearchCourseResult {
  SearchCourseResult({
    required this.courseId,
    required this.title,
    required this.price,
    required this.description,
    required this.thumbnailUrl,
  });

  final String? courseId;
  final String? title;
  final String? price;
  final String? description;
  final String? thumbnailUrl;

  factory SearchCourseResult.fromJson(Map<String, dynamic> json) {
    return SearchCourseResult(
      courseId: json["courseId"],
      title: json["title"],
      price: json["price"],
      description: json["description"],
      thumbnailUrl: json["thumbnailUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "title": title,
        "price": price,
        "description": description,
        "thumbnail_url": thumbnailUrl,
      };
}
