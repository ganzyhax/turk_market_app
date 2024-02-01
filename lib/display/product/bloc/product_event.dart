part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class ProductLoad extends ProductEvent {}

class ProductChooseColor extends ProductEvent {
  String name;
  ProductChooseColor({required this.name});
}

class ProductChooseSize extends ProductEvent {
  String name;
  ProductChooseSize({required this.name});
}

class ProductAddFavourite extends ProductEvent {
  String id;
  ProductAddFavourite({required this.id});
}
