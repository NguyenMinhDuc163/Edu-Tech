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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.colorFFEBF0,
                child: Icon(Icons.person, color: AppColors.colorFF6905, size: 24),
              ),
              AppGap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            username,
                            style: AppTextStyles.textContent1.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppGap.w8,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.colorFF6905.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 14, color: AppColors.colorFF6905),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: AppTextStyles.textContent3.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.colorFF6905,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppGap.h4,
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 13,
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
            ],
          ),
          AppGap.h12,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: AppTextStyles.textContent2.copyWith(
                color: AppColors.text,
                height: 1.5,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
