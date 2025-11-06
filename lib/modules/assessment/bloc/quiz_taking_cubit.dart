import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/assessment/repository/quiz_repo.dart';
import 'package:ed_tech/modules/assessment/models/detail_quiz_model.dart';
import 'package:ed_tech/modules/assessment/models/submit_quiz_model.dart';

part 'quiz_taking_state.dart';

class QuizTakingCubit extends Cubit<QuizTakingState> {
  final QuizRepo repo;

  QuizTakingCubit({required this.repo}) : super(QuizTakingInitial());

  Future<void> getQuizDetail({required String quizId}) async {
    emit(QuizTakingInProgress());
    try {
      final response = await repo.getQuizDetail(quizId: quizId);
      emit(QuizTakingSuccess(data: response));
    } catch (e) {
      final message = e is String ? e : AppErrorState.getFriendlyErrorString(e);
      emit(QuizTakingError(message: message));
    }
  }

  Future<void> submitQuiz({
    required String quizId,
    required List<Map<String, String>> answers,
  }) async {
    emit(QuizSubmitInProgress());
    try {
      final response = await repo.submitQuiz(quizId: quizId, answers: answers);
      emit(QuizSubmitSuccess(data: response));
    } catch (e) {
      emit(QuizSubmitError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
