import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ed_tech/core/widgets/app_gap.dart';
import 'package:ed_tech/modules/reviews/screen/add_review_screen.dart';
import 'package:ed_tech/modules/reviews/widget/review_item_widget.dart';
import 'package:ed_tech/modules/reviews/widget/stars_widget.dart';
import 'package:ed_tech/modules/reviews/bloc/review_cubit.dart';

import '../../../init.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  static const String routeName = '/reviewScreen';
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String? _courseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        final String courseId = args['courseId'] ?? '';
        if (courseId.isNotEmpty) {
          setState(() {
            _courseId = courseId;
          });
          context.read<ReviewCubit>().getReviews(courseId: courseId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      isShowBottomButton: false,
      title: "review.title".tr(),
      screen: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          if (state is ReviewProgress) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ReviewError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  AppGap.h16,
                  Text(
                    state.message,
                    style: AppTextStyles.textContent2.copyWith(color: AppColors.error),
                  ),
                ],
              ),
            );
          }

          if (state is ReviewSuccess) {
            final reviews = state.reviewData.reviews;
            final totalReviews = state.reviewData.pagination?.total ?? reviews.length;
            final double avgRating = reviews.isEmpty
                ? 0.0
                : reviews.map((r) => (r.rating ?? 0).toDouble()).reduce((a, b) => a + b) / reviews.length;

            return SingleChildScrollView(
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
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              AddReviewScreen.routeName,
                              arguments: {'courseId': _courseId},
                            );
                            if (result == true && _courseId != null && mounted) {
                              context.read<ReviewCubit>().getReviews(courseId: _courseId!);
                            }
                          },
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
                  reviews.isEmpty
                      ? Center(
                          child: Padding(
                            padding: AppPad.v40,
                            child: Text(
                              'review.no_reviews'.tr(),
                              style: AppTextStyles.textContent2.copyWith(color: AppColors.coolGray),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Padding(
                              padding: AppPad.h16v8,
                              child: Column(
                                children: [
                                  ReviewItemWidget(review: review),
                                  if (index != reviews.length - 1) AppGap.h10,
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              'review.no_data'.tr(),
              style: AppTextStyles.textContent2.copyWith(color: AppColors.coolGray),
            ),
          );
        },
      ),
    );
  }
}
