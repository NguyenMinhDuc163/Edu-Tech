import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/course_cubit.dart';

class CourseCancellationScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  final int daysLeftToCancel;

  const CourseCancellationScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.daysLeftToCancel,
  });

  @override
  State<CourseCancellationScreen> createState() =>
      _CourseCancellationScreenState();
}

class _CourseCancellationScreenState extends State<CourseCancellationScreen> {
  bool _isLoading = false;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'course.cancel_confirmation'.tr(),
          style: AppTextStyles.appbarTitle,
        ),
      ),
      body: BlocListener<CourseCubit, CourseState>(
        listener: (context, state) {
          if (state is RefundRequestSuccess) {
            setState(() {
              _isLoading = false;
            });
            _showSuccessDialog(context, state.message);
          } else if (state is RefundRequestError) {
            setState(() {
              _isLoading = false;
            });
            _showErrorDialog(context, state.message);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.colorFFEBF0,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.rustyRed.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.rustyRed,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.courseTitle,
                                style: AppTextStyles.textHeader3.copyWith(
                                  color: AppColors.rustyRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'course.days_left_to_cancel'
                              .tr()
                              .replaceAll('{days}', widget.daysLeftToCancel.toString()),
                          style: AppTextStyles.textContent2.copyWith(
                            color: AppColors.rustyRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'course.refund_policy'.tr(),
                    content: 'course.refund_info'.tr(),
                    iconColor: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    icon: Icons.warning_amber_rounded,
                    title: 'course.cancellation_terms'.tr(),
                    iconColor: AppColors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletPoint('course.terms_point_1'.tr()),
                        const SizedBox(height: 8),
                        _buildBulletPoint('course.terms_point_2'.tr()),
                        const SizedBox(height: 8),
                        _buildBulletPoint('course.terms_point_3'.tr()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    icon: Icons.check_circle_outline,
                    title: 'course.cancellation_commitment'.tr(),
                    content: 'course.commitment_info'.tr(),
                    iconColor: AppColors.limeGreen,
                  ),
                  const SizedBox(height: 20),
                  _buildReasonInputSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowBlack15,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'course.back'.tr(),
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleCancelCourse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'course.confirm_refund'.tr(),
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: AppColors.barrier,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'course.cancelling_course'.tr(),
                          style: AppTextStyles.textContent1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    String? content,
    Widget? child,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.silverGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.textHeader3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              style: AppTextStyles.textContent2.copyWith(
                color: AppColors.coolGray,
                height: 1.5,
              ),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.textContent2.copyWith(
              color: AppColors.coolGray,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonInputSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.silverGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.edit_note,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'course.cancel_reason_title'.tr(),
                style: AppTextStyles.textHeader3,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            maxLength: 200,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'course.cancel_reason_hint'.tr(),
              hintStyle: AppTextStyles.textContent2.copyWith(
                color: AppColors.color8F959E,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.lightGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.lightGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              counterStyle: AppTextStyles.textContent3.copyWith(
                color: AppColors.color8F959E,
              ),
            ),
            style: AppTextStyles.textContent2,
          ),
        ],
      ),
    );
  }

  void _handleCancelCourse() {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      _showErrorDialog(context, 'course.please_enter_reason'.tr());
      return;
    }

    setState(() {
      _isLoading = true;
    });
    context.read<CourseCubit>().createRefundRequest(widget.courseId, reason);
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 28),
            const SizedBox(width: 12),
            Text('course.success'.tr(), style: AppTextStyles.textHeader3),
          ],
        ),
        content: Text(message, style: AppTextStyles.textContent2),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('course.close'.tr(), style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 28),
            const SizedBox(width: 12),
            Text('course.error'.tr(), style: AppTextStyles.textHeader3),
          ],
        ),
        content: Text(message, style: AppTextStyles.textContent2),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('course.close'.tr(), style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
