import 'package:ed_tech/modules/payment/model/my_payments_model.dart';
import 'package:ed_tech/modules/payment/model/invoice_detail_model.dart';

sealed class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentProgress extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentUrl;

  PaymentSuccess({required this.paymentUrl});
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError({required this.message});
}

class MyPaymentsInitial extends PaymentState {}

class MyPaymentsProgress extends PaymentState {}

class MyPaymentsSuccess extends PaymentState {
  final MyPaymentsResponse data;

  MyPaymentsSuccess({required this.data});
}

class MyPaymentsError extends PaymentState {
  final String message;

  MyPaymentsError({required this.message});
}

class InvoiceDetailInitial extends PaymentState {}

class InvoiceDetailProgress extends PaymentState {}

class InvoiceDetailSuccess extends PaymentState {
  final InvoiceDetailResponse data;

  InvoiceDetailSuccess({required this.data});
}

class InvoiceDetailError extends PaymentState {
  final String message;

  InvoiceDetailError({required this.message});
}
