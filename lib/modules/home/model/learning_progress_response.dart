class LearningProgressResponse {
  final int status;
  final String message;
  final LearningProgressData data;

  LearningProgressResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LearningProgressResponse.fromJson(Map<String, dynamic> json) {
    return LearningProgressResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: LearningProgressData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class LearningProgressData {
  final int totalCourses;
  final int completedCourses;
  final int inProgressCourses;
  final int notStartedCourses;
  final int totalLessons;
  final int completedLessons;
  final int overallProgress;
  final int averageProgressPerCourse;
  final List<CourseProgress> courses;

  LearningProgressData({
    required this.totalCourses,
    required this.completedCourses,
    required this.inProgressCourses,
    required this.notStartedCourses,
    required this.totalLessons,
    required this.completedLessons,
    required this.overallProgress,
    required this.averageProgressPerCourse,
    required this.courses,
  });

  factory LearningProgressData.fromJson(Map<String, dynamic> json) {
    return LearningProgressData(
      totalCourses: json['totalCourses'] ?? 0,
      completedCourses: json['completedCourses'] ?? 0,
      inProgressCourses: json['inProgressCourses'] ?? 0,
      notStartedCourses: json['notStartedCourses'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      overallProgress: json['overallProgress'] ?? 0,
      averageProgressPerCourse: json['averageProgressPerCourse'] ?? 0,
      courses: (json['courses'] as List<dynamic>?)
              ?.map((e) => CourseProgress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'totalCourses': totalCourses,
        'completedCourses': completedCourses,
        'inProgressCourses': inProgressCourses,
        'notStartedCourses': notStartedCourses,
        'totalLessons': totalLessons,
        'completedLessons': completedLessons,
        'overallProgress': overallProgress,
        'averageProgressPerCourse': averageProgressPerCourse,
        'courses': courses.map((e) => e.toJson()).toList(),
      };
}

class CourseProgress {
  final String courseId;
  final String courseName;
  final int progress;
  final int completedLessons;
  final int totalLessons;

  CourseProgress({
    required this.courseId,
    required this.courseName,
    required this.progress,
    required this.completedLessons,
    required this.totalLessons,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['courseId']?.toString() ?? '',
      courseName: json['courseName'] ?? '',
      progress: json['progress'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'courseName': courseName,
        'progress': progress,
        'completedLessons': completedLessons,
        'totalLessons': totalLessons,
      };
}
