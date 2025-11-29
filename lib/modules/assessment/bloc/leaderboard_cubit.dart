import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';
import 'package:ed_tech/modules/assessment/repository/quiz_repo.dart';
import 'package:ed_tech/modules/assessment/models/leaderboard_model.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final QuizRepo repo;

  LeaderboardCubit({required this.repo}) : super(LeaderboardInitial());

  Future<void> getLeaderboard({
    int page = 1,
    int limit = 20,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      emit(LeaderboardInProgress());
    } else {
      emit(LeaderboardLoadingMore());
    }

    try {
      final response = await repo.getLeaderboard(page: page, limit: limit);
      emit(LeaderboardSuccess(data: response, isLoadMore: isLoadMore));
    } catch (e) {
      emit(LeaderboardError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }
}
