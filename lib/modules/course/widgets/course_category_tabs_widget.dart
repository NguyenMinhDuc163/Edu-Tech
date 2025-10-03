import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/theme/app_pad.dart';

class CourseCategoryTabsWidget extends StatefulWidget {
  const CourseCategoryTabsWidget({super.key});

  @override
  State<CourseCategoryTabsWidget> createState() =>
      _CourseCategoryTabsWidgetState();
}

class _CourseCategoryTabsWidgetState extends State<CourseCategoryTabsWidget> {
  int selectedIndex = 0;

  final List<String> categories = ['All', 'Popular', 'New'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPad.h24.add(AppPad.v20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choice your course', style: AppTextStyles.textHeader3),
          const SizedBox(height: 16),
          Row(
            children:
                categories.asMap().entries.map((entry) {
                  int index = entry.key;
                  String category = entry.value;
                  bool isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < categories.length - 1 ? 16 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.color3D5CFF : AppColors.lightGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.textMedium.copyWith(
                          color:
                              isSelected ? AppColors.white : AppColors.coolGray,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
