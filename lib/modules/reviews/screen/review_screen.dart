import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/core/constants/mock_data.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/modules/reviews/screen/add_review_screen.dart';
import 'package:ed_tech/modules/reviews/widget/review_item_widget.dart';
import 'package:ed_tech/modules/reviews/widget/stars_widget.dart';

import '../../../init.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  static const String routeName = '/reviewScreen';
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final totalReviews = MockData.reviews.length;
    final double avgRating = MockData.reviews.isEmpty
        ? 0.0
        : MockData.reviews
                .map((r) => r.rating)
                .reduce((a, b) => a + b) /
            MockData.reviews.length;

    return FunctionScreenTemplate(
      isShowBottomButton: false,
      title: "review.title".tr(),
      screen: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: AppPad.h24v10,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$totalReviews ${'review.title'.tr()}",
                          style: AppTextStyles.textContent1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Text(
                              avgRating.toStringAsFixed(1),
                              style: AppTextStyles.textContent2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StarsWidget(rating: avgRating),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          AddReviewScreen.routeName,
                        ),
                    icon: SvgPicture.asset(IconPath.iconModifiy),
                    label: Text(
                      'review.add_review'.tr(),
                      style: AppTextStyles.textContent2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorFF7043,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppGap.h20,
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: MockData.reviews.length,
              itemBuilder: (context, index) {
                final review = MockData.reviews[index];
                return Padding(
                  padding: AppPad.h16v8,
                  child: Column(
                    children: [
                      ReviewItemWidget(reviewModel: review,),
                      if (index != MockData.reviews.length - 1) AppGap.h10,
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


}
