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
    if (_controller != null) return;

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
          },
          onPageFinished: (String url) async {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            
            if (_checkPaymentCallback(url)) {
              return;
            }
            
            if (url.contains('vnpayment.vn') && url.contains('Transaction/Confirm')) {
              await _extractPaymentInfoFromPage(url);
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
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));

    _hasLoadedUrl = true;
  }

  Future<void> _extractPaymentInfoFromPage(String url) async {
    if (_controller == null || !mounted) return;

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted || _controller == null) return;

    try {
      final script = '''
        (function() {
          try {
            var urlParams = new URLSearchParams(window.location.search);
            var responseCode = urlParams.get('vnp_ResponseCode');
            var transactionStatus = urlParams.get('vnp_TransactionStatus');
            var orderId = urlParams.get('vnp_TxnRef');
            
            if (!responseCode && !transactionStatus) {
              var hash = window.location.hash;
              if (hash) {
                var hashParams = new URLSearchParams(hash.substring(1));
                responseCode = hashParams.get('vnp_ResponseCode') || responseCode;
                transactionStatus = hashParams.get('vnp_TransactionStatus') || transactionStatus;
                orderId = hashParams.get('vnp_TxnRef') || orderId;
              }
            }
            
            return JSON.stringify({
              responseCode: responseCode,
              transactionStatus: transactionStatus,
              orderId: orderId,
              url: window.location.href
            });
          } catch(e) {
            return JSON.stringify({error: e.toString()});
          }
        })();
      ''';
      
      Object? result;
      try {
        result = await _controller!.runJavaScriptReturningResult(script).timeout(
          const Duration(seconds: 3),
        );
      } catch (e) {
        result = null;
      }
      
      if (result != null && result.toString().isNotEmpty && !result.toString().contains('error')) {
        final resultStr = result.toString().replaceAll("'", '"');
        final jsonMatch = RegExp(r'\{.*\}').firstMatch(resultStr);
        if (jsonMatch != null) {
          final jsonStr = jsonMatch.group(0);
          final uri = Uri.parse('?$jsonStr');
          final responseCode = uri.queryParameters['responseCode'];
          final transactionStatus = uri.queryParameters['transactionStatus'];
          final orderId = uri.queryParameters['orderId'];

          if (responseCode != null || transactionStatus != null) {
            if (mounted) {
              Navigator.of(context).pop({
                'success': responseCode == '00' && transactionStatus == '00',
                'responseCode': responseCode,
                'transactionStatus': transactionStatus,
                'orderId': orderId,
                'fullUrl': uri.queryParameters['url'] ?? url,
              });
            }
            return;
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  bool _checkPaymentCallback(String url) {
    final uri = Uri.parse(url);

    if (url.contains('edtech.nguyenduc.click/student/checkout/result')) {
      final status = uri.queryParameters['status'];
      final txnRef = uri.queryParameters['txnRef'];

      if (status != null && mounted) {
        Navigator.of(context).pop({
          'success': status == 'success',
          'responseCode': status == 'success' ? '00' : null,
          'transactionStatus': status == 'success' ? '00' : null,
          'orderId': txnRef,
          'fullUrl': url,
        });
        return true;
      }
    }

    if (!url.contains('vnpayment.vn') && !url.contains('check-payment-vnpay')) {
      return false;
    }

    final hasVnpayParams = uri.queryParameters.containsKey('vnp_ResponseCode') ||
        uri.queryParameters.containsKey('vnp_TransactionStatus') ||
        uri.queryParameters.containsKey('vnp_TxnRef');

    final isCallbackUrl = url.contains('check-payment-vnpay') ||
        (url.contains('Transaction/Confirm') && hasVnpayParams);

    if (isCallbackUrl && hasVnpayParams) {
      final responseCode = uri.queryParameters['vnp_ResponseCode'];
      final transactionStatus = uri.queryParameters['vnp_TransactionStatus'];
      final orderId = uri.queryParameters['vnp_TxnRef'];

      if (mounted) {
        Navigator.of(context).pop({
          'success': responseCode == '00' && transactionStatus == '00',
          'responseCode': responseCode,
          'transactionStatus': transactionStatus,
          'orderId': orderId,
          'fullUrl': url,
        });
      }
      return true;
    }
    return false;
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
