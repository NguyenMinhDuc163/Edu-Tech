class CourseStatsResponse {
  final int status;
  final String message;
  final CourseStatsData data;

  CourseStatsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CourseStatsResponse.fromJson(Map<String, dynamic> json) {
    return CourseStatsResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: CourseStatsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class CourseStatsData {
  final StatsOverview overview;
  final List<CourseStats> courses;
  final List<RecentResult> recentResults;

  CourseStatsData({
    required this.overview,
    required this.courses,
    required this.recentResults,
  });

  factory CourseStatsData.fromJson(Map<String, dynamic> json) {
    return CourseStatsData(
      overview: StatsOverview.fromJson(json['overview'] ?? {}),
      courses: (json['courses'] as List<dynamic>?)
              ?.map((e) => CourseStats.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentResults: (json['recent_results'] as List<dynamic>?)
              ?.map((e) => RecentResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'overview': overview.toJson(),
        'courses': courses.map((e) => e.toJson()).toList(),
        'recent_results': recentResults.map((e) => e.toJson()).toList(),
      };
}

class StatsOverview {
  final int totalResults;
  final double averageScore;
  final int totalPassed;

  StatsOverview({
    required this.totalResults,
    required this.averageScore,
    required this.totalPassed,
  });

  factory StatsOverview.fromJson(Map<String, dynamic> json) {
    return StatsOverview(
      totalResults: json['total_results'] ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
      totalPassed: json['total_passed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_results': totalResults,
        'average_score': averageScore,
        'total_passed': totalPassed,
      };
}

class CourseStats {
  final String courseId;
  final String title;
  final int totalQuizzes;
  final double avgScore;
  final int passRate;

  CourseStats({
    required this.courseId,
    required this.title,
    required this.totalQuizzes,
    required this.avgScore,
    required this.passRate,
  });

  factory CourseStats.fromJson(Map<String, dynamic> json) {
    return CourseStats(
      courseId: json['course_id']?.toString() ?? '',
      title: json['title'] ?? '',
      totalQuizzes: json['total_quizzes'] ?? 0,
      avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0.0,
      passRate: json['pass_rate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'course_id': courseId,
        'title': title,
        'total_quizzes': totalQuizzes,
        'avg_score': avgScore,
        'pass_rate': passRate,
      };
}

class RecentResult {
  final String resultId;
  final String quizTitle;
  final double score;
  final bool isPassed;
  final DateTime completedAt;

  RecentResult({
    required this.resultId,
    required this.quizTitle,
    required this.score,
    required this.isPassed,
    required this.completedAt,
  });

  factory RecentResult.fromJson(Map<String, dynamic> json) {
    double parseScore(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return RecentResult(
      resultId: json['result_id']?.toString() ?? '',
      quizTitle: json['quiz_title'] ?? '',
      score: parseScore(json['score']),
      isPassed: json['is_passed'] ?? false,
      completedAt: DateTime.tryParse(json['completed_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'result_id': resultId,
        'quiz_title': quizTitle,
        'score': score,
        'is_passed': isPassed,
        'completed_at': completedAt.toIso8601String(),
      };
}
