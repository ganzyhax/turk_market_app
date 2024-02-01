part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoaded extends UserState {
  List userLikes = [];
  List userOrders = [];
  List userBuckets = [];
  List listBucketId = [];
  List userAdresses = [];
  int selectedAdress = 0;
  int totalSum = 0;
  double currency;
  String userId;
  UserLoaded(
      {required this.userLikes,
      required this.selectedAdress,
      required this.userId,
      required this.userOrders,
      required this.currency,
      required this.userAdresses,
      required this.totalSum,
      required this.listBucketId,
      required this.userBuckets});
}
