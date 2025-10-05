import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/quiz_result_model.dart';

class QuizStatisticsTable extends StatelessWidget {
  final QuizResultModel result;

  const QuizStatisticsTable({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.h16,
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
            'Bảng thống kê',
            style: AppTextStyles.textHeader3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 20),

          
          _buildQuestionTypeSection(
            title: 'Trắc nghiệm một đáp án (${result.totalMultipleChoice} Câu)',
            correctCount: result.correctMultipleChoice,
            totalCount: result.totalMultipleChoice,
            score: result.multipleChoiceScore,
            maxScore:
                result.totalMultipleChoice *
                2.5, 
          ),

          const SizedBox(height: 16),

          
          if (result.totalEssay > 0) ...[
            _buildQuestionTypeSection(
              title: 'Tự luận (${result.totalEssay} Câu)',
              correctCount: result.correctEssay,
              totalCount: result.totalEssay,
              score: result.essayScore,
              maxScore: result.totalEssay * 2.5,
              isEssay: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionTypeSection({
    required String title,
    required int correctCount,
    required int totalCount,
    required double score,
    required double maxScore,
    bool isEssay = false,
  }) {
    return Container(
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            title,
            style: AppTextStyles.textContent2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 12),

          
          Row(
            children: [
              
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    if (!isEssay) ...[
                      _buildStatItem(
                        label: 'Số câu đúng:',
                        value: '$correctCount/$totalCount',
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 4),
                      _buildStatItem(
                        label: 'Số câu sai:',
                        value: '${totalCount - correctCount}/$totalCount',
                        color: AppColors.primary,
                      ),
                    ] else ...[
                      
                      ...List.generate(totalCount, (index) {
                        final questionResult = result.essayQuestions[index];
                        return Padding(
                          padding: AppPad.b8,
                          child: Text(
                            'Câu ${questionResult.questionNumber}: ${questionResult.score} điểm',
                            style: AppTextStyles.textContent3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              
              Expanded(
                flex: 1,
                child: Container(
                  padding: AppPad.h12v8,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Điểm',
                        style: AppTextStyles.textContent4.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$score / $maxScore',
                        style: AppTextStyles.textContent3.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.textContent3.copyWith(
            color: AppColors.color8F959E,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.textContent3.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
