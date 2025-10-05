import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/quiz_model.dart';

class QuizCardWidget extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback? onTap;

  const QuizCardWidget({super.key, required this.quiz, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: AppPad.b10,
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
            
            Row(
              children: [
                
                if (!quiz.hasTimeLimit)
                  Container(
                    padding: AppPad.h6v2,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.push_pin_outlined,
                          size: 12,
                          color: AppColors.color8F959E,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          quiz.timeLimitText,
                          style: AppTextStyles.textContent4.copyWith(
                            color: AppColors.color8F959E,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                
                Container(
                  padding: AppPad.h6v2,
                  decoration: BoxDecoration(
                    color: AppColors.colorF4F3FD,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    quiz.type,
                    style: AppTextStyles.textContent4.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                if (quiz.isCompleted) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getScoreColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getScoreColor(), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        quiz.scoreText,
                        style: AppTextStyles.textStyleDefaultBold.copyWith(
                          color: _getScoreColor(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        quiz.title,
                        style: AppTextStyles.textStyleDefaultBold.copyWith(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      
                      Text(
                        quiz.statusText,
                        style: AppTextStyles.textContent3.copyWith(
                          color:
                              quiz.isCompleted
                                  ? AppColors.color8F959E
                                  : AppColors.error,
                        ),
                      ),

                      const SizedBox(height: 8),

                      
                      Row(
                        children: [
                          
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.color8F959E,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            quiz.timeLimitText,
                            style: AppTextStyles.textContent4.copyWith(
                              color: AppColors.color8F959E,
                            ),
                          ),

                          const SizedBox(width: 16),

                          
                          Icon(
                            Icons.help_outline,
                            size: 14,
                            color: AppColors.color8F959E,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            quiz.questionCountText,
                            style: AppTextStyles.textContent4.copyWith(
                              color: AppColors.color8F959E,
                            ),
                          ),

                          const SizedBox(width: 16),

                          
                          if (quiz.isCompleted) ...[
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: AppColors.color8F959E,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              quiz.attemptsText,
                              style: AppTextStyles.textContent4.copyWith(
                                color: AppColors.color8F959E,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor() {
    if (quiz.score == null) return AppColors.gray;

    final score = quiz.score!;
    if (score >= 8) {
      return AppColors.success;
    } else if (score >= 5) {
      return AppColors.orange;
    } else {
      return AppColors.error;
    }
  }
}
