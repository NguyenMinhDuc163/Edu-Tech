import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/home/bloc/home_cubit.dart';
import 'package:ed_tech/modules/home/bloc/home_state.dart';
import 'package:ed_tech/modules/home/model/course_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseSuggestionsWidget extends StatelessWidget {
  const CourseSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is CourseProgress) {
          return Padding(
            padding: AppPad.h16v8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended for you',
                      style: AppTextStyles.textHeader3,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('See all', style: AppTextStyles.textButton),
                    ),
                  ],
                ),
                AppGap.h16,
                const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          );
        }

        if (state is CourseSuccess) {
          final courses = state.courses;
          if (courses.isEmpty) {
            return Padding(
              padding: AppPad.h16v8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended for you',
                        style: AppTextStyles.textHeader3,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('See all', style: AppTextStyles.textButton),
                      ),
                    ],
                  ),
                  AppGap.h16,
                  const SizedBox(
                    height: 140,
                    child: Center(child: Text('Không có khóa học nào')),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: AppPad.h16v8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended for you',
                      style: AppTextStyles.textHeader3,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('See all', style: AppTextStyles.textButton),
                    ),
                  ],
                ),
                AppGap.h16,
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: courses.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder:
                        (context, index) => _CourseCard(course: courses[index]),
                  ),
                ),
              ],
            ),
          );
        }

        // Default state hoặc error
        return Padding(
          padding: AppPad.h16v8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recommended for you', style: AppTextStyles.textHeader3),
                  TextButton(
                    onPressed: () {},
                    child: Text('See all', style: AppTextStyles.textButton),
                  ),
                ],
              ),
              AppGap.h16,
              const SizedBox(
                height: 140,
                child: Center(child: Text('Không thể tải dữ liệu')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final DataCourse course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, 0.06),
          ),
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 20,
            color: AppColors.shadowBlack15,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: double.infinity,
            decoration: BoxDecoration(
              color: _getColorForCourse(course.categoryId ?? ''),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            padding: AppPad.a10,
            child:
                course.thumbnailUrl != null
                    ? Image.network(
                      course.thumbnailUrl.toString(),
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => SvgPicture.asset(
                            'assets/images/intro_step_1.svg',
                            fit: BoxFit.contain,
                          ),
                    )
                    : SvgPicture.asset(
                      'assets/images/intro_step_1.svg',
                      fit: BoxFit.contain,
                    ),
          ),
          Expanded(
            child: Padding(
              padding: AppPad.h12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title ?? 'Untitled Course',
                    style: AppTextStyles.textMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.colorFF7043, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '4.5', // Default rating
                        style: AppTextStyles.text,
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.coolGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.courseDuration?.toString() ?? '0h 0m',
                        style: AppTextStyles.text.copyWith(
                          color: AppColors.coolGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.teacher?.toString() ?? 'Unknown Teacher',
                    style: AppTextStyles.text.copyWith(
                      color: AppColors.coolGray,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForCourse(String categoryId) {
    // Map categoryId to different colors
    switch (categoryId) {
      case '1':
        return const Color(0xFFEFF4FF);
      case '2':
        return const Color(0xFFF6F9FF);
      case '3':
        return const Color(0xFFF4FBFF);
      default:
        return const Color(0xFFEFF4FF);
    }
  }
}
