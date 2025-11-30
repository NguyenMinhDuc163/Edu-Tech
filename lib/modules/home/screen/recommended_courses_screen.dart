import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/home/bloc/home_cubit.dart';
import 'package:ed_tech/modules/home/bloc/home_state.dart';
import 'package:ed_tech/modules/home/model/course_response.dart';
import 'package:ed_tech/modules/course/screen/course_detail_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendedCoursesScreen extends StatefulWidget {
  static const String routeName = '/RecommendedCoursesScreen';

  const RecommendedCoursesScreen({super.key});

  @override
  State<RecommendedCoursesScreen> createState() => _RecommendedCoursesScreenState();
}

class _RecommendedCoursesScreenState extends State<RecommendedCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCourseDetail(BuildContext context, DataCourse course) {
    Navigator.pushNamed(
      context,
      CourseDetailScreen.routeName,
      arguments: {
        'courseId': course.courseId ?? '',
        'title': course.title ?? 'course.untitled'.tr(),
        'instructor': course.teacher?.toString() ?? 'course.unknown_teacher'.tr(),
        'price': course.price ?? '0',
        'duration': course.courseDuration?.toString() ?? '0h 0m',
        'imageUrl': course.thumbnailUrl,
        'description': course.description,
      },
    );
  }

  List<DataCourse> _filterCourses(List<DataCourse> courses) {
    if (_searchQuery.isEmpty) return courses;

    return courses.where((course) {
      final title = course.title?.toLowerCase() ?? '';
      final description = course.description?.toLowerCase() ?? '';
      final teacher = course.teacher?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      return title.contains(query) ||
             description.contains(query) ||
             teacher.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      isShowAppBar: true,
      isShowBottomButton: false,
      title: 'home_screen.recommended_for_you'.tr(),
      screen: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is CourseProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseSuccess) {
            final allCourses = state.courses;
            final filteredCourses = _filterCourses(allCourses);

            return Column(
              children: [
                _buildSearchAndFilter(),
                if (filteredCourses.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: AppColors.colorB8B8D2.withAlpha(128),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                              ? 'home_screen.no_courses'.tr()
                              : 'course.no_results_found'.tr(),
                            style: AppTextStyles.textMedium.copyWith(
                              color: AppColors.colorB8B8D2,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                              child: Text(
                                'filter.clear'.tr(),
                                style: AppTextStyles.textButton.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<HomeCubit>().getProduct();
                      },
                      child: _isGridView
                          ? _buildGridView(filteredCourses)
                          : _buildListView(filteredCourses),
                    ),
                  ),
              ],
            );
          }

          if (state is CourseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppColors.colorB8B8D2.withAlpha(128),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: AppPad.h24,
                    child: Text(
                      state.message,
                      style: AppTextStyles.text.copyWith(
                        color: AppColors.colorB8B8D2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().getProduct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: AppPad.h16v12,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            color: Colors.black.withAlpha(13),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.colorF4F3FD,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: AppTextStyles.text,
              decoration: InputDecoration(
                hintText: 'course.search_hint_course'.tr(),
                hintStyle: AppTextStyles.text.copyWith(
                  color: AppColors.colorB8B8D2,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.colorB8B8D2,
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.colorB8B8D2,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 16,
                color: AppColors.colorB8B8D2,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _searchQuery.isEmpty
                      ? 'filter.all_courses'.tr()
                      : 'filter.filtered_results'.tr(),
                  style: AppTextStyles.text.copyWith(
                    fontSize: 13,
                    color: AppColors.colorB8B8D2,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorF4F3FD,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildViewButton(
                      icon: Icons.grid_view_rounded,
                      isActive: _isGridView,
                      onTap: () => setState(() => _isGridView = true),
                    ),
                    _buildViewButton(
                      icon: Icons.list_rounded,
                      isActive: !_isGridView,
                      onTap: () => setState(() => _isGridView = false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? AppColors.white : AppColors.colorB8B8D2,
        ),
      ),
    );
  }

  Widget _buildGridView(List<DataCourse> courses) {
    return GridView.builder(
      padding: AppPad.a16,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return _CourseGridCard(
          course: courses[index],
          onTap: () => _navigateToCourseDetail(context, courses[index]),
        );
      },
    );
  }

  Widget _buildListView(List<DataCourse> courses) {
    return ListView.separated(
      padding: AppPad.a16,
      itemCount: courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _CourseListCard(
          course: courses[index],
          onTap: () => _navigateToCourseDetail(context, courses[index]),
        );
      },
    );
  }
}

class _CourseGridCard extends StatelessWidget {
  final DataCourse course;
  final VoidCallback onTap;

  const _CourseGridCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 8,
              color: Color.fromRGBO(0, 0, 0, 0.08),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: _getColorForCourse(course.categoryId ?? ''),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Builder(
                  builder: (context) {
                    final url = course.thumbnailUrl?.toString() ?? '';
                    if (url.isEmpty) {
                      return Icon(
                        Icons.school_outlined,
                        color: AppColors.colorB8B8D2.withAlpha(128),
                        size: 40,
                      );
                    }
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        url,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.school_outlined,
                            color: AppColors.colorB8B8D2.withAlpha(128),
                            size: 40,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: AppPad.a12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title ?? 'course.untitled'.tr(),
                      style: AppTextStyles.textMedium.copyWith(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.colorFF7043, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          course.rating?.toStringAsFixed(1) ?? '4.5',
                          style: AppTextStyles.text.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: AppColors.coolGray),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            course.courseDuration?.toString() ?? '0h 0m',
                            style: AppTextStyles.text.copyWith(
                              fontSize: 11,
                              color: AppColors.coolGray,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForCourse(String categoryId) {
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

class _CourseListCard extends StatelessWidget {
  final DataCourse course;
  final VoidCallback onTap;

  const _CourseListCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 8,
              color: Color.fromRGBO(0, 0, 0, 0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _getColorForCourse(course.categoryId ?? ''),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Builder(
                builder: (context) {
                  final url = course.thumbnailUrl?.toString() ?? '';
                  if (url.isEmpty) {
                    return Icon(
                      Icons.school_outlined,
                      color: AppColors.colorB8B8D2.withAlpha(128),
                      size: 40,
                    );
                  }
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.network(
                      url,
                      width: 100,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.school_outlined,
                          color: AppColors.colorB8B8D2.withAlpha(128),
                          size: 40,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: AppPad.a12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title ?? 'course.untitled'.tr(),
                          style: AppTextStyles.textMedium.copyWith(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.teacher?.toString() ?? 'course.unknown_teacher'.tr(),
                          style: AppTextStyles.text.copyWith(
                            fontSize: 12,
                            color: AppColors.coolGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.colorFF7043, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          course.rating?.toStringAsFixed(1) ?? '4.5',
                          style: AppTextStyles.text.copyWith(fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.schedule, size: 14, color: AppColors.coolGray),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            course.courseDuration?.toString() ?? '0h 0m',
                            style: AppTextStyles.text.copyWith(
                              fontSize: 11,
                              color: AppColors.coolGray,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForCourse(String categoryId) {
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
