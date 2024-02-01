part of 'filter_bloc.dart';

@immutable
sealed class FilterState {}

final class FilterInitial extends FilterState {}

class FilterLoaded extends FilterState {
  String selectedCategory = '';
  String selectedSubCategory = '';
  String selectedSubSubCategory = '';
  int indexSelectedCategory;
  int indexSelectedSubCategory;
  bool isVisibleColors;
  bool isVisibleSizes;
  bool isVisibleBrands;

  List lCategories = [];
  List lSubCategories = [];
  List lSubSubCategories = [];
  List sizes = [];
  List selectedSizes = [];
  List brands = [];
  List selectedBrands = [];
  List colors = [];
  List selectedColors = [];
  FilterLoaded(
      {required this.selectedCategory,
      required this.selectedSubCategory,
      required this.selectedSubSubCategory,
      required this.lCategories,
      required this.isVisibleBrands,
      required this.isVisibleColors,
      required this.isVisibleSizes,
      required this.sizes,
      required this.selectedSizes,
      required this.brands,
      required this.selectedBrands,
      required this.lSubCategories,
      required this.colors,
      required this.selectedColors,
      required this.indexSelectedCategory,
      required this.indexSelectedSubCategory,
      required this.lSubSubCategories});
}

class FilterSearchLoad extends FilterState {
  String category = '';
  String subCategory = '';
  String subsubCategory = '';
  List colors = [];
  List sizes = [];
  List brands = [];
  int minPrice = 0;
  int maxPrice = 0;
  FilterSearchLoad(
      {required this.category,
      required this.subCategory,
      required this.subsubCategory,
      required this.colors,
      required this.sizes,
      required this.brands,
      required this.minPrice,
      required this.maxPrice});
}
