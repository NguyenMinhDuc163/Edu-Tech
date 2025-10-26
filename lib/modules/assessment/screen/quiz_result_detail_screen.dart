import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import '../models/quiz_result_model.dart';
import 'package:flutter/material.dart';

class QuizResultDetailScreen extends StatefulWidget {
  const QuizResultDetailScreen({super.key});

  static const String routeName = '/quiz-result-detail';

  @override
  State<QuizResultDetailScreen> createState() => _QuizResultDetailScreenState();
}

class _QuizResultDetailScreenState extends State<QuizResultDetailScreen> {
  late QuizResultModel result;
  int currentQuestionIndex = 0;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted || _isInitialized) return;

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args['result'] != null) {
      result = args['result'] as QuizResultModel;
    }
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Chi tiết bài làm', style: AppTextStyles.appbarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),

          Expanded(
            child: PageView.builder(
              controller: PageController(initialPage: currentQuestionIndex),
              onPageChanged: (index) {
                setState(() {
                  currentQuestionIndex = index;
                });
              },
              itemCount: result.questionResults.length,
              itemBuilder: (context, index) {
                return _buildQuestionCard(result.questionResults[index], index);
              },
            ),
          ),

          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.shadowBlack15, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Câu ${currentQuestionIndex + 1}/${result.questionResults.length}',
            style: AppTextStyles.textContent3.copyWith(
              color: AppColors.color8F959E,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            'Điểm: ${result.questionResults[currentQuestionIndex].scoreText}',
            style: AppTextStyles.textContent3.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionResultModel question, int index) {
    return SingleChildScrollView(
      padding: AppPad.a16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        question.isCorrect
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        question.isCorrect ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: question.isCorrect ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        question.isCorrect ? 'Trả lời đúng' : 'Trả lời sai',
                        style: AppTextStyles.textContent4.copyWith(
                          color: question.isCorrect ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  question.questionText,
                  style: AppTextStyles.textStyleDefault.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.raisinBlack,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: AppPad.a16,
            decoration: BoxDecoration(
              color:
                  question.isCorrect
                      ? AppColors.success.withOpacity(0.05)
                      : AppColors.error.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    question.isCorrect
                        ? AppColors.success.withOpacity(0.3)
                        : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: question.isCorrect ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Câu trả lời của bạn',
                      style: AppTextStyles.textContent2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: question.isCorrect ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
                if (question.userAnswer != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    question.userAnswer!,
                    style: AppTextStyles.textContent3.copyWith(color: AppColors.raisinBlack),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          if (!question.isCorrect)
            Container(
              padding: AppPad.a16,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(
                        'Đáp án đúng',
                        style: AppTextStyles.textContent2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  if (question.correctAnswer != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      question.correctAnswer!,
                      style: AppTextStyles.textContent3.copyWith(color: AppColors.raisinBlack),
                    ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 12),

          if (question.explanation != null)
            Container(
              padding: AppPad.a16,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Giải thích',
                        style: AppTextStyles.textContent2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.explanation!,
                    style: AppTextStyles.textContent3.copyWith(
                      color: AppColors.color8F959E,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.shadowBlack15, blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed:
                  currentQuestionIndex == 0
                      ? null
                      : () {
                        setState(() {
                          currentQuestionIndex--;
                        });
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightGray,
                foregroundColor: AppColors.color8F959E,
                elevation: 0,
                padding: AppPad.v12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Câu trước',
                style: AppTextStyles.textContent2.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  currentQuestionIndex == result.questionResults.length - 1
                      ? null
                      : () {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: AppPad.v12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Câu sau',
                style: AppTextStyles.textContent2.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
