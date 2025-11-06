import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/assessment/repository/quiz_repo.dart';
import 'package:ed_tech/modules/assessment/models/quiz_history_model.dart';

part 'quiz_history_state.dart';

class QuizHistoryCubit extends Cubit<QuizHistoryState> {
  final QuizRepo repo;

  QuizHistoryCubit({required this.repo}) : super(QuizHistoryInitial());

  Future<void> getQuizHistory({required String quizId}) async {
    emit(QuizHistoryLoading());
    try {
      final response = await repo.getQuizHistory(quizId: quizId);
      emit(QuizHistorySuccess(data: response));
    } catch (e) {
      final message = e is String ? e : AppErrorState.getFriendlyErrorString(e);
      emit(QuizHistoryError(message: message));
    }
  }
}
