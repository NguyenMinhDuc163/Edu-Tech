import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/modules/course/screen/course_detail_screen.dart';

class CourseListItem extends StatelessWidget {
  const CourseListItem({
    super.key,
    required this.title,
    required this.instructor,
    required this.price,
    required this.duration,
    this.imageUrl,
    this.onTap,
  });

  final String title;
  final String instructor;
  final String price;
  final String duration;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(offset: Offset(0, 2), blurRadius: 8, color: Color.fromRGBO(0, 0, 0, 0.1)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.silverGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  imageUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, color: AppColors.coolGray, size: 32);
                          },
                        ),
                      )
                      : const Icon(Icons.image, color: AppColors.coolGray, size: 32),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.textContent1.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: AppColors.coolGray),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          instructor,
                          style: AppTextStyles.text.copyWith(color: AppColors.coolGray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.textHeader3.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.colorFFEBF0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          duration,
                          style: AppTextStyles.textContent4.copyWith(
                            color: AppColors.colorFF6905,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseListWidget extends StatelessWidget {
  const CourseListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CourseData> courses = [
      CourseData(
        title: 'Product Design v1.0',
        instructor: 'Robertson Connie',
        price: '\$190',
        duration: '16 hours',
      ),
      CourseData(
        title: 'Java Development',
        instructor: 'Nguyen Shane',
        price: '\$190',
        duration: '16 hours',
      ),
      CourseData(
        title: 'Visual Design',
        instructor: 'Bert Pullman',
        price: '\$250',
        duration: '14 hours',
      ),
    ];

    return Padding(
      padding: AppPad.h24,
      child: Column(
        children:
            courses.map((course) {
              return CourseListItem(
                title: course.title,
                instructor: course.instructor,
                price: course.price,
                duration: course.duration,
                onTap: () => _navigateToCourseDetail(context, course),
              );
            }).toList(),
      ),
    );
  }

  void _navigateToCourseDetail(BuildContext context, CourseData course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => CourseDetailScreen(
              courseId: course.title.toLowerCase().replaceAll(' ', '_'),
              title: course.title,
              instructor: course.instructor,
              price: course.price,
              duration: course.duration,
              description:
                  'Learn ${course.title} with ${course.instructor}. This comprehensive course covers all the essential topics you need to master.',
            ),
      ),
    );
  }
}

class CourseData {
  final String title;
  final String instructor;
  final String price;
  final String duration;

  CourseData({
    required this.title,
    required this.instructor,
    required this.price,
    required this.duration,
  });
}
