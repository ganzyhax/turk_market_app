part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded();
}
