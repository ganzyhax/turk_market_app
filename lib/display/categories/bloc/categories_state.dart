part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoaded extends CategoriesState {
  var data;
  int selectedSub;
  String category;
  String mainCategory;

  CategoriesLoaded(
      {required this.data,
      required this.selectedSub,
      required this.category,
      required this.mainCategory});
}
