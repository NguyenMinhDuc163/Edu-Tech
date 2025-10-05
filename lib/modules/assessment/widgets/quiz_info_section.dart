import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/quiz_model.dart';

class QuizInfoSection extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback? onStartQuiz;

  const QuizInfoSection({super.key, required this.quiz, this.onStartQuiz});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header with title and icon
          Row(
            children: [
              Expanded(
                child: Text(
                  quiz.title,
                  style: AppTextStyles.textHeader3.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: AppPad.a8,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.qr_code_scanner_outlined,
                  size: 20,
                  color: AppColors.color8F959E,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quiz parameters
          _buildParameterItem(
            icon: Icons.access_time,
            iconColor: AppColors.error,
            label: 'Thời gian làm bài',
            value: '${quiz.timeLimit} phút',
          ),

          const SizedBox(height: 12),

          _buildParameterItem(
            icon: Icons.calendar_today,
            iconColor: AppColors.success,
            label: 'Thời gian vào thi',
            value: 'Không thời hạn',
          ),

          const SizedBox(height: 12),

          _buildParameterItem(
            icon: Icons.quiz_outlined,
            iconColor: AppColors.primary,
            label: 'Loại đề',
            value: 'Hỗn hợp',
          ),

          const SizedBox(height: 12),

          _buildParameterItem(
            icon: Icons.help_outline,
            iconColor: AppColors.color8F959E,
            label: 'Số lượng câu hỏi',
            value: '${quiz.questionCount} câu',
          ),

          const SizedBox(height: 20),

          // Start test button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onStartQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, size: 20, color: AppColors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Bắt đầu thi',
                    style: AppTextStyles.textStyleDefaultBold.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
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

  Widget _buildParameterItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: AppPad.a6,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: AppTextStyles.textContent2.copyWith(color: AppColors.text),
          ),
        ),
      ],
    );
  }
}
