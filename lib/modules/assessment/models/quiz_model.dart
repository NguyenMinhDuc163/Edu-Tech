class QuizModel {
  final String id;
  final String title;
  final String type;
  final int timeLimit;
  final int questionCount;
  final QuizStatus status;
  final int? score;
  final int attempts;
  final DateTime? completedAt;
  final String subject;

  const QuizModel({
    required this.id,
    required this.title,
    required this.type,
    required this.timeLimit,
    required this.questionCount,
    required this.status,
    this.score,
    this.attempts = 0,
    this.completedAt,
    required this.subject,
  });

  bool get isCompleted => status == QuizStatus.completed;
  bool get hasTimeLimit => timeLimit > 0;
  String get timeLimitText =>
      hasTimeLimit ? '${timeLimit} Phút' : 'Không thời hạn';
  String get questionCountText => '$questionCount câu';
  String get attemptsText => '$attempts lượt làm đề';
  String get scoreText => score?.toString() ?? '';
  String get statusText {
    switch (status) {
      case QuizStatus.notTaken:
        return 'Trạng thái: chưa thi';
      case QuizStatus.inProgress:
        return 'Trạng thái: đang thi';
      case QuizStatus.completed:
        return 'Đã thi: ${_getTimeAgo()}';
    }
  }

  String _getTimeAgo() {
    if (completedAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(completedAt!);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  }

  // Factory method để chuyển đổi từ Datum (API response) sang QuizModel
  static QuizModel fromDatum(dynamic datum) {
    return QuizModel(
      id: datum.quizId ?? '',
      title: datum.quizTitle ?? '',
      type: datum.quizType ?? 'ASSIGNMENT',
      timeLimit: 0,
      questionCount: 0,
      status: QuizStatus.notTaken,
      attempts: (datum.maxAttempts ?? 0).toInt(),
      subject: datum.courseInfo?.courseTitle ?? '',
    );
  }
}

enum QuizStatus { notTaken, inProgress, completed }
