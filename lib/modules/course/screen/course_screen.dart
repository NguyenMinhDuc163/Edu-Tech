import 'package:ed_tech/init.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});
  static const String routeName = '/CourseScreen';
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      isShowAppBar: false,
      isShowBottomButton: false,
      screen: Column(
        children: [
          Padding(
            padding: AppPad.h24.add(AppPad.t24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Course', style: AppTextStyles.textHeader2),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.white,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppPad.h24.add(AppPad.v12),
            child: _SearchBar(controller: _searchController),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune, color: AppColors.primary, size: 18),
          ),
        ],
      ),
    );
  }
}
