part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class ProductLoad extends ProductsEvent {}

class ProductsSearhCategory extends ProductsEvent {
  final String category;

  ProductsSearhCategory({required this.category});
}

class ProductsSearhSubCategory extends ProductsEvent {
  final String subCategory;

  ProductsSearhSubCategory({required this.subCategory});
}

class ProductsSearhSex extends ProductsEvent {
  final String sex;

  ProductsSearhSex({required this.sex});
}

class ProductsSearhInput extends ProductsEvent {
  final String input;

  ProductsSearhInput({required this.input});
}

class ProductsSearhBrand extends ProductsEvent {
  final String brand;

  ProductsSearhBrand({required this.brand});
}

class ProductsSearchFilter extends ProductsEvent {
  String category = '';
  String subCategory = '';
  String subsubCategory = '';
  List colors = [];
  List sizes = [];
  List brands = [];
  int minPrice = 0;
  int maxPrice = 0;
  ProductsSearchFilter(
      {required this.category,
      required this.subCategory,
      required this.subsubCategory,
      required this.colors,
      required this.sizes,
      required this.brands,
      required this.minPrice,
      required this.maxPrice});
}
