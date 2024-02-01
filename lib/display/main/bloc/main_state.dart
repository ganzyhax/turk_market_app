part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

class MainLoaded extends MainState {
  int index = 0;
  List screens = [];
  MainLoaded({required this.index, required this.screens});
}
