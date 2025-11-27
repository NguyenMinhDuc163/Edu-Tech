import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/modules/home/bloc/home_cubit.dart';
import 'package:ed_tech/modules/home/bloc/home_state.dart';
import 'package:ed_tech/modules/home/model/course_stats_response.dart';
import 'package:ed_tech/modules/course/screen/course_detail_screen.dart';

class LearningPlanWidget extends StatefulWidget {
  final VoidCallback? onNavigateToQuizTab;

  const LearningPlanWidget({super.key, this.onNavigateToQuizTab});

  @override
  State<LearningPlanWidget> createState() => _LearningPlanWidgetState();
}

class _LearningPlanWidgetState extends State<LearningPlanWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getCourseStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) {
        return current is StatsProgress ||
            current is StatsSuccess ||
            current is StatsError ||
            current is StatsInitial;
      },
      builder: (context, state) {
        if (state is StatsProgress) {
          return Padding(
            padding: AppPad.h16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home_screen.learning_progress'.tr(),
                  style: AppTextStyles.textHeader3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is StatsSuccess) {
          final stats = state.stats;
          final validCourses = stats.courses
              .where((course) => course.title?.isNotEmpty ?? false)
              .toList();

          if (validCourses.isEmpty && stats.overview.totalResults == 0) {
            return Padding(
              padding: AppPad.h16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'home_screen.learning_progress'.tr(),
                    style: AppTextStyles.textHeader3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: AppPad.a16,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'home_screen.no_stats'.tr(),
                        style: AppTextStyles.text.copyWith(
                          color: AppColors.colorB8B8D2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: AppPad.h16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home_screen.learning_progress'.tr(),
                  style: AppTextStyles.textHeader3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                _OverviewSection(
                  overview: stats.overview,
                  onTap: widget.onNavigateToQuizTab,
                ),
                const SizedBox(height: 16),
                if (validCourses.isNotEmpty) ...[
                  _CoursesSection(courses: validCourses),
                  const SizedBox(height: 16),
                ],
                if (stats.recentResults.isNotEmpty) ...[
                  _RecentActivitySection(
                    recentResults: stats.recentResults.take(3).toList(),
                    onTap: widget.onNavigateToQuizTab,
                  ),
                ],
              ],
            ),
          );
        }

        if (state is StatsError) {
          return Padding(
            padding: AppPad.h16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home_screen.learning_progress'.tr(),
                  style: AppTextStyles.textHeader3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: AppPad.a16,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      state.message,
                      style: AppTextStyles.text.copyWith(
                        color: AppColors.colorB8B8D2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _OverviewSection extends StatelessWidget {
  final StatsOverview overview;
  final VoidCallback? onTap;

  const _OverviewSection({required this.overview, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: _StatCard(
              icon: Icons.quiz_outlined,
              label: 'home_screen.total_quizzes'.tr(),
              value: '${overview.totalResults}',
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: _StatCard(
              icon: Icons.stars_outlined,
              label: 'home_screen.average_score'.tr(),
              value: overview.averageScore.toStringAsFixed(1),
              color: AppColors.orange,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: _StatCard(
              icon: Icons.check_circle_outline,
              label: 'home_screen.passed'.tr(),
              value: '${overview.totalPassed}',
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            color: Color.fromRGBO(0, 0, 0, 0.08),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.textHeader3.copyWith(
              fontSize: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.text.copyWith(
              fontSize: 10,
              color: AppColors.colorB8B8D2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CoursesSection extends StatelessWidget {
  final List<CourseStats> courses;

  const _CoursesSection({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khóa học của bạn',
          style: AppTextStyles.textMedium.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 12),
        ...courses.map((course) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CourseDetailScreen.routeName,
                    arguments: {
                      'courseId': course.courseId,
                      'title': course.title,
                    },
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: _CourseProgressCard(course: course),
              ),
            )),
      ],
    );
  }
}

class _CourseProgressCard extends StatelessWidget {
  final CourseStats course;

  const _CourseProgressCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final progress = course.totalQuizzes == 0
        ? 0.0
        : (course.passRate / 100).clamp(0.0, 1.0);

    final Color progressColor = progress >= 0.7
        ? AppColors.success
        : progress >= 0.5
            ? AppColors.orange
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            color: Color.fromRGBO(0, 0, 0, 0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor.withOpacity(0.2),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Text(
                '${course.passRate}%',
                style: AppTextStyles.textMedium.copyWith(
                  fontSize: 12,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: AppTextStyles.textMedium.copyWith(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.quiz_outlined,
                              size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${course.totalQuizzes}',
                            style: AppTextStyles.text.copyWith(
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars_outlined,
                              size: 12, color: AppColors.orange),
                          const SizedBox(width: 4),
                          Text(
                            course.avgScore.toStringAsFixed(1),
                            style: AppTextStyles.text.copyWith(
                              fontSize: 11,
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  final List<RecentResult> recentResults;
  final VoidCallback? onTap;

  const _RecentActivitySection({required this.recentResults, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home_screen.recent_results'.tr(),
          style: AppTextStyles.textMedium.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 8,
                color: Color.fromRGBO(0, 0, 0, 0.08),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < recentResults.length; i++) ...[
                InkWell(
                  onTap: onTap,
                  child: _RecentResultItem(result: recentResults[i]),
                ),
                if (i < recentResults.length - 1)
                  Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.colorB8B8D2.withOpacity(0.2)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentResultItem extends StatelessWidget {
  final RecentResult result;

  const _RecentResultItem({required this.result});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} ${'assessment.minutes_ago'.tr()}';
      }
      return '${difference.inHours} ${'assessment.hours_ago'.tr()}';
    }
    return '${difference.inDays} ${'assessment.days_ago'.tr()}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: result.isPassed
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              result.isPassed ? Icons.check_circle : Icons.cancel,
              color: result.isPassed
                  ? AppColors.success
                  : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.quizTitle,
                  style: AppTextStyles.textMedium.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(result.completedAt),
                  style: AppTextStyles.text.copyWith(
                    fontSize: 11,
                    color: AppColors.colorB8B8D2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${result.score.toStringAsFixed(0)}đ',
            style: AppTextStyles.textMedium.copyWith(
              fontSize: 14,
              color: result.isPassed
                  ? AppColors.success
                  : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
