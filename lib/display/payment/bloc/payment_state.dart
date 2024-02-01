part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

class PaymentLoaded extends PaymentState {
  String urlPdf = '';
  bool loadingUpload;
  PaymentLoaded({required this.urlPdf, required this.loadingUpload});
}

class PaymentLoadingUpload extends PaymentState {}

class PaymentSuccess extends PaymentState {}
