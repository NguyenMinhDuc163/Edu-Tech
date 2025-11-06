import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_taking_screen.dart';
import 'package:ed_tech/modules/assessment/bloc/quiz_detail_controller.dart';
import 'package:ed_tech/modules/assessment/bloc/quiz_history_cubit.dart';
import 'package:ed_tech/modules/assessment/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:disposable_provider/disposable_provider.dart';
import '../widgets/quiz_info_section.dart';
import '../widgets/quiz_history_section.dart';

class QuizDetailScreen extends StatefulWidget {
  const QuizDetailScreen({super.key});
  static const String routeName = '/quizDetail';

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  late final QuizDetailController controller;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted || _isInitialized) return;

    controller = DisposableProvider.of<QuizDetailController>(context);
    _isInitialized = true;
    _initializeData();
  }

  void _initializeData() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is Map<String, dynamic>) {
      final quiz = args['quiz'] as QuizModel?;

      if (quiz != null) {
        controller.setQuiz(quiz);
        context.read<QuizHistoryCubit>().getQuizHistory(quizId: quiz.id);
      }
    }

    if (controller.quiz == null) {
      controller.setQuiz(
        const QuizModel(
          id: '3',
          title: 'Bài kiểm tra trắc nghiệm JavaScript',
          type: 'ASSIGNMENT',
          timeLimit: 40,
          questionCount: 4,
          status: QuizStatus.completed,
          subject: 'JavaScript',
        ),
      );
      context.read<QuizHistoryCubit>().getQuizHistory(quizId: '3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<QuizModel?>(
      valueListenable: controller.selectedQuiz,
      builder: (context, quiz, child) {
        if (quiz == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return FunctionScreenTemplate(
          isShowBottomButton: false,
          screen: SingleChildScrollView(
            padding: AppPad.a16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuizInfoSection(quiz: quiz, onStartQuiz: _onStartQuiz),
                const SizedBox(height: 16),
                BlocBuilder<QuizHistoryCubit, QuizHistoryState>(
                  builder: (context, state) {
                    if (state is QuizHistoryLoading) {
                      return Container(
                        padding: AppPad.a16,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is QuizHistorySuccess) {
                      return QuizHistorySection(history: state.data.data);
                    } else if (state is QuizHistoryError) {
                      return Container(
                        padding: AppPad.a16,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            state.message,
                            style: AppTextStyles.textContent2.copyWith(color: AppColors.error),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onStartQuiz() {
    final quiz = controller.quiz;
    if (quiz != null) {
      Navigator.pushNamed(
        context,
        QuizTakingScreen.routeName,
        arguments: {'quiz': quiz},
      );
    }
  }
}
