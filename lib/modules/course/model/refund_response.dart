class RefundResponse {
  final int? status;
  final String? message;
  final RefundData? data;

  RefundResponse({
    this.status,
    this.message,
    this.data,
  });

  factory RefundResponse.fromJson(Map<String, dynamic> json) {
    return RefundResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : RefundData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class RefundData {
  final bool? success;
  final String? message;
  final RefundDetail? data;

  RefundData({
    this.success,
    this.message,
    this.data,
  });

  factory RefundData.fromJson(Map<String, dynamic> json) {
    return RefundData(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : RefundDetail.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class RefundDetail {
  final String? refundId;
  final String? vnpRequestId;
  final String? amount;
  final String? status;
  final String? reason;

  RefundDetail({
    this.refundId,
    this.vnpRequestId,
    this.amount,
    this.status,
    this.reason,
  });

  factory RefundDetail.fromJson(Map<String, dynamic> json) {
    return RefundDetail(
      refundId: json['refundId'] as String?,
      vnpRequestId: json['vnpRequestId'] as String?,
      amount: json['amount'] as String?,
      status: json['status'] as String?,
      reason: json['reason'] as String?,
    );
  }
}
