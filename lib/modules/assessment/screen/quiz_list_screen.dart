import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_detail_screen.dart';
import 'package:ed_tech/modules/assessment/screen/leaderboard_screen.dart';
import 'package:ed_tech/modules/assessment/bloc/list_quiz_controller.dart';
import 'package:ed_tech/modules/assessment/bloc/list_quiz_cubit.dart';
import 'package:ed_tech/modules/assessment/models/quiz_model.dart';
import 'package:ed_tech/modules/assessment/models/list_quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/quiz_card_widget.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  static const String routeName = '/quizListScreen';

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListQuizCubit>().getListQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListQuizCubit, ListQuizState>(
      listener: (context, state) {
        final controller = context.read<ListQuizController>();

        if (state is ListQuizInProgress) {
          controller.setLoading(true);
          controller.clearError();
        } else if (state is ListQuizSuccess) {
          controller.setLoading(false);

          final quizzes =
              state.data.data.map((datum) {
                return QuizModel.fromDatum(datum);
              }).toList();

          controller.setQuizzes(quizzes);
        } else if (state is ListQuizError || state is ListQuizFailure) {
          controller.setLoading(false);
          final errorMessage =
              state is ListQuizError
                  ? state.message
                  : (state as ListQuizFailure).message;
          controller.setError(errorMessage);
        }
      },
      child: FunctionScreenTemplate(
        actionsWidget: [
          InkWell(
            onTap: _onRankingTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                IconPath.iconRanking,
                width: 25,
                height: 25,
                color: AppColors.black50,
              ),
            ),
          ),
        ],
        isShowAppBar: false,
        isShowBottomButton: false,
        screen: ValueListenableBuilder<bool>(
          valueListenable: context.read<ListQuizController>().isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ValueListenableBuilder<List<QuizModel>>(
              valueListenable: context.read<ListQuizController>().quizzes,
              builder: (context, quizzes, child) {
                if (quizzes.isEmpty) {
                  return Center(
                    child: Text(
                      'assessment.no_quizzes'.tr(),
                      style: AppTextStyles.textStyleDefault,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    padding: AppPad.a16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          '${'assessment.all_quizzes'.tr()} (${quizzes.length})',
                        ),
                        ...quizzes.map(
                          (quiz) => QuizCardWidget(
                            quiz: quiz,
                            onTap: () => _onQuizTap(quiz),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: AppPad.b20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.textStyleDefaultBold.copyWith(
              fontSize: 18,
              color: AppColors.raisinBlack,
            ),
          ),
          InkWell(
            onTap: _onRankingTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                IconPath.iconRanking,
                width: 25,
                height: 25,
                color: AppColors.black50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQuizTap(QuizModel quiz) {
    Navigator.pushNamed(
      context,
      QuizDetailScreen.routeName,
      arguments: {'quiz': quiz},
    );
  }

  void _onRankingTap() {
    print('🏆 Ranking icon tapped!');
    print('🏆 Navigating to: ${LeaderboardScreen.routeName}');
    Navigator.pushNamed(context, LeaderboardScreen.routeName);
  }

  Future<void> _onRefresh() async {
    await context.read<ListQuizCubit>().getListQuiz();
  }
}
