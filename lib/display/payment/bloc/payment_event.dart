part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

class PaymentUploadPdf extends PaymentEvent {}

class PaymentLoad extends PaymentEvent {}

class PaymentAccept extends PaymentEvent {
  var userData;
  var userBuckets;
  var orderPrice;
  PaymentAccept(
      {required this.userData,
      required this.userBuckets,
      required this.orderPrice});
}
