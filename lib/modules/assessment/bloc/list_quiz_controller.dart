import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/core/data_types.dart';
import 'package:ed_tech/modules/assessment/models/quiz_model.dart';

class ListQuizController extends Disposable {
  final BoolVs isLoading = BoolVs(false);
  final ListVs<QuizModel> quizzes = ListVs<QuizModel>([]);
  final StringVs errorMessage = StringVs('');

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setQuizzes(List<QuizModel> list) {
    quizzes.value = list;
  }

  void addQuiz(QuizModel quiz) {
    quizzes.add(quiz);
  }

  void clearQuizzes() {
    quizzes.clear();
  }

  void setError(String message) {
    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = '';
  }

  @override
  void dispose() {
    isLoading.dispose();
    quizzes.dispose();
    errorMessage.dispose();
  }
}
