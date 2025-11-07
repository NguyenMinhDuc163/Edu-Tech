import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/quiz_result_model.dart';

class QuizDetailedAnswers extends StatelessWidget {
  final QuizResultModel result;
  final Function(QuestionResultModel)? onQuestionTap;

  const QuizDetailedAnswers({
    super.key,
    required this.result,
    this.onQuestionTap,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            '${'assessment.detailed_answers'.tr()} (${result.totalQuestions} ${'assessment.question_count_value'.tr()})',
            style: AppTextStyles.textHeader3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 20),

          
          if (result.multipleChoiceQuestions.isNotEmpty) ...[
            _buildSectionTitle('assessment.section_1'.tr()),
            const SizedBox(height: 12),
            ...result.multipleChoiceQuestions.map(
              (question) => _buildQuestionItem(question),
            ),
            const SizedBox(height: 16),
          ],

          
          if (result.essayQuestions.isNotEmpty) ...[
            _buildSectionTitle('assessment.section_2'.tr()),
            const SizedBox(height: 12),
            ...result.essayQuestions.map(
              (question) => _buildQuestionItem(question),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: AppPad.h12v8,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: AppTextStyles.textContent2.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildQuestionItem(QuestionResultModel question) {
    return Container(
      margin: AppPad.b10,
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.colorDEDEDE, width: 1),
      ),
      child: Row(
        children: [
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.questionHeader,
                  style: AppTextStyles.textContent2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                if (question.explanation != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    question.explanation!,
                    style: AppTextStyles.textContent3.copyWith(
                      color: AppColors.color8F959E,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 16),

          
          Container(
            padding: AppPad.h12v8,
            decoration: BoxDecoration(
              color: question.isCorrect ? AppColors.success : AppColors.error,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              question.isCorrect ? 'assessment.correct'.tr() : 'assessment.wrong'.tr(),
              style: AppTextStyles.textContent3.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          
          GestureDetector(
            onTap: () => onQuestionTap?.call(question),
            child: Container(
              padding: AppPad.a8,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
