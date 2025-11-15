class PaymentRequest {
  final String courseId;
  final int amount;

  PaymentRequest({
    required this.courseId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'amount': amount,
    };
  }
}
