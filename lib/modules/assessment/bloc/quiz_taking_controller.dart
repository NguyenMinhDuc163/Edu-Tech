import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:ed_tech/modules/assessment/models/question_model.dart';

class QuizTakingController extends Disposable {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<QuizSessionModel?> quizSession =
      ValueNotifier<QuizSessionModel?>(null);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setQuizSession(QuizSessionModel session) {
    quizSession.value = session;
  }

  void setError(String message) {
    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = null;
  }

  void updateUserAnswer(String questionId, String? answerId) {
    final currentSession = quizSession.value;
    if (currentSession == null) return;

    final newAnswers = Map<String, String?>.from(currentSession.userAnswers);
    newAnswers[questionId] = answerId;

    quizSession.value = currentSession.copyWith(userAnswers: newAnswers);
  }

  void updateCurrentQuestionIndex(int index) {
    final currentSession = quizSession.value;
    if (currentSession == null) return;

    quizSession.value = currentSession.copyWith(currentQuestionIndex: index);
  }

  @override
  void dispose() {
    isLoading.dispose();
    quizSession.dispose();
    errorMessage.dispose();
  }
}
