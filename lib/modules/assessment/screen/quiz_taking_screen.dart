import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/assessment/screen/quiz_result_screen.dart';
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
  late QuizSessionModel quizSession;
  late Duration remainingTime;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _initializeQuiz() {
    
    final questions = [
      QuestionModel(
        id: '1',
        questionText:
            'Chọn đáp án đúng nhất cho câu hỏi: "What is the capital of Vietnam?"',
        answers: [
          AnswerModel(id: '1a', text: 'Ho Chi Minh City', isCorrect: false),
          AnswerModel(id: '1b', text: 'Hanoi', isCorrect: true),
          AnswerModel(id: '1c', text: 'Da Nang', isCorrect: false),
          AnswerModel(id: '1d', text: 'Hue', isCorrect: false),
        ],
      ),
      QuestionModel(
        id: '2',
        questionText:
            'Which programming language is used for Flutter development?',
        answers: [
          AnswerModel(id: '2a', text: 'Java', isCorrect: false),
          AnswerModel(id: '2b', text: 'Dart', isCorrect: true),
          AnswerModel(id: '2c', text: 'Python', isCorrect: false),
          AnswerModel(id: '2d', text: 'C++', isCorrect: false),
        ],
      ),
      QuestionModel(
        id: '3',
        questionText:
            'What is the main purpose of the setState() method in Flutter?',
        answers: [
          AnswerModel(
            id: '3a',
            text: 'To create new widgets',
            isCorrect: false,
          ),
          AnswerModel(
            id: '3b',
            text: 'To update the UI when data changes',
            isCorrect: true,
          ),
          AnswerModel(id: '3c', text: 'To handle user input', isCorrect: false),
          AnswerModel(id: '3d', text: 'To manage app state', isCorrect: false),
        ],
      ),
      QuestionModel(
        id: '4',
        questionText:
            'Which widget is used to create a scrollable list in Flutter?',
        answers: [
          AnswerModel(id: '4a', text: 'Column', isCorrect: false),
          AnswerModel(id: '4b', text: 'ListView', isCorrect: true),
          AnswerModel(id: '4c', text: 'Container', isCorrect: false),
          AnswerModel(id: '4d', text: 'Row', isCorrect: false),
        ],
      ),
    ];

    quizSession = QuizSessionModel(
      id: 'session_1',
      quizId: 'quiz_1',
      questions: questions,
      userAnswers: {},
      startTime: DateTime.now(),
    );

    
    remainingTime = const Duration(minutes: 40);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Đề Anh', style: AppTextStyles.appbarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flag, color: AppColors.error),
            onPressed: () => _submitQuiz(),
            tooltip: 'Nộp bài',
          ),
        ],
      ),
      body: Column(
        children: [
          
          QuizProgressBar(
            progress: quizSession.progress,
            currentQuestion: quizSession.currentQuestionIndex + 1,
            totalQuestions: quizSession.totalQuestions,
            remainingTime: remainingTime,
            showTimer: true,
          ),

          
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: quizSession.questions.length,
              onPageChanged: (index) {
                setState(() {
                  quizSession = quizSession.copyWith(
                    currentQuestionIndex: index,
                  );
                });
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
                      (answerId) => _selectAnswer(question.id, answerId),
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
            child: Row(
              children: [
                
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        quizSession.isFirstQuestion ? null : _previousQuestion,
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
                      'Câu trước',
                      style: AppTextStyles.textContent2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      quizSession.isLastQuestion ? 'Nộp bài' : 'Câu sau',
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
    );
  }

  void _selectAnswer(String questionId, String answerId) {
    setState(() {
      final newAnswers = Map<String, String?>.from(quizSession.userAnswers);
      newAnswers[questionId] = answerId;
      quizSession = quizSession.copyWith(userAnswers: newAnswers);
    });
  }

  void _previousQuestion() {
    if (!quizSession.isFirstQuestion) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextOrSubmit() {
    if (quizSession.isLastQuestion) {
      _submitQuiz();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitQuiz() {
    
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Nộp bài thi',
              style: AppTextStyles.textStyleDefaultBold,
            ),
            content: Text(
              'Bạn có chắc chắn muốn nộp bài thi? Sau khi nộp, bạn không thể thay đổi câu trả lời.',
              style: AppTextStyles.textContent2,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: AppTextStyles.textButton),
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
                child: Text('Nộp bài', style: AppTextStyles.button),
              ),
            ],
          ),
    );
  }

  void _confirmSubmit() {
    Navigator.pushNamed(context, QuizResultScreen.routeName);
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Thoát bài thi',
              style: AppTextStyles.textStyleDefaultBold,
            ),
            content: Text(
              'Bạn có chắc chắn muốn thoát bài thi? Tiến độ hiện tại sẽ không được lưu.',
              style: AppTextStyles.textContent2,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: AppTextStyles.textButton),
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
                child: Text('Thoát', style: AppTextStyles.button),
              ),
            ],
          ),
    );
  }
}
