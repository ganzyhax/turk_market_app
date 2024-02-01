part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> query;
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
