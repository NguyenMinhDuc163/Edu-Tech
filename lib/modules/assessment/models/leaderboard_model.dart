class LeaderboardModel {
  final int status;
  final String message;
  final LeaderboardData data;

  LeaderboardModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: LeaderboardData.fromJson(json['data'] ?? {}),
    );
  }
}

class LeaderboardData {
  final Pagination pagination;
  final List<LeaderboardItem> data;

  LeaderboardData({
    required this.pagination,
    required this.data,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) {
    return LeaderboardData(
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => LeaderboardItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class LeaderboardItem {
  final int rank;
  final String studentId;
  final String username;
  final String email;
  final double totalScore;
  final String avgScore;
  final int completedQuizzes;

  LeaderboardItem({
    required this.rank,
    required this.studentId,
    required this.username,
    required this.email,
    required this.totalScore,
    required this.avgScore,
    required this.completedQuizzes,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      rank: json['rank'] ?? 0,
      studentId: json['student_id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      totalScore: (json['total_score'] ?? 0).toDouble(),
      avgScore: json['avg_score']?.toString() ?? '0',
      completedQuizzes: json['completed_quizzes'] ?? 0,
    );
  }
}
