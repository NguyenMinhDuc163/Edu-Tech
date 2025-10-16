import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';

class QuizController extends Disposable {
  final IntVs currentQuestionIndex = IntVs(0);
  final BoolVs isAnswered = BoolVs(false);
  final BoolVs isQuizStarted = BoolVs(false);
  final BoolVs isQuizCompleted = BoolVs(false);
  final IntVs selectedAnswerIndex = IntVs(-1);
  final IntVs timeRemaining = IntVs(0);

  void startQuiz(int totalTime) {
    isQuizStarted.value = true;
    timeRemaining.value = totalTime;
    currentQuestionIndex.value = 0;
  }

  void nextQuestion() {
    currentQuestionIndex.value++;
    isAnswered.value = false;
    selectedAnswerIndex.value = -1;
  }

  void selectAnswer(int answerIndex) {
    selectedAnswerIndex.value = answerIndex;
    isAnswered.value = true;
  }

  void completeQuiz() {
    isQuizCompleted.value = true;
    isQuizStarted.value = false;
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    isAnswered.value = false;
    isQuizStarted.value = false;
    isQuizCompleted.value = false;
    selectedAnswerIndex.value = -1;
    timeRemaining.value = 0;
  }

  @override
  void dispose() {
    currentQuestionIndex.dispose();
    isAnswered.dispose();
    isQuizStarted.dispose();
    isQuizCompleted.dispose();
    selectedAnswerIndex.dispose();
    timeRemaining.dispose();
  }
}
