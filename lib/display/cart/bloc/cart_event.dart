part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class CartLoad extends CartEvent {}

class CartAddProduct extends CartEvent {}

class CartMakeLoading extends CartEvent {}
