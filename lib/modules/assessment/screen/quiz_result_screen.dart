import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/dashboard/screen/dashboard_screen.dart';
import '../models/quiz_result_model.dart';
import '../widgets/quiz_result_overview.dart';
import '../widgets/quiz_statistics_table.dart';
import '../widgets/quiz_detailed_answers.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});
  static const String routeName = '/quiz-result';

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late QuizResultModel result;

  @override
  void initState() {
    super.initState();
    _initializeResult();
  }

  void _initializeResult() {
    
    final questionResults = [
      QuestionResultModel(
        id: '1',
        questionNumber: 1,
        questionText: 'What is the capital of Vietnam?',
        questionType: QuestionType.multipleChoice,
        score: 2.5,
        maxScore: 2.5,
        isCorrect: true,
        userAnswer: 'Hanoi',
        correctAnswer: 'Hanoi',
        explanation: 'Hanoi is the capital city of Vietnam.',
      ),
      QuestionResultModel(
        id: '2',
        questionNumber: 2,
        questionText: 'Which programming language is used for Flutter?',
        questionType: QuestionType.multipleChoice,
        score: 2.5,
        maxScore: 2.5,
        isCorrect: true,
        userAnswer: 'Dart',
        correctAnswer: 'Dart',
        explanation:
            'Dart is the programming language used for Flutter development.',
      ),
      QuestionResultModel(
        id: '3',
        questionNumber: 3,
        questionText: 'What is the main purpose of setState() in Flutter?',
        questionType: QuestionType.multipleChoice,
        score: 2.5,
        maxScore: 2.5,
        isCorrect: true,
        userAnswer: 'To update the UI when data changes',
        correctAnswer: 'To update the UI when data changes',
        explanation:
            'setState() is used to notify the framework that the internal state has changed.',
      ),
      QuestionResultModel(
        id: '4',
        questionNumber: 4,
        questionText:
            'Explain the difference between StatelessWidget and StatefulWidget.',
        questionType: QuestionType.essay,
        score: 2.4,
        maxScore: 2.5,
        isCorrect: true,
        userAnswer:
            'StatelessWidget is immutable while StatefulWidget can change its state.',
        correctAnswer:
            'StatelessWidget is immutable and cannot change its properties after creation, while StatefulWidget can change its state and rebuild when setState() is called.',
        explanation:
            'Good understanding of the basic concepts, but could be more detailed.',
      ),
    ];

    result = QuizResultModel(
      id: 'result_1',
      quizId: 'quiz_1',
      quizTitle: 'Đề Anh',
      totalScore: 9.9,
      maxScore: 10.0,
      multipleChoiceScore: 7.5,
      essayScore: 2.4,
      questionResults: questionResults,
      completedAt: DateTime.now(),
      timeTaken: const Duration(minutes: 35),
      performanceMessage: 'Xuất sắc! Gần như hoàn hảo rồi!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Kết quả bài thi', style: AppTextStyles.appbarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppColors.primary),
            onPressed: () => _shareResult(),
            tooltip: 'Chia sẻ kết quả',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            QuizResultOverview(
              result: result,
              onViewDetails: () => _viewDetailedWork(),
            ),

            const SizedBox(height: 16),

            
            QuizStatisticsTable(result: result),

            const SizedBox(height: 16),

            
            QuizDetailedAnswers(
              result: result,
              onQuestionTap: (question) => _viewQuestionDetail(question),
            ),

            const SizedBox(height: 20),

            
            Padding(
              padding: AppPad.h16v20,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _retakeQuiz(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGray,
                        foregroundColor: AppColors.color8F959E,
                        elevation: 0,
                        padding: AppPad.v12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Làm lại',
                        style: AppTextStyles.textContent2.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _goToHome(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: AppPad.v12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Về trang chủ',
                        style: AppTextStyles.textContent2.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewDetailedWork() {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Xem bài làm chi tiết'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _viewQuestionDetail(QuestionResultModel question) {
    
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Chi tiết câu hỏi ${question.questionNumber}',
              style: AppTextStyles.textStyleDefaultBold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question.questionText, style: AppTextStyles.textContent2),
                const SizedBox(height: 12),
                if (question.userAnswer != null) ...[
                  Text(
                    'Câu trả lời của bạn:',
                    style: AppTextStyles.textContent3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    question.userAnswer!,
                    style: AppTextStyles.textContent3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (question.correctAnswer != null) ...[
                  Text(
                    'Đáp án đúng:',
                    style: AppTextStyles.textContent3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    question.correctAnswer!,
                    style: AppTextStyles.textContent3.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (question.explanation != null) ...[
                  Text(
                    'Giải thích:',
                    style: AppTextStyles.textContent3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Đóng', style: AppTextStyles.textButton),
              ),
            ],
          ),
    );
  }

  void _shareResult() {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chia sẻ kết quả bài thi'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _retakeQuiz() {
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bắt đầu làm lại bài thi'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _goToHome() {
    
    Navigator.pushNamedAndRemoveUntil(
      context,
      DashboardScreen.routeName, 
      (route) => false, 
    );
  }
}
