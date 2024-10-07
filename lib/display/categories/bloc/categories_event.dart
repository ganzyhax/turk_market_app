part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {}

class CategoriesLoad extends CategoriesEvent {}

class CategoriesChooseIndexSubCategory extends CategoriesEvent {
  int index;
  CategoriesChooseIndexSubCategory({required this.index});
}

class CategoriesSetSelectedCategory extends CategoriesEvent {
  String category;
  String mainCategory;
  CategoriesSetSelectedCategory(
      {required this.category, required this.mainCategory});
}
