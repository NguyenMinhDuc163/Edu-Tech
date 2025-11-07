import 'package:easy_localization/easy_localization.dart';

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
      hasTimeLimit ? '${timeLimit} ${'assessment.time_limit_value'.tr()}' : 'assessment.no_deadline'.tr();
  String get questionCountText => '$questionCount ${'assessment.question_count_value'.tr()}';
  String get attemptsText => '$attempts ${'assessment.attempts'.tr()}';
  String get scoreText => score?.toString() ?? '';
  String get statusText {
    switch (status) {
      case QuizStatus.notTaken:
        return 'assessment.status_not_taken'.tr();
      case QuizStatus.inProgress:
        return 'assessment.status_in_progress'.tr();
      case QuizStatus.completed:
        return '${'assessment.status_completed'.tr()} ${_getTimeAgo()}';
    }
  }

  String _getTimeAgo() {
    if (completedAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(completedAt!);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${'assessment.minutes_ago'.tr()}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${'assessment.hours_ago'.tr()}';
    } else {
      return '${difference.inDays} ${'assessment.days_ago'.tr()}';
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
