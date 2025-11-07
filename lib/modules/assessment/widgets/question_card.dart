import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/question_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int questionNumber;
  final int totalQuestions;
  final String? selectedAnswerId;
  final Function(String answerId)? onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    this.selectedAnswerId,
    this.onAnswerSelected,
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
          
          Row(
            children: [
              Container(
                padding: AppPad.h12v8,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${'assessment.question'.tr()} $questionNumber/$totalQuestions',
                  style: AppTextStyles.textContent3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              
              if (question.timeLimit > 0)
                Container(
                  padding: AppPad.h8v4,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppColors.error),
                      const SizedBox(width: 4),
                      Text(
                        '${question.timeLimit}s',
                        style: AppTextStyles.textContent4.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          
          Text(
            question.questionText,
            style: AppTextStyles.textContent1.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          
          ...question.answers.asMap().entries.map((entry) {
            final index = entry.key;
            final answer = entry.value;
            final isSelected = selectedAnswerId == answer.id;

            return Padding(
              padding: AppPad.b10,
              child: _buildAnswerOption(
                answer: answer,
                optionLetter: String.fromCharCode(65 + index), 
                isSelected: isSelected,
                onTap: () => onAnswerSelected?.call(answer.id),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAnswerOption({
    required AnswerModel answer,
    required String optionLetter,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPad.a16,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.lightGray.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.colorDEDEDE,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.color8F959E,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  optionLetter,
                  style: AppTextStyles.textContent3.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            
            Expanded(
              child: Text(
                answer.text,
                style: AppTextStyles.textContent2.copyWith(
                  color: AppColors.text,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),

            
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 16, color: AppColors.white),
              ),
          ],
        ),
      ),
    );
  }
}
