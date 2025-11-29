import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/assessment/bloc/leaderboard_cubit.dart';
import 'package:ed_tech/modules/assessment/bloc/leaderboard_controller.dart';
import 'package:ed_tech/modules/assessment/models/leaderboard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  static const String routeName = '/leaderboardScreen';

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardCubit>().getLeaderboard();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final controller = context.read<LeaderboardController>();
      if (!controller.isLoadingMore.value &&
          controller.currentPage.value < controller.totalPages.value) {
        context.read<LeaderboardCubit>().getLeaderboard(
              page: controller.currentPage.value + 1,
              isLoadMore: true,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaderboardCubit, LeaderboardState>(
      listener: (context, state) {
        final controller = context.read<LeaderboardController>();

        if (state is LeaderboardInProgress) {
          controller.setLoading(true);
          controller.clearError();
        } else if (state is LeaderboardLoadingMore) {
          controller.setLoadingMore(true);
        } else if (state is LeaderboardSuccess) {
          controller.setLoading(false);
          controller.setLoadingMore(false);

          final items = state.data.data.data;
          controller.setLeaderboardItems(items, append: state.isLoadMore);
          controller.setCurrentPage(state.data.data.pagination.page);
          controller.setTotalPages(state.data.data.pagination.totalPages);
        } else if (state is LeaderboardError) {
          controller.setLoading(false);
          controller.setLoadingMore(false);
          controller.setError(state.message);
        }
      },
      child: FunctionScreenTemplate(
        title: 'assessment.leaderboard_title'.tr(),
        isShowAppBar: true,
        isShowBottomButton: false,
        screen: ValueListenableBuilder<bool>(
          valueListenable: context.read<LeaderboardController>().isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ValueListenableBuilder<List<LeaderboardItem>>(
              valueListenable: context.read<LeaderboardController>().leaderboardItems,
              builder: (context, items, child) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'assessment.leaderboard_no_data'.tr(),
                      style: AppTextStyles.textStyleDefault,
                    ),
                  );
                }

                final top3 = items.take(3).toList();
                final remaining = items.skip(3).toList();

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: AppPad.a16,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (top3.isNotEmpty) _buildTopThreePodium(top3),
                        const SizedBox(height: 24),
                        if (remaining.isNotEmpty) ...[
                          _buildRemainingList(remaining),
                          ValueListenableBuilder<bool>(
                            valueListenable: context.read<LeaderboardController>().isLoadingMore,
                            builder: (context, isLoadingMore, child) {
                              if (isLoadingMore) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopThreePodium(List<LeaderboardItem> top3) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.colorF4F3FD,
            AppColors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (top3.length > 1) _buildPodiumItem(top3[1], 2),
              if (top3.isNotEmpty) _buildPodiumItem(top3[0], 1),
              if (top3.length > 2) _buildPodiumItem(top3[2], 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardItem item, int rank) {
    Color getMedalColor(int r) {
      if (r == 1) return const Color(0xFFFFD700);
      if (r == 2) return const Color(0xFFC0C0C0);
      return const Color(0xFFCD7F32);
    }

    Color getMedalGradientEnd(int r) {
      if (r == 1) return const Color(0xFFFFE55C);
      if (r == 2) return const Color(0xFFE8E8E8);
      return const Color(0xFFE89B6B);
    }

    Color getPodiumColor(int r) {
      if (r == 1) return AppColors.primary;
      if (r == 2) return AppColors.lavenderColor;
      return AppColors.color0961F5;
    }

    final isFirst = rank == 1;
    final height = isFirst ? 100.0 : rank == 2 ? 85.0 : 70.0;
    final avatarSize = isFirst ? 64.0 : 56.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        getPodiumColor(rank).withValues(alpha: 0.2),
                        getPodiumColor(rank).withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: getPodiumColor(rank).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item.username.isNotEmpty ? item.username[0].toUpperCase() : '?',
                      style: AppTextStyles.textStyleDefaultBold.copyWith(
                        fontSize: isFirst ? 28 : 22,
                        color: getPodiumColor(rank),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: isFirst ? 32 : 26,
                  height: isFirst ? 32 : 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [getMedalColor(rank), getMedalGradientEnd(rank)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: getMedalColor(rank).withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: AppColors.white,
                    size: isFirst ? 18 : 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.username,
              style: AppTextStyles.textStyleDefaultBold.copyWith(
                fontSize: isFirst ? 14 : 12,
                color: AppColors.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getPodiumColor(rank).withValues(alpha: 0.15),
                    getPodiumColor(rank).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: getPodiumColor(rank).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    item.totalScore.toStringAsFixed(1),
                    style: AppTextStyles.textHeader3.copyWith(
                      color: getPodiumColor(rank),
                      fontSize: isFirst ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'assessment.leaderboard_total_score'.tr(),
                    style: AppTextStyles.textContent4.copyWith(
                      color: AppColors.color8F959E,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getPodiumColor(rank),
                    getPodiumColor(rank).withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: getPodiumColor(rank).withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: AppTextStyles.textHeader1.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isFirst ? 28 : 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemainingList(List<LeaderboardItem> items) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildLeaderboardCard(item, index + 4);
      }).toList(),
    );
  }

  Widget _buildLeaderboardCard(LeaderboardItem item, int displayRank) {
    return Container(
      margin: AppPad.b10,
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack15,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$displayRank',
                style: AppTextStyles.textStyleDefaultBold.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.username,
                  style: AppTextStyles.textStyleDefaultBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: AppColors.color8F959E,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.completedQuizzes} ${'assessment.leaderboard_completed_quizzes'.tr()}',
                      style: AppTextStyles.textContent4.copyWith(
                        color: AppColors.color8F959E,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.totalScore.toStringAsFixed(1),
                style: AppTextStyles.textHeader3.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                'assessment.leaderboard_avg_score'.tr(),
                style: AppTextStyles.textContent4.copyWith(
                  color: AppColors.color8F959E,
                ),
              ),
              Text(
                item.avgScore,
                style: AppTextStyles.textContent3.copyWith(
                  color: AppColors.color8F959E,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<LeaderboardController>().reset();
    await context.read<LeaderboardCubit>().getLeaderboard();
  }
}
