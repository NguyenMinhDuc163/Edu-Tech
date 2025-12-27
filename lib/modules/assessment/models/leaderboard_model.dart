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
  final String scope;
  final String? courseId;
  final List<LeaderboardItem> leaderboard;

  LeaderboardData({
    required this.scope,
    this.courseId,
    required this.leaderboard,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) {
    return LeaderboardData(
      scope: json['scope'] ?? 'global',
      courseId: json['courseId'],
      leaderboard: (json['leaderboard'] as List<dynamic>?)
              ?.map((item) => LeaderboardItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class LeaderboardItem {
  final int rank;
  final String studentId;
  final String studentName;
  final String? avatarUrl;
  final num averageScore;
  final int totalQuizzes;
  final int quizzesPassed;
  final num passRate;

  LeaderboardItem({
    required this.rank,
    required this.studentId,
    required this.studentName,
    this.avatarUrl,
    required this.averageScore,
    required this.totalQuizzes,
    required this.quizzesPassed,
    required this.passRate,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      rank: json['rank'] ?? 0,
      studentId: json['studentId']?.toString() ?? '',
      studentName: json['studentName'] ?? '',
      avatarUrl: json['avatarUrl'],
      averageScore: json['averageScore'] ?? 0,
      totalQuizzes: json['totalQuizzes'] ?? 0,
      quizzesPassed: json['quizzesPassed'] ?? 0,
      passRate: json['passRate'] ?? 0,
    );
  }

  String get username => studentName;
  double get totalScore => averageScore.toDouble();
  int get completedQuizzes => totalQuizzes;
  String get avgScore => averageScore.toStringAsFixed(1);
}
