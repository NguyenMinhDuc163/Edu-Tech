import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/modules/reviews/model/review_response.dart';
import 'package:ed_tech/modules/reviews/widget/stars_widget.dart';

import '../../../init.dart';

class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({super.key, required this.review});
  final Review review;
  @override
  Widget build(BuildContext context) {
    final username = review.user?.username ?? 'Anonymous';
    final rating = (review.rating ?? 0).toDouble();
    final content = review.content ?? '';
    final createdAt = review.createdAt ?? '';

    String formattedDate = '';
    if (createdAt.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(createdAt);
        formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      } catch (e) {
        formattedDate = createdAt;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.coolGray.withOpacity(0.3),
              child: Icon(Icons.person, color: AppColors.coolGray),
            ),
            AppGap.w12,
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: AppTextStyles.textContent2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AppGap.h4,
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.coolGray,
                            ),
                            AppGap.w4,
                            Text(
                              formattedDate,
                              style: AppTextStyles.textContent3.copyWith(
                                color: AppColors.coolGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppTextStyles.textContent2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppGap.w4,
                          Text(
                            'review.rating'.tr(),
                            style: AppTextStyles.textContent3.copyWith(
                              color: AppColors.coolGray,
                            ),
                          ),
                        ],
                      ),
                      AppGap.h4,
                      StarsWidget(rating: rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          content,
          style: AppTextStyles.textContent3.copyWith(color: AppColors.coolGray),
        ),
      ],
    );
  }
}
