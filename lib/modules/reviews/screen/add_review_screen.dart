import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/core/theme/app_colors.dart';
import 'package:ed_tech/core/theme/app_pad.dart';
import 'package:ed_tech/core/theme/app_text_styles.dart';
import 'package:ed_tech/core/widgets/template/function_screen_template.dart';
import 'package:ed_tech/core/widgets/text_input_custom.dart';
import 'package:ed_tech/modules/reviews/widget/stars_widget.dart';
import 'package:ed_tech/modules/reviews/bloc/review_cubit.dart';
import 'package:ed_tech/modules/reviews/model/add_review_request.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});
  static const String routeName = '/addReview';
  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  double _starValue = 5.0;
  String? _courseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _courseId = args['courseId'] ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_courseId == null || _courseId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('review.error_course_id'.tr())),
      );
      return;
    }

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('review.error_title'.tr())),
      );
      return;
    }

    if (contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('review.error_content'.tr())),
      );
      return;
    }

    final request = AddReviewRequest(
      rating: _starValue.toInt(),
      title: titleController.text.trim(),
      content: contentController.text.trim(),
    );

    context.read<ReviewCubit>().addReview(
      courseId: _courseId!,
      request: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, state) {
        if (state is AddReviewSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('review.success_add_review'.tr()),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is AddReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          final isLoading = state is AddReviewProgress;

          return FunctionScreenTemplate(
            title: 'review.title'.tr(),
            titleButtonBottom: "review.submit_review".tr(),
            onClickBottomButton: isLoading ? null : _handleSubmit,
            screen: Padding(
              padding: AppPad.h24v10,
              child: Column(
                spacing: 30,
                children: [
                  TextInputCustom(
                    label: 'review.title_label'.tr(),
                    hintText: 'review.title_hint'.tr(),
                    titleStyle: AppTextStyles.textContent1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: true,
                    controller: titleController,
                  ),
                  TextInputCustom(
                    label: 'review.how_was_your_experience'.tr(),
                    hintText: 'review.describe_your_experience'.tr(),
                    titleStyle: AppTextStyles.textContent1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    fillColor: true,
                    maxLines: 8,
                    controller: contentController,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "review.star".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: AbsorbPointer(
                          absorbing: isLoading,
                          child: SelectableStarsWidget(
                            initialRating: _starValue,
                            starSize: 48.0,
                            onRatingChanged: (rating) {
                              setState(() {
                                _starValue = rating;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          "${_starValue.toInt()}/5",
                          style: AppTextStyles.textContent1.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
