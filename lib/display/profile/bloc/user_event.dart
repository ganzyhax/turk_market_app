part of 'user_bloc.dart';

sealed class UserEvent {}

class UserLoad extends UserEvent {}

class UserLikeProduct extends UserEvent {
  String id;
  UserLikeProduct({required this.id});
}

class UserDeleteBucket extends UserEvent {
  int index;
  UserDeleteBucket({required this.index});
}

class UserAdressAdd extends UserEvent {
  var name;
  var city;
  var street;
  var phone;
  var postcode;
  var country;
  UserAdressAdd(
      {required this.city,
      required this.country,
      required this.name,
      required this.phone,
      required this.postcode,
      required this.street});
}

class UserAddBucket extends UserEvent {
  var color;
  var count;
  var id;
  var size;
  UserAddBucket(
      {required this.color,
      required this.count,
      required this.id,
      required this.size});
}

class UserSetTotalSum extends UserEvent {
  var sum;
  UserSetTotalSum({required this.sum});
}

class UserAdressDelete extends UserEvent {
  var index;
  UserAdressDelete({required this.index});
}

class UserAdressChoose extends UserEvent {
  var index;
  UserAdressChoose({required this.index});
}

class UserBucketFinish extends UserEvent {}
