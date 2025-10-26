import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/modules/assessment/models/quiz_model.dart';
import 'package:flutter/foundation.dart';

class QuizDetailController extends Disposable {
  final ValueNotifier<QuizModel?> selectedQuiz = ValueNotifier<QuizModel?>(
    null,
  );

  void setQuiz(QuizModel quiz) {
    selectedQuiz.value = quiz;
  }

  QuizModel? get quiz => selectedQuiz.value;

  @override
  void dispose() {
    selectedQuiz.dispose();
  }
}
