import 'package:ed_tech/core/constants/api_path.dart';
import 'package:ed_tech/data/api_client.dart';
import 'package:ed_tech/data/models/request_method.dart';
import 'package:ed_tech/modules/payment/model/payment_request.dart';
import 'package:ed_tech/modules/payment/model/payment_response.dart';
import 'package:ed_tech/modules/payment/model/my_payments_model.dart';
import 'package:ed_tech/modules/payment/model/invoice_detail_model.dart';

class PaymentRepo {
  final ApiClient apiClient;

  PaymentRepo({required this.apiClient});

  Future<PaymentResponse> createPayment(PaymentRequest request) async {
    final res = await apiClient.fetch(
      ApiPath.createPayment,
      RequestMethod.post,
      rawData: request.toJson(),
    );

    if (res.code != 201 && res.code != 200) {
      throw res.message;
    }

    return PaymentResponse.fromJson(res.json);
  }

  Future<MyPaymentsResponse> getMyPayments() async {
    final res = await apiClient.fetch(ApiPath.myPayments, RequestMethod.get);

    if (res.code != 200) {
      throw res.message;
    }

    return MyPaymentsResponse.fromJson(res.json);
  }

  Future<InvoiceDetailResponse> getPaymentDetail({
    required String paymentId,
  }) async {
    final res = await apiClient.fetch(
      '${ApiPath.myPayments}/$paymentId',
      RequestMethod.get,
    );

    if (res.code != 200) {
      throw res.message;
    }

    return InvoiceDetailResponse.fromJson(res.json);
  }
}
