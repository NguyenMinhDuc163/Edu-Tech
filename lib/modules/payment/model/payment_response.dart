class PaymentResponse {
  final int? status;
  final String? message;
  final String? paymentUrl;
  final String? txnRef;

  PaymentResponse({
    this.status,
    this.message,
    this.paymentUrl,
    this.txnRef,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    String? paymentUrl;
    String? txnRef;

    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        final data = json['data'] as Map<String, dynamic>;
        paymentUrl = data['paymentUrl'] as String?;
        txnRef = data['txnRef'] as String?;
      } else if (json['data'] is String) {
        paymentUrl = json['data'] as String;
      }
    }

    return PaymentResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      paymentUrl: paymentUrl,
      txnRef: txnRef,
    );
  }
}
