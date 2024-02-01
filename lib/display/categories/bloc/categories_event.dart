part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {}

class CategoriesLoad extends CategoriesEvent {}

class CategoriesChooseIndexSubCategory extends CategoriesEvent {
  int index;
  CategoriesChooseIndexSubCategory({required this.index});
}
