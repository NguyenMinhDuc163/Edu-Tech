import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/assessment/models/quiz_history_model.dart';

class QuizHistorySection extends StatelessWidget {
  final List<QuizHistoryItem> history;

  const QuizHistorySection({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
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
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: AppColors.coolGray),
              const SizedBox(height: 8),
              Text('assessment.no_history'.tr(), style: AppTextStyles.textContent2.copyWith(color: AppColors.coolGray)),
            ],
          ),
        ),
      );
    }

    return Container(
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
          Padding(
            padding: AppPad.a16,
            child: Row(
              children: [
                Icon(Icons.history, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text('assessment.history_title'.tr(), style: AppTextStyles.textHeader3),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: AppPad.a16,
            itemCount: history.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildHistoryItem(history[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(QuizHistoryItem item) {
    final score = double.tryParse(item.score ?? '0') ?? 0;
    final isPassed = item.isPassed ?? false;

    return Container(
      padding: AppPad.a12,
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPassed ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isPassed ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#${item.attemptNumber}',
                style: AppTextStyles.textHeader3.copyWith(
                  color: isPassed ? AppColors.success : AppColors.error,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(item.startedAt),
                        style: AppTextStyles.textContent2.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPassed ? AppColors.success : AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isPassed ? 'assessment.passed'.tr() : 'assessment.not_passed'.tr(),
                        style: AppTextStyles.textContent3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: AppColors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${'assessment.score_label_colon'.tr()}${score.toStringAsFixed(1)}',
                      style: AppTextStyles.textContent3.copyWith(color: AppColors.coolGray),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: AppColors.coolGray),
                    const SizedBox(width: 4),
                    Text(
                      '${item.timeSpentMinutes} ${'assessment.time_spent'.tr()}',
                      style: AppTextStyles.textContent3.copyWith(color: AppColors.coolGray),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
