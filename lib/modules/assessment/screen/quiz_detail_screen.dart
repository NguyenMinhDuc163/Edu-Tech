import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_result_screen.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_taking_screen.dart';
import '../models/quiz_model.dart';
import '../models/quiz_attempt_model.dart';
import '../widgets/quiz_info_section.dart';
import '../widgets/quiz_attempt_card.dart';

class QuizDetailScreen extends StatefulWidget {
  const QuizDetailScreen({super.key});
  static const String routeName = '/quizDetail';

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  
  late QuizModel quiz;
  late QuizAttemptModel lastAttempt;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    
    quiz = const QuizModel(
      id: '3',
      title: 'Đề Anh',
      type: 'Đề thi',
      timeLimit: 40,
      questionCount: 4,
      status: QuizStatus.completed,
      subject: 'Anh',
    );

    
    lastAttempt = QuizAttemptModel(
      id: '1',
      quizId: '3',
      totalScore: 9.9,
      correctAnswers: 3,
      totalQuestions: 4,
      timeTaken: 1,
      completedAt: DateTime(2025, 9, 3, 15, 12),
      questionAttempts: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      screen: SingleChildScrollView(
        padding: AppPad.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            QuizInfoSection(quiz: quiz, onStartQuiz: _onStartQuiz),

            const SizedBox(height: 24),

            
            _buildTestHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(
          'Lịch sử làm bài',
          style: AppTextStyles.textStyleDefaultBold.copyWith(
            fontSize: 18,
            color: AppColors.raisinBlack,
          ),
        ),

        const SizedBox(height: 16),

        
        QuizAttemptCard(attempt: lastAttempt, onViewDetails: _onViewDetails),
      ],
    );
  }

  void _onStartQuiz() {
    Navigator.pushNamed(context, QuizTakingScreen.routeName);

  }

  void _onViewDetails() {
    Navigator.pushNamed(context, QuizResultScreen.routeName);
  }
}
