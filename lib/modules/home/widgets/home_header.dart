import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/data/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/modules/home/bloc/home_cubit.dart';
import 'package:ed_tech/modules/home/bloc/home_state.dart';
import 'package:ed_tech/modules/home/model/learning_progress_response.dart';

class HomeHeaderWidget extends StatefulWidget {
  const HomeHeaderWidget({super.key, this.stackChildren = const []});
  final List<Widget> stackChildren;

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getLearningProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 150;
    const double cardHeight = 110;

    return SizedBox(
      height: headerHeight + cardHeight / 2,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: headerHeight,
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColors.color3D5CFF),
            child: Padding(
              padding: AppPad.h20v10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'home_screen.hi'.tr()} ${UserService.instance.displayName}',
                    style: AppTextStyles.textHeader2.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'home_screen.lets_start_learning'.tr(),
                    style: AppTextStyles.text.copyWith(
                      color: AppColors.offWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 24,
            right: 24,
            top: headerHeight - (cardHeight / 2),
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) {
                return current is ProgressLoading ||
                    current is ProgressSuccess ||
                    current is ProgressError;
              },
              builder: (context, state) {
                if (state is ProgressSuccess) {
                  return _ProgressCard(data: state.progress);
                }
                if (state is ProgressError) {
                  return _ProgressCardError();
                }
                return _ProgressCardLoading();
              },
            ),
          ),
          ...widget.stackChildren,
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final LearningProgressData data;

  const _ProgressCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final double progress = data.overallProgress / 100;

    return Container(
      padding: AppPad.h16v14,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, 0.075),
          ),
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: AppColors.shadowBlack15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home_screen.overall_progress'.tr(),
                style: AppTextStyles.textMedium.copyWith(
                  color: AppColors.coolGray,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${data.overallProgress}%',
                  style: AppTextStyles.textMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'home_screen.total_courses'.tr(),
                  value: '${data.totalCourses}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatItem(
                  label: 'home_screen.completed_courses'.tr(),
                  value: '${data.completedCourses}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatItem(
                  label: 'home_screen.in_progress_courses'.tr(),
                  value: '${data.inProgressCourses}',
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: progress,
              backgroundColor: AppColors.silverGray,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.colorFF7043,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${'home_screen.lessons_completed'.tr()}: ${data.completedLessons}/${data.totalLessons}',
            style: AppTextStyles.text.copyWith(
              color: AppColors.coolGray,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            color: AppColors.coolGray,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ProgressCardLoading extends StatelessWidget {
  const _ProgressCardLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: AppPad.h16v14,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, 0.075),
          ),
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: AppColors.shadowBlack15,
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ProgressCardError extends StatelessWidget {
  const _ProgressCardError();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: AppPad.h16v14,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, 0.075),
          ),
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: AppColors.shadowBlack15,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'home_screen.no_progress_data'.tr(),
          style: AppTextStyles.text.copyWith(
            color: AppColors.coolGray,
          ),
        ),
      ),
    );
  }
}
