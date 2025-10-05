import 'package:ed_tech/modules/payment/screen/payment_method_screen.dart';
import 'package:ed_tech/modules/reviews/screen/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/course/widgets/course_lesson_bottom_sheet.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  final String title;
  final String instructor;
  final String price;
  final String duration;
  final String? imageUrl;
  final String? description;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.title,
    required this.instructor,
    required this.price,
    required this.duration,
    this.imageUrl,
    this.description,
  });

  static const String routeName = '/CourseDetailScreen';

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  void _showLessonBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) =>
              CourseLessonBottomSheet(courseTitle: widget.title, lessons: _getSampleLessons()),
    );
  }

  List<LessonData> _getSampleLessons() {
    return [
      const LessonData(
        id: '1',
        title: 'Welcome to the Course',
        duration: '6:10 mins',
        isCompleted: true,
        isLocked: false,
      ),
      const LessonData(
        id: '2',
        title: 'Process overview',
        duration: '6:10 mins',
        isCompleted: false,
        isLocked: false,
      ),
      const LessonData(
        id: '3',
        title: 'Discovery',
        duration: '6:10 mins',
        isCompleted: false,
        isLocked: true,
      ),
      const LessonData(
        id: '4',
        title: 'User Research',
        duration: '8:15 mins',
        isCompleted: false,
        isLocked: true,
      ),
      const LessonData(
        id: '5',
        title: 'Wireframing',
        duration: '12:30 mins',
        isCompleted: false,
        isLocked: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [_buildVideoPlayerSection(), _buildBottomSheet(), _buildBottomActionButtons()],
      ),
    );
  }

  Widget _buildVideoPlayerSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFEBF0), Color(0xFFFFF0F5)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.play_circle_outline, size: 80, color: AppColors.primary),
                ),

                const SizedBox(height: 20),

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.pause, color: AppColors.primary, size: 30),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '4:10',
                      style: AppTextStyles.textContent3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '6:10',
                      style: AppTextStyles.textContent3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.68,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorFF6905,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            border: Border.all(color: AppColors.lightGray.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                _buildCourseDetailsSection(),

                _buildAboutSection(),

                _buildLessonsPreviewSection(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: AppPad.h24.add(AppPad.v20),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ReviewScreen.routeName);
              },
              child: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.colorFFEBF0,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.colorFF6905),
                ),
                child: const Icon(Icons.star_border, color: AppColors.colorFF6905, size: 24),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PaymentMethodScreen.routeName);
                  },
                  child: Text('Buy Now', style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseDetailsSection() {
    return Container(
      padding: AppPad.h24.add(AppPad.v20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: AppTextStyles.textHeader2.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            widget.price,
            style: AppTextStyles.textHeader2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: AppPad.h24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this course',
            style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            widget.description ??
                'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
            style: AppTextStyles.textContent2.copyWith(color: AppColors.color8F959E, height: 1.5),
          ),
          const SizedBox(height: 16),
          const Icon(Icons.visibility_off, color: AppColors.color8F959E, size: 20),
        ],
      ),
    );
  }

  Widget _buildLessonsPreviewSection() {
    return Padding(
      padding: AppPad.h24.add(const EdgeInsets.only(top: 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lessons', style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          ..._getSampleLessons().take(3).map((lesson) => _buildLessonItem(lesson)),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: _showLessonBottomSheet,
            child: Container(
              width: double.infinity,
              padding: AppPad.v12,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'View All Lessons',
                textAlign: TextAlign.center,
                style: AppTextStyles.textButton.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(LessonData lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                lesson.id.padLeft(2, '0'),
                style: AppTextStyles.textContent2.copyWith(
                  color: AppColors.color8F959E,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: AppTextStyles.textContent1.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.duration,
                  style: AppTextStyles.textContent3.copyWith(color: AppColors.color8F959E),
                ),
              ],
            ),
          ),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: lesson.isLocked ? AppColors.lightGray : AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              lesson.isLocked ? Icons.lock : Icons.play_arrow,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class LessonData {
  final String id;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;

  const LessonData({
    required this.id,
    required this.title,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
  });
}
