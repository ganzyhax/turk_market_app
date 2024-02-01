part of 'filter_bloc.dart';

@immutable
sealed class FilterEvent {}

class FilterLoad extends FilterEvent {}

class FilterVisibleColors extends FilterEvent {}

class FilterVisibleSizes extends FilterEvent {}

class FilterVisibleBrands extends FilterEvent {}

class FilterSearch extends FilterEvent {
  String category = '';
  String subCategory = '';
  String subsubCategory = '';
  List colors = [];
  List sizes = [];
  List brands = [];
  int minPrice = 0;
  int maxPrice = 0;
  FilterSearch(
      {required this.category,
      required this.subCategory,
      required this.subsubCategory,
      required this.colors,
      required this.sizes,
      required this.brands,
      required this.minPrice,
      required this.maxPrice});
}

class FilterSelectColors extends FilterEvent {
  String name;
  FilterSelectColors({required this.name});
}

class FilterSelectSizes extends FilterEvent {
  String name;
  FilterSelectSizes({required this.name});
}

class FilterSelectBrands extends FilterEvent {
  String name;
  FilterSelectBrands({required this.name});
}
