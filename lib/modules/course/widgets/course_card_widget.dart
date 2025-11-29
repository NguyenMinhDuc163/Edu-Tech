import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/core/constants/image_path.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';

class CourseCardWidget extends StatelessWidget {
  const CourseCardWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    required this.textColor,
  });

  final String title;
  final String imagePath;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.45,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SvgPicture.asset(imagePath, fit: BoxFit.cover),
            ),
          ),

          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: AppTextStyles.textMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCardsCarousel extends StatelessWidget {
  const CourseCardsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CourseCardData> courseCards = [
      CourseCardData(
        title: 'course_tab.card_language',
        imagePath: ImagePath.persionLanguege,
        backgroundColor: const Color(0xFFE3F2FD),
        textColor: const Color(0xFF1976D2),
      ),
      CourseCardData(
        title: 'course_tab.card_painting',
        imagePath: ImagePath.persionPaint,
        backgroundColor: const Color(0xFFF3E5F5),
        textColor: const Color(0xFF7B1FA2),
      ),
      CourseCardData(
        title: 'course_tab.card_design',
        imagePath: ImagePath.persionLanguege,
        backgroundColor: const Color(0xFFE8F5E8),
        textColor: const Color(0xFF2E7D32),
      ),
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courseCards.length,
        itemBuilder: (context, index) {
          final card = courseCards[index];
          return CourseCardWidget(
            title: card.title.tr(),
            imagePath: card.imagePath,
            backgroundColor: card.backgroundColor,
            textColor: card.textColor,
          );
        },
      ),
    );
  }
}

class CourseCardData {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final Color textColor;

  CourseCardData({
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    required this.textColor,
  });
}
