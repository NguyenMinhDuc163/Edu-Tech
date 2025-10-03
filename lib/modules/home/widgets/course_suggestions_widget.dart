import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/init.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseSuggestionsWidget extends StatelessWidget {
  const CourseSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_CourseItem> items = const [
      _CourseItem(
        title: 'UI/UX Fundamentals',
        author: 'Courtney Henry',
        duration: '12h 30m',
        rating: 4.8,
        asset: 'assets/images/intro_step_1.svg',
        color: Color(0xFFEFF4FF),
      ),
      _CourseItem(
        title: 'Illustration Basics',
        author: 'Jenny Wilson',
        duration: '9h 10m',
        rating: 4.6,
        asset: 'assets/images/intro_step_2.svg',
        color: Color(0xFFF6F9FF),
      ),
      _CourseItem(
        title: 'Product Thinking',
        author: 'Jacob Jones',
        duration: '6h 45m',
        rating: 4.7,
        asset: 'assets/images/intro_step_3.svg',
        color: Color(0xFFF4FBFF),
      ),
    ];

    return Padding(
      padding: AppPad.h16v8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recommended for you', style: AppTextStyles.textHeader3),
              TextButton(
                onPressed: () {},
                child: Text('See all', style: AppTextStyles.textButton),
              ),
            ],
          ),
          AppGap.h16,
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _CourseCard(item: items[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseItem {
  final String title;
  final String author;
  final String duration;
  final double rating;
  final String asset;
  final Color color;

  const _CourseItem({
    required this.title,
    required this.author,
    required this.duration,
    required this.rating,
    required this.asset,
    required this.color,
  });
}

class _CourseCard extends StatelessWidget {
  final _CourseItem item;
  const _CourseCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, 0.06),
          ),
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 20,
            color: AppColors.shadowBlack15,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: double.infinity,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            padding: AppPad.a10,
            child: SvgPicture.asset(item.asset, fit: BoxFit.contain),
          ),
          Expanded(
            child: Padding(
              padding: AppPad.h12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.textMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.colorFF7043, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: AppTextStyles.text,
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppColors.coolGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.duration,
                        style: AppTextStyles.text.copyWith(
                          color: AppColors.coolGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.author,
                    style: AppTextStyles.text.copyWith(
                      color: AppColors.coolGray,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
