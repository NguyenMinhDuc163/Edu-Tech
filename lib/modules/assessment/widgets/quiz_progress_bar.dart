import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';

class QuizProgressBar extends StatelessWidget {
  final double progress; 
  final int currentQuestion;
  final int totalQuestions;
  final Duration remainingTime;
  final bool showTimer;

  const QuizProgressBar({
    super.key,
    required this.progress,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.remainingTime,
    this.showTimer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack15,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          
          Row(
            children: [
              
              Text(
                'Tiến độ: $currentQuestion/$totalQuestions',
                style: AppTextStyles.textContent3.copyWith(
                  color: AppColors.color8F959E,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              
              if (showTimer)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getTimerColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: _getTimerColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(remainingTime),
                        style: AppTextStyles.textContent4.copyWith(
                          color: _getTimerColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimerColor() {
    final minutes = remainingTime.inMinutes;
    if (minutes <= 5) {
      return AppColors.error;
    } else if (minutes <= 10) {
      return AppColors.orange;
    } else {
      return AppColors.primary;
    }
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
