import 'package:ed_tech/init.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/modules/course/widgets/course_card_widget.dart';
import 'package:ed_tech/modules/course/widgets/course_category_tabs_widget.dart';
import 'package:ed_tech/modules/course/widgets/course_list_widget.dart';
import 'package:ed_tech/core/widgets/search_filter_bottom_sheet.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});
  static const String routeName = '/CourseScreen';
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Filter state
  List<String> _selectedCategories = ['Design', 'Coding'];
  List<String> _selectedDurations = ['3-8 Hours'];
  double _selectedMinPrice = 90;
  double _selectedMaxPrice = 200;

  // Filter options
  final List<String> _categories = [
    'Design',
    'Coding',
    'Painting',
    'Music',
    'Visual identity',
    'Mathematics',
  ];
  final List<String> _durations = [
    '3-8 Hours',
    '8-14 Hours',
    '14-20 Hours',
    '20-24 Hours',
    '24-30 Hours',
  ];
  final double _minPrice = 0;
  final double _maxPrice = 500;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    context.showSearchFilterBottomSheet(
      categories: _categories,
      durations: _durations,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      selectedCategories: _selectedCategories,
      selectedDurations: _selectedDurations,
      selectedMinPrice: _selectedMinPrice,
      selectedMaxPrice: _selectedMaxPrice,
      onApplyFilter: (categories, durations, minPrice, maxPrice) {
        setState(() {
          _selectedCategories = categories;
          _selectedDurations = durations;
          _selectedMinPrice = minPrice;
          _selectedMaxPrice = maxPrice;
        });
        // TODO: Apply filter logic here
        print(
          'Applied filter: Categories: $categories, Durations: $durations, Price: \$${minPrice.toInt()} - \$${maxPrice.toInt()}',
        );
      },
      onClearFilter: () {
        setState(() {
          _selectedCategories.clear();
          _selectedDurations.clear();
          _selectedMinPrice = _minPrice;
          _selectedMaxPrice = _maxPrice;
        });
        // TODO: Clear filter logic here
        print('Filter cleared');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _searchController,
                onFilterTap: _showFilterBottomSheet,
              ),
            ),
            const SizedBox(height: 20),
            const CourseCardsCarousel(),
            const CourseCategoryTabsWidget(),
            const SizedBox(height: 20),
            const CourseListWidget(),
            const SizedBox(height: 20), // Thêm padding bottom để tránh bị cắt
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onFilterTap});
  final TextEditingController controller;
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
            child: TextField(
              controller: controller,
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
