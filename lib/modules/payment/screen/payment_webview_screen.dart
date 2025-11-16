import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/widgets/template/function_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  static const String routeName = '/paymentWebViewScreen';

  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasLoadedUrl = false;

  void _initializeWebView(String paymentUrl) {
    if (_controller != null) return; // Already initialized

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted && progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            _checkPaymentCallback(url);
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _errorMessage = error.description;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            _checkPaymentCallback(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl)); // Load immediately after init

    _hasLoadedUrl = true;
  }

  void _checkPaymentCallback(String url) {
    // Check if URL contains payment callback
    if (url.contains('check-payment-vnpay')) {
      // Parse URL to get payment result
      final uri = Uri.parse(url);
      final responseCode = uri.queryParameters['vnp_ResponseCode'];
      final transactionStatus = uri.queryParameters['vnp_TransactionStatus'];
      final orderId = uri.queryParameters['vnp_TxnRef'];

      // Close WebView and return result
      if (mounted) {
        Navigator.of(context).pop({
          'success': responseCode == '00' && transactionStatus == '00',
          'responseCode': responseCode,
          'transactionStatus': transactionStatus,
          'orderId': orderId,
          'fullUrl': url,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? paymentUrl = ModalRoute.of(context)?.settings.arguments as String?;

    if (paymentUrl == null || paymentUrl.isEmpty) {
      return FunctionScreenTemplate(
        title: 'payment.title'.tr(),
        isShowBottomButton: false,
        screen: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Payment URL not found',
                style: AppTextStyles.textContent1.copyWith(
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Initialize WebView only once
    if (!_hasLoadedUrl) {
      _initializeWebView(paymentUrl);
    }

    return FunctionScreenTemplate(
      title: 'payment.payment_processing'.tr(),
      isShowBottomButton: false,
      backgroundColor: AppColors.background,
      leadingWidget: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _showCancelConfirmation();
        },
      ),
      screen: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'payment.error_loading'.tr(),
                      style: AppTextStyles.textHeader3.copyWith(
                        color: AppColors.text,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: AppTextStyles.textContent3.copyWith(
                        color: AppColors.color8F959E,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _errorMessage = null;
                              _isLoading = true;
                            });
                            _controller?.loadRequest(Uri.parse(paymentUrl));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          child: Text('payment.retry'.tr()),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                          child: Text('payment.cancel'.tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else if (_controller != null)
            WebViewWidget(controller: _controller!),

          if (_isLoading && _errorMessage == null)
            Container(
              color: AppColors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'payment.loading'.tr(),
                      style: AppTextStyles.textContent2.copyWith(
                        color: AppColors.color8F959E,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'payment.cancel_payment'.tr(),
            style: AppTextStyles.textHeader3.copyWith(
              color: AppColors.text,
            ),
          ),
          content: Text(
            'payment.cancel_payment_message'.tr(),
            style: AppTextStyles.textContent2.copyWith(
              color: AppColors.color8F959E,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'payment.continue'.tr(),
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop({'success': false, 'cancelled': true}); // Close WebView
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              child: Text('payment.cancel'.tr()),
            ),
          ],
        );
      },
    );
  }
}
