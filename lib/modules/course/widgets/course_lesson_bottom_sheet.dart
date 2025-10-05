import 'package:flutter/material.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/course/screen/course_detail_screen.dart';

class CourseLessonBottomSheet extends StatefulWidget {
  final String courseTitle;
  final List<LessonData> lessons;

  const CourseLessonBottomSheet({super.key, required this.courseTitle, required this.lessons});

  @override
  State<CourseLessonBottomSheet> createState() => _CourseLessonBottomSheetState();
}

class _CourseLessonBottomSheetState extends State<CourseLessonBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
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

              Padding(
                padding: AppPad.h24.add(const EdgeInsets.only(top: 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.courseTitle,
                        style: AppTextStyles.textHeader3.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.close, color: AppColors.text, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: AppPad.h24.add(AppPad.b20),
                  itemCount: widget.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = widget.lessons[index];
                    return _buildLessonItem(lesson, index + 1);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLessonItem(LessonData lesson, int lessonNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lesson.isCompleted ? AppColors.primary.withOpacity(0.3) : AppColors.lightGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: lesson.isCompleted ? AppColors.primary.withOpacity(0.1) : AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child:
                  lesson.isCompleted
                      ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                      : Text(
                        lessonNumber.toString().padLeft(2, '0'),
                        style: AppTextStyles.textContent1.copyWith(
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
                  style: AppTextStyles.textContent1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: lesson.isLocked ? AppColors.color8F959E : AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      lesson.duration,
                      style: AppTextStyles.textContent3.copyWith(color: AppColors.color8F959E),
                    ),
                    if (lesson.isCompleted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Completed',
                          style: AppTextStyles.textContent4.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: lesson.isLocked ? null : () => _playLesson(lesson),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: lesson.isLocked ? AppColors.lightGray : AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                lesson.isLocked
                    ? Icons.lock
                    : lesson.isCompleted
                    ? Icons.replay
                    : Icons.play_arrow,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playLesson(LessonData lesson) {
    print('Playing lesson: ${lesson.title}');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(lesson.title),
            content: Text('Duration: ${lesson.duration}'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
            ],
          ),
    );
  }
}
