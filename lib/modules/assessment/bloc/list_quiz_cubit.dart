import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/assessment/repository/quiz_repo.dart';
import 'package:ed_tech/modules/assessment/models/list_quiz_model.dart';

part 'list_quiz_state.dart';

class ListQuizCubit extends Cubit<ListQuizState> {
  final QuizRepo repo;

  ListQuizCubit({required this.repo}) : super(ListQuizInitial());

  Future<void> getListQuiz({
    String? courseId,
    String? sectionId,
    String? lessonId,
  }) async {
    emit(ListQuizInProgress());
    try {
      final response = await repo.getListQuiz(
        courseId: courseId,
        sectionId: sectionId,
        lessonId: lessonId,
      );

      emit(ListQuizSuccess(data: response));
    } catch (e) {
      emit(ListQuizError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
