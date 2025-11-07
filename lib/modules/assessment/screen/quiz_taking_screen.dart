import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/core/widgets/error_dialog.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_result_screen.dart';
import 'package:ed_tech/modules/assessment/bloc/quiz_taking_controller.dart';
import 'package:ed_tech/modules/assessment/bloc/quiz_taking_cubit.dart';
import 'package:ed_tech/modules/assessment/models/quiz_model.dart';
import 'package:ed_tech/modules/assessment/models/detail_quiz_model.dart' as detail;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:disposable_provider/disposable_provider.dart';
import '../models/question_model.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_bar.dart';

class QuizTakingScreen extends StatefulWidget {
  const QuizTakingScreen({super.key});

  static const String routeName = '/quiz-taking';

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  late final QuizTakingController controller;
  late final PageController pageController;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted || _isInitialized) return;

    controller = DisposableProvider.of<QuizTakingController>(context);
    pageController = PageController();
    _isInitialized = true;
    _loadQuizData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _loadQuizData() {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final quiz = args?['quiz'] as QuizModel?;

    if (quiz?.id != null) {
      context.read<QuizTakingCubit>().getQuizDetail(quizId: quiz!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizTakingCubit, QuizTakingState>(
      listener: (context, state) {
        if (state is QuizTakingInProgress) {
          controller.setLoading(true);
          controller.clearError();
        } else if (state is QuizSubmitInProgress) {
          controller.setLoading(true);
          controller.clearError();
        } else if (state is QuizSubmitSuccess) {
          Navigator.pushNamed(
            context,
            QuizResultScreen.routeName,
            arguments: {
              'result': state.data,
              'timeSpent': controller.timeSpent.value,
            },
          );
        } else if (state is QuizSubmitError) {
          controller.setLoading(false);
          controller.setError(state.message);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        } else if (state is QuizTakingSuccess) {
          controller.setLoading(false);

          final data = state.data.data;
          if (data != null) {
            final questions = data.questions.map((q) => q.toQuestionModel()).toList();

            final quizSession = QuizSessionModel(
              id: data.attemptId ?? 'attempt_${DateTime.now().millisecondsSinceEpoch}',
              quizId: data.quizInfo?.quizId ?? '',
              questions: questions,
              userAnswers: {},
              startTime: DateTime.now(),
            );

            controller.setQuizSession(quizSession);
          }
        } else if (state is QuizTakingError) {
          controller.setLoading(false);
          controller.setError(state.message);
          ErrorDialog.show(
            context,
            message: state.message,
            onClose: () => Navigator.pop(context),
          );
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.white,
                elevation: 0,
                title: Text('assessment.loading'.tr(), style: AppTextStyles.appbarTitle),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return ValueListenableBuilder<QuizSessionModel?>(
            valueListenable: controller.quizSession,
            builder: (context, quizSession, child) {
              if (quizSession == null) {
                return Scaffold(
                  backgroundColor: AppColors.background,
                  appBar: AppBar(
                    backgroundColor: AppColors.white,
                    elevation: 0,
                    title: Text('assessment.error'.tr(), style: AppTextStyles.appbarTitle),
                  ),
                  body: Center(
                    child: Text('assessment.cannot_load_quiz'.tr(), style: AppTextStyles.textContent2),
                  ),
                );
              }

              return _buildQuizContent(quizSession);
            },
          );
        },
      ),
    );
  }

  Widget _buildQuizContent(QuizSessionModel quizSession) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('assessment.quiz_title'.tr(), style: AppTextStyles.appbarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flag, color: AppColors.error),
            onPressed: () => _submitQuiz(),
            tooltip: 'assessment.submit_quiz'.tr(),
          ),
        ],
      ),
      body: Column(
        children: [
          QuizProgressBar(
            progress: quizSession.progress,
            currentQuestion: quizSession.currentQuestionIndex + 1,
            totalQuestions: quizSession.totalQuestions,
            remainingTime: const Duration(minutes: 40),
            showTimer: true,
          ),

          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: quizSession.questions.length,
              onPageChanged: (index) {
                controller.updateCurrentQuestionIndex(index);
              },
              itemBuilder: (context, index) {
                final question = quizSession.questions[index];
                final selectedAnswer = quizSession.userAnswers[question.id];

                return QuestionCard(
                  question: question,
                  questionNumber: index + 1,
                  totalQuestions: quizSession.totalQuestions,
                  selectedAnswerId: selectedAnswer,
                  onAnswerSelected:
                      (answerId) => controller.updateUserAnswer(question.id, answerId),
                );
              },
            ),
          ),

          Container(
            padding: AppPad.a16,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowBlack15,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ValueListenableBuilder<QuizSessionModel?>(
              valueListenable: controller.quizSession,
              builder: (context, session, child) {
                if (session == null) return const SizedBox.shrink();

                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: session.isFirstQuestion ? null : _previousQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightGray,
                          foregroundColor: AppColors.color8F959E,
                          elevation: 0,
                          padding: AppPad.v12,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'assessment.previous_question'.tr(),
                          style: AppTextStyles.textContent2.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextOrSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          padding: AppPad.v12,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          session.isLastQuestion ? 'assessment.submit_quiz'.tr() : 'assessment.next_question'.tr(),
                          style: AppTextStyles.textContent2.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _previousQuestion() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextOrSubmit() {
    final session = controller.quizSession.value;
    if (session?.isLastQuestion == true) {
      _submitQuiz();
    } else {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _submitQuiz() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('assessment.submit_quiz_title'.tr(), style: AppTextStyles.textStyleDefaultBold),
            content: Text(
              'assessment.submit_quiz_confirmation'.tr(),
              style: AppTextStyles.textContent2,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('assessment.cancel'.tr(), style: AppTextStyles.textButton),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: Text('assessment.submit_quiz'.tr(), style: AppTextStyles.button),
              ),
            ],
          ),
    );
  }

  void _confirmSubmit() {
    final session = controller.quizSession.value;
    if (session == null) return;

    final answers =
        session.userAnswers.entries
            .where((entry) => entry.value != null)
            .map((entry) => {'question_id': entry.key, 'answer_id': entry.value!})
            .toList();

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final quiz = args?['quiz'] as QuizModel?;

    if (quiz?.id != null) {
      final timeSpent = DateTime.now().difference(session.startTime);
      controller.setTimeSpent(timeSpent);
      context.read<QuizTakingCubit>().submitQuiz(quizId: quiz!.id, answers: answers);
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('assessment.exit_quiz_title'.tr(), style: AppTextStyles.textStyleDefaultBold),
            content: Text(
              'assessment.exit_quiz_confirmation'.tr(),
              style: AppTextStyles.textContent2,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('assessment.cancel'.tr(), style: AppTextStyles.textButton),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                ),
                child: Text('assessment.exit'.tr(), style: AppTextStyles.button),
              ),
            ],
          ),
    );
  }
}
