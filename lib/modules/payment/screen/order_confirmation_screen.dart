import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/data/services/user_service.dart';
import 'package:ed_tech/modules/payment/bloc/payment_cubit.dart';
import 'package:ed_tech/modules/payment/bloc/payment_state.dart';
import 'package:ed_tech/modules/payment/screen/payment_webview_screen.dart';
import 'package:ed_tech/init.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderConfirmationScreen extends StatelessWidget {
  static const String routeName = '/orderConfirmationScreen';

  const OrderConfirmationScreen({super.key});

  Future<void> _openPaymentWebView(BuildContext context, String paymentUrl) async {
    final result = await Navigator.of(
      context,
    ).pushNamed(PaymentWebViewScreen.routeName, arguments: paymentUrl);

    if (result != null && result is Map<String, dynamic>) {
      if (!context.mounted) return;

      final bool success = result['success'] ?? false;
      final bool cancelled = result['cancelled'] ?? false;

      if (cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('payment.payment_cancelled'.tr()),
            backgroundColor: AppColors.color8F959E,
          ),
        );

        context.read<PaymentCubit>().reset();
      } else if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('payment.payment_success'.tr()),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('payment.payment_failed'.tr()), backgroundColor: AppColors.error),
        );

        context.read<PaymentCubit>().reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(body: Center(child: Text('No order data available')));
    }

    final String courseId = args['courseId'] ?? '';
    final String courseTitle = args['title'] ?? 'Untitled Course';
    final String instructor = args['instructor'] ?? 'Unknown';
    final String price = args['price'] ?? '0';
    final String duration = args['duration'] ?? '0h 0m';
    final String? thumbnailUrl = args['thumbnailUrl'];

    final userData = UserService.instance.userData;

    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          _openPaymentWebView(context, state.paymentUrl);
        } else if (state is PaymentError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        }
      },
      child: FunctionScreenTemplate(
        title: 'payment.order_confirmation'.tr(),
        isShowBottomButton: false,
        backgroundColor: AppColors.background,
        screen: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, paymentState) {
            final isLoading = paymentState is PaymentProgress;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: AppPad.h24v12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary.withAlpha(26), AppColors.colorFFEBF0],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(51),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.shopping_cart_checkout_rounded,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'payment.order_confirmation'.tr(),
                              style: AppTextStyles.textHeader3.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Review your order details before proceeding',
                              style: AppTextStyles.textContent3.copyWith(
                                color: AppColors.color8F959E,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: AppPad.h24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'payment.course_details'.tr(),
                                  style: AppTextStyles.textHeader3.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            _CourseInfoCard(
                              thumbnailUrl: thumbnailUrl,
                              courseTitle: courseTitle,
                              instructor: instructor,
                              duration: duration,
                              price: price,
                            ),

                            const SizedBox(height: 32),

                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'payment.buyer_information'.tr(),
                                  style: AppTextStyles.textHeader3.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            _BuyerInfoCard(userData: userData),

                            const SizedBox(height: 32),

                            _PriceSummary(price: price),

                            const SizedBox(height: 24),

                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [AppColors.primary, AppColors.color0961F5],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(102),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed:
                                    isLoading
                                        ? null
                                        : () {
                                          final numPrice = double.tryParse(price) ?? 0;
                                          final amountInVND = (numPrice * 1).toInt();

                                          context.read<PaymentCubit>().createPayment(
                                            courseId: courseId,
                                            amount: amountInVND,
                                          );
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  disabledBackgroundColor: Colors.transparent,
                                ),
                                child:
                                    isLoading
                                        ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                        : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'payment.proceed_to_payment'.tr(),
                                              style: AppTextStyles.button.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: AppColors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CourseInfoCard extends StatelessWidget {
  final String? thumbnailUrl;
  final String courseTitle;
  final String instructor;
  final String duration;
  final String price;

  const _CourseInfoCard({
    required this.thumbnailUrl,
    required this.courseTitle,
    required this.instructor,
    required this.duration,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child:
                thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                    ? Image.network(
                      thumbnailUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.colorFFEBF0, AppColors.primary.withAlpha(77)],
                            ),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: AppColors.primary,
                            size: 64,
                          ),
                        );
                      },
                    )
                    : Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.colorFFEBF0, AppColors.primary.withAlpha(77)],
                        ),
                      ),
                      child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 64),
                    ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseTitle,
                  style: AppTextStyles.textContent1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.text,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.colorF4F3FD,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(26),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.person_rounded, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          instructor,
                          style: AppTextStyles.textContent3.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.colorFFEBF0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.colorFF6905.withAlpha(26),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: AppColors.colorFF6905,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                duration,
                                style: AppTextStyles.textContent3.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerInfoCard extends StatelessWidget {
  final UserData? userData;

  const _BuyerInfoCard({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            label: 'payment.username'.tr(),
            value: userData?.username ?? 'Guest User',
            icon: Icons.account_circle_rounded,
            iconColor: AppColors.primary,
            iconBgColor: AppColors.primary.withAlpha(26),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.lightGray),
          const SizedBox(height: 16),
          _InfoRow(
            label: 'sign_up.email'.tr(),
            value: userData?.email ?? 'No email',
            icon: Icons.email_rounded,
            iconColor: AppColors.colorFF6905,
            iconBgColor: AppColors.colorFF6905.withAlpha(26),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 24, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.textContent3.copyWith(
                  color: AppColors.color8F959E,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.textContent2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final String price;

  const _PriceSummary({required this.price});

  String _formatPrice(String price) {
    try {
      final numPrice = double.tryParse(price);
      if (numPrice == null) return price;

      final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
      return formatter.format(numPrice);
    } catch (e) {
      return price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.colorFF6905, AppColors.colorFF6905.withAlpha(204)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorFF6905.withAlpha(102),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'payment.total_amount'.tr(),
                      style: AppTextStyles.textContent2.copyWith(
                        color: AppColors.white.withAlpha(230),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _formatPrice(price),
                  style: AppTextStyles.textHeader1.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.white.withAlpha(77), width: 2),
            ),
            child: const Icon(Icons.payments_rounded, color: AppColors.white, size: 40),
          ),
        ],
      ),
    );
  }
}
