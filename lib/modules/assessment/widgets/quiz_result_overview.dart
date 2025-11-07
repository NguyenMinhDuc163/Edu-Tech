import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/quiz_result_model.dart';

class QuizResultOverview extends StatelessWidget {
  final QuizResultModel result;
  final VoidCallback? onViewDetails;

  const QuizResultOverview({
    super.key,
    required this.result,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.a16,
      padding: AppPad.a20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack15,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          
          Row(
            children: [
              Icon(Icons.star, color: AppColors.orange, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.performanceMessage,
                  style: AppTextStyles.textHeader3.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          
          Row(
            children: [
              
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGray.withOpacity(0.3),
                      ),
                    ),
                    
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: result.percentage / 100,
                        strokeWidth: 8,
                        backgroundColor: AppColors.lightGray.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getScoreColor(result.percentage),
                        ),
                      ),
                    ),
                    
                    Text(
                      result.percentageText,
                      style: AppTextStyles.textHeader1.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(result.percentage),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    _buildScoreItem(
                      label: 'assessment.multiple_choice_score'.tr(),
                      score: '${result.multipleChoiceScore}',
                      backgroundColor: AppColors.lavenderColor.withOpacity(0.1),
                      textColor: AppColors.lavenderColor,
                    ),

                    const SizedBox(height: 12),

                    
                    _buildScoreItem(
                      label: 'assessment.essay_score'.tr(),
                      score: '${result.essayScore}',
                      backgroundColor: AppColors.lavenderColor.withOpacity(0.1),
                      textColor: AppColors.lavenderColor,
                    ),

                    const SizedBox(height: 12),

                    
                    _buildScoreItem(
                      label: 'assessment.total_score'.tr(),
                      score: '${result.totalScore} / ${result.maxScore}',
                      backgroundColor: AppColors.success.withOpacity(0.1),
                      textColor: AppColors.success,
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          
          SizedBox(
            width: double.infinity,
            height: 48,
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
                    size: 20,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'assessment.view_detailed_answers'.tr(),
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

  Widget _buildScoreItem({
    required String label,
    required String score,
    required Color backgroundColor,
    required Color textColor,
    bool isTotal = false,
  }) {
    return Container(
      padding: AppPad.h12v8,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.textContent3.copyWith(
              color: AppColors.color8F959E,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            score,
            style: AppTextStyles.textContent2.copyWith(
              color: textColor,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 90) {
      return AppColors.success;
    } else if (percentage >= 70) {
      return AppColors.primary;
    } else if (percentage >= 50) {
      return AppColors.orange;
    } else {
      return AppColors.error;
    }
  }
}
