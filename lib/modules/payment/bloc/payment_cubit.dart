import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ed_tech/modules/payment/bloc/payment_state.dart';
import 'package:ed_tech/modules/payment/model/payment_request.dart';
import 'package:ed_tech/modules/payment/repository/payment_repo.dart';
import 'package:ed_tech/core/error_handling/app_error_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo repo;

  PaymentCubit({required this.repo}) : super(PaymentInitial());

  Future<void> createPayment({
    required String courseId,
    required int amount,
  }) async {
    emit(PaymentProgress());

    try {
      final request = PaymentRequest(courseId: courseId, amount: amount);

      final response = await repo.createPayment(request);

      if (response.paymentUrl != null && response.paymentUrl!.isNotEmpty) {
        emit(PaymentSuccess(paymentUrl: response.paymentUrl!));
      } else {
        emit(PaymentError(message: 'Payment URL not found'));
      }
    } catch (e) {
      emit(PaymentError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future<void> getMyPayments() async {
    emit(MyPaymentsProgress());
    try {
      final response = await repo.getMyPayments();
      emit(MyPaymentsSuccess(data: response));
    } catch (e) {
      emit(MyPaymentsError(message: AppErrorState.getFriendlyErrorString(e)));
    }
  }

  Future<void> getPaymentDetail({required String paymentId}) async {
    emit(InvoiceDetailProgress());
    try {
      final response = await repo.getPaymentDetail(paymentId: paymentId);
      emit(InvoiceDetailSuccess(data: response));
    } catch (e) {
      emit(
        InvoiceDetailError(message: AppErrorState.getFriendlyErrorString(e)),
      );
    }
  }

  void reset() {
    emit(PaymentInitial());
  }
}
