part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

class CartLoaded extends CartState {
  int totalPrice = 0;
  CartLoaded({required this.totalPrice});
}

class CartLoading extends CartState {}
