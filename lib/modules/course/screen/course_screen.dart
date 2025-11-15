import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/init.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/modules/course/widgets/course_card_widget.dart';
import 'package:ed_tech/modules/course/widgets/course_category_tabs_widget.dart';
import 'package:ed_tech/modules/course/widgets/course_list_widget.dart';
import 'package:ed_tech/modules/course/bloc/course_controller.dart';
import 'package:ed_tech/modules/course/screen/search_course_screen.dart';
import 'package:ed_tech/core/widgets/search_filter_bottom_sheet.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});
  static const String routeName = '/CourseScreen';

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  static const List<String> _categories = [
    'Design',
    'Coding',
    'Painting',
    'Music',
    'Visual identity',
    'Mathematics',
  ];
  static const List<String> _durations = [
    '3-8 Hours',
    '8-14 Hours',
    '14-20 Hours',
    '20-24 Hours',
    '24-30 Hours',
  ];
  static const double _minPrice = 0;
  static const double _maxPrice = 500;

  void _showFilterBottomSheet(BuildContext context) {
    final CourseController controller = DisposableProvider.of<CourseController>(
      context,
    );

    context.showSearchFilterBottomSheet(
      categories: _categories,
      durations: _durations,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      selectedCategories: controller.selectedCategories.value,
      selectedDurations: controller.selectedDurations.value,
      selectedMinPrice: controller.selectedMinPrice.value,
      selectedMaxPrice: controller.selectedMaxPrice.value,
      onApplyFilter: (categories, durations, minPrice, maxPrice) {
        controller.updateFilter(
          categories: categories,
          durations: durations,
          minPrice: minPrice,
          maxPrice: maxPrice,
        );

        print(
          'Applied filter: Categories: $categories, Durations: $durations, Price: \$${minPrice.toInt()} - \$${maxPrice.toInt()}',
        );
      },
      onClearFilter: () {
        controller.clearFilter();
        print('Filter cleared');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final CourseController controller = DisposableProvider.of<CourseController>(
      context,
    );

    return FunctionScreenTemplate(
      isShowAppBar: false,
      isShowBottomButton: false,
      screen: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: AppPad.h24.add(AppPad.t24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Course', style: AppTextStyles.textHeader2),
                  CircleAvatar(
                    radius: 22,
                    child: SvgPicture.asset(IconPath.iconAvatar),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPad.h24.add(AppPad.v12),
              child: _SearchBar(
                controller: controller,
                onFilterTap: () => _showFilterBottomSheet(context),
              ),
            ),
            const SizedBox(height: 20),
            const CourseCardsCarousel(),
            const CourseCategoryTabsWidget(),
            const SizedBox(height: 20),
            const CourseListWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onFilterTap});
  final CourseController controller;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorF4F3FD,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.colorB8B8D2),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SearchCourseScreen.routeName);
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Find Course',
                    hintStyle: AppTextStyles.inputHintText.copyWith(
                      color: AppColors.colorB8B8D2,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: SvgPicture.asset(IconPath.iconFilter, width: 8, height: 8),
            ),
          ),
        ],
      ),
    );
  }
}
