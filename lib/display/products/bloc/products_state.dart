part of 'products_bloc.dart';

sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  StreamController<List<DocumentSnapshot>> query;
  List selectedColors = [];
  bool isFilter;
  List selectedSizes = [];
  ProductsLoaded({
    required this.selectedColors,
    required this.selectedSizes,
    required this.query,
    required this.isFilter,
  });
}
