part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoaded extends ProductState {
  List rates;
  bool isRated;
  double localRate;
  ProductLoaded(
      {required this.rates, required this.isRated, required this.localRate});
}
