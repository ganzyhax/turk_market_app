part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

final class MainChangeIndex extends MainEvent {
  int index;
  final bool? isForLog;

  MainChangeIndex({required this.index, this.isForLog});
}

final class MainLoad extends MainEvent {}
