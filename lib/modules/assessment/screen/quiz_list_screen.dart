import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/quiz_model.dart';
import '../widgets/quiz_card_widget.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});
  static const String routeName = '/quizListScreen';
  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final List<QuizModel> recentQuizzes = [
    const QuizModel(
      id: '1',
      title: 'Đề Toán',
      type: 'Đề thi',
      timeLimit: 0,
      questionCount: 4,
      status: QuizStatus.notTaken,
      subject: 'Toán',
    ),
  ];

  final List<QuizModel> completedQuizzes = [
    QuizModel(
      id: '2',
      title: 'Đề Văn',
      type: 'Đề thi',
      timeLimit: 0,
      questionCount: 4,
      status: QuizStatus.completed,
      score: 0,
      attempts: 1,
      completedAt: DateTime.now().subtract(const Duration(minutes: 4)),
      subject: 'Văn',
    ),
    QuizModel(
      id: '3',
      title: 'Đề Anh',
      type: 'Đề thi',
      timeLimit: 0,
      questionCount: 4,
      status: QuizStatus.completed,
      score: 9,
      attempts: 3,
      completedAt: DateTime.now().subtract(const Duration(minutes: 6)),
      subject: 'Anh',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      actionsWidget: [
        SvgPicture.asset(IconPath.iconRanking, width: 25, height: 25, color: AppColors.black50),
      ],
      screen: SingleChildScrollView(
        padding: AppPad.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recentQuizzes.isNotEmpty) ...[
              _buildSectionHeader('Gần đây'),
              ...recentQuizzes.map(
                (quiz) => QuizCardWidget(quiz: quiz, onTap: () => _onQuizTap(quiz)),
              ),
              const SizedBox(height: 20),
            ],

            if (completedQuizzes.isNotEmpty) ...[
              _buildSectionHeader('Đã hoàn thành(${completedQuizzes.length})'),
              ...completedQuizzes.map(
                (quiz) => QuizCardWidget(quiz: quiz, onTap: () => _onQuizTap(quiz)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: AppPad.b20,
      child: Text(
        title,
        style: AppTextStyles.textStyleDefaultBold.copyWith(
          fontSize: 18,
          color: AppColors.raisinBlack,
        ),
      ),
    );
  }

  void _onQuizTap(QuizModel quiz) {
    Navigator.pushNamed(context, QuizDetailScreen.routeName);
  }
}
