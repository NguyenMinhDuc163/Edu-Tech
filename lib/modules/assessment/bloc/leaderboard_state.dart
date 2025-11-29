part of 'leaderboard_cubit.dart';

@immutable
sealed class LeaderboardState {}

final class LeaderboardInitial extends LeaderboardState {}

final class LeaderboardInProgress extends LeaderboardState {}

final class LeaderboardLoadingMore extends LeaderboardState {}

final class LeaderboardSuccess extends LeaderboardState {
  final LeaderboardModel data;
  final bool isLoadMore;

  LeaderboardSuccess({required this.data, this.isLoadMore = false});
}

final class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError({required this.message});
}
