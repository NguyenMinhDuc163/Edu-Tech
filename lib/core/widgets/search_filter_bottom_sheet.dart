import 'package:flutter/material.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  final List<String> categories;
  final List<String> durations;
  final double minPrice;
  final double maxPrice;
  final List<String> selectedCategories;
  final List<String> selectedDurations;
  final double selectedMinPrice;
  final double selectedMaxPrice;
  final Function(
    List<String> categories,
    List<String> durations,
    double minPrice,
    double maxPrice,
  )
  onApplyFilter;
  final VoidCallback? onClearFilter;

  const SearchFilterBottomSheet({
    super.key,
    required this.categories,
    required this.durations,
    required this.minPrice,
    required this.maxPrice,
    required this.selectedCategories,
    required this.selectedDurations,
    required this.selectedMinPrice,
    required this.selectedMaxPrice,
    required this.onApplyFilter,
    this.onClearFilter,
  });

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late List<String> _selectedCategories;
  late List<String> _selectedDurations;
  late double _currentMinPrice;
  late double _currentMaxPrice;

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
    _selectedDurations = List.from(widget.selectedDurations);
    _currentMinPrice = widget.selectedMinPrice;
    _currentMaxPrice = widget.selectedMaxPrice;
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _toggleDuration(String duration) {
    setState(() {
      if (_selectedDurations.contains(duration)) {
        _selectedDurations.remove(duration);
      } else {
        _selectedDurations.add(duration);
      }
    });
  }

  void _onPriceRangeChanged(double min, double max) {
    setState(() {
      _currentMinPrice = min;
      _currentMaxPrice = max;
    });
  }

  void _applyFilter() {
    widget.onApplyFilter(
      _selectedCategories,
      _selectedDurations,
      _currentMinPrice,
      _currentMaxPrice,
    );
    Navigator.of(context).pop();
  }

  void _clearFilter() {
    setState(() {
      _selectedCategories.clear();
      _selectedDurations.clear();
      _currentMinPrice = widget.minPrice;
      _currentMaxPrice = widget.maxPrice;
    });
    if (widget.onClearFilter != null) {
      widget.onClearFilter!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.close, color: AppColors.text),
                Text(
                  'Search Filter',
                  style: AppTextStyles.textHeader3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 24), // Để cân bằng với icon close
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories Section
                _buildSectionTitle('Categories'),
                const SizedBox(height: 12),
                _buildCategoryTags(),
                const SizedBox(height: 24),

                // Price Section
                _buildSectionTitle('Price'),
                const SizedBox(height: 12),
                _buildPriceRangeSlider(),
                const SizedBox(height: 24),

                // Duration Section
                _buildSectionTitle('Duration'),
                const SizedBox(height: 12),
                _buildDurationTags(),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _buildClearButton()),
                const SizedBox(width: 12),
                Expanded(child: _buildApplyButton(), flex: 2,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.textContent1.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildCategoryTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          widget.categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return _buildFilterTag(
              category,
              isSelected,
              () => _toggleCategory(category),
            );
          }).toList(),
    );
  }

  Widget _buildDurationTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          widget.durations.map((duration) {
            final isSelected = _selectedDurations.contains(duration);
            return _buildFilterTag(
              duration,
              isSelected,
              () => _toggleDuration(duration),
            );
          }).toList(),
    );
  }

  Widget _buildFilterTag(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.lightGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: AppTextStyles.textContent3.copyWith(
            color: isSelected ? AppColors.white : AppColors.color8F959E,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(_currentMinPrice, _currentMaxPrice),
          min: widget.minPrice,
          max: widget.maxPrice,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.lightGray,
          onChanged: (values) {
            _onPriceRangeChanged(values.start, values.end);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_currentMinPrice.toInt()}',
              style: AppTextStyles.textContent3.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\$${_currentMaxPrice.toInt()}',
              style: AppTextStyles.textContent3.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClearButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: _clearFilter,
        child: Text(
          'Clear',
          style: AppTextStyles.textButton.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: _applyFilter,
        child: Text('Apply Filter', style: AppTextStyles.button),
      ),
    );
  }
}

// Extension để hiển thị bottom sheet
extension SearchFilterBottomSheetExtension on BuildContext {
  void showSearchFilterBottomSheet({
    required List<String> categories,
    required List<String> durations,
    required double minPrice,
    required double maxPrice,
    required List<String> selectedCategories,
    required List<String> selectedDurations,
    required double selectedMinPrice,
    required double selectedMaxPrice,
    required Function(
      List<String> categories,
      List<String> durations,
      double minPrice,
      double maxPrice,
    )
    onApplyFilter,
    VoidCallback? onClearFilter,
  }) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SearchFilterBottomSheet(
            categories: categories,
            durations: durations,
            minPrice: minPrice,
            maxPrice: maxPrice,
            selectedCategories: selectedCategories,
            selectedDurations: selectedDurations,
            selectedMinPrice: selectedMinPrice,
            selectedMaxPrice: selectedMaxPrice,
            onApplyFilter: onApplyFilter,
            onClearFilter: onClearFilter,
          ),
    );
  }
}
