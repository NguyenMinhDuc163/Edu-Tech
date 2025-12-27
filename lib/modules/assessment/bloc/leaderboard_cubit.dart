import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/assessment/repository/quiz_repo.dart';
import 'package:ed_tech/modules/assessment/models/leaderboard_model.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final QuizRepo repo;

  LeaderboardCubit({required this.repo}) : super(LeaderboardInitial());

  Future<void> getLeaderboard() async {
    emit(LeaderboardInProgress());

    try {
      final response = await repo.getLeaderboard();
      emit(LeaderboardSuccess(data: response, isLoadMore: false));
    } catch (e) {
      emit(LeaderboardError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
