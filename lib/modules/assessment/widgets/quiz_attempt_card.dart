import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/quiz_attempt_model.dart';

class QuizAttemptCard extends StatelessWidget {
  final QuizAttemptModel attempt;
  final VoidCallback? onViewDetails;

  const QuizAttemptCard({super.key, required this.attempt, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.b20,
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack15,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Score Row
          Row(
            children: [
              Text(
                'Điểm tổng',
                style: AppTextStyles.textContent2.copyWith(
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                attempt.totalScore.toString(),
                style: AppTextStyles.textHeader2.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(),
                ),
              ),
              const Spacer(),
              // Date time in top right
              Text(
                attempt.fullDateTime,
                style: AppTextStyles.textContent4.copyWith(
                  color: AppColors.color8F959E,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Attempt Details
          Row(
            children: [
              // Time taken
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.access_time,
                  iconColor: AppColors.color8F959E,
                  label: 'Thời gian làm bài',
                  value: attempt.timeTakenText,
                ),
              ),

              const SizedBox(width: 16),

              // Correct answers
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.check_circle,
                  iconColor: AppColors.success,
                  label: 'Số câu đúng',
                  value: attempt.correctAnswersText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // View details button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Xem chi tiết bài làm',
                    style: AppTextStyles.textContent2.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.textContent4.copyWith(
                  color: AppColors.color8F959E,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.textContent3.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getScoreColor() {
    if (attempt.totalScore >= 8) {
      return AppColors.success;
    } else if (attempt.totalScore >= 5) {
      return AppColors.orange;
    } else {
      return AppColors.error;
    }
  }
}
