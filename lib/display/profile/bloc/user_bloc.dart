import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/gateway/functoins.dart';
import 'package:turkmarket_app/gateway/gateway.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    List userLikes = [];
    List userOrders = [];
    List userBuckets = [];
    List listBucketId = [];
    List userAdresses = [];
    int totalCartSum = 0;
    int selectedAdress = 0;

    double currency = 0.0;
    String userId = '';
    on<UserEvent>((event, emit) async {
      if (event is UserLoad) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = await prefs.getString('id') ?? '';
        currency = await prefs.getDouble('currency') ?? 0.0;

        if (userId != '') {
          DocumentSnapshot<Map<String, dynamic>>? document =
              await FirestoreService().getDocumentById('users', userId);
          if (document != null && document.exists) {
            Map<String, dynamic> data = document.data()!;
            userAdresses = data['adresses'];
            userLikes = data['liked'];
            userOrders = data['orders'];
            userBuckets = data['bucket'];
            for (var i = 0; i < userBuckets.length; i++) {
              // totalCartSum = totalCartSum + (int.parse(userBuckets[i]['price'].toString())* 2);
              listBucketId.add(userBuckets[i]['productId']);
            }
          }
        } else {
          userId = await HelpFunctions().getDeviceId();
          print(userId);
          userLikes = [];
          userOrders = [];
          userBuckets = [];
          listBucketId = [];
          userAdresses = [];
          totalCartSum = 0;
          int selectedAdress = 0;
        }

        emit(UserLoaded(
            userId: userId,
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
      if (event is UserLikeProduct) {
        if (userLikes.contains(event.id)) {
          userLikes.remove(event.id);
        } else {
          userLikes.add(event.id);
        }
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('id').toString();
        var userData =
            await FirestoreService().getDocumentById('users', userId);
        var updatedData = userData!.data();
        updatedData!['liked'] = userLikes;
        await FirestoreService().updateDocument(
          'users',
          userId,
          updatedData,
        );
        emit(UserLoaded(
            userId: userId,
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
      if (event is UserDeleteBucket) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = await prefs.getString('id') ?? '';
        DocumentSnapshot<Map<String, dynamic>>? document =
            await FirestoreService().getDocumentById('users', id);
        Map<String, dynamic> data;
        if (document != null && document.exists) {
          data = document.data()!;
          data['bucket'].removeAt(event.index);

          await FirestoreService().updateDocument(
            'users',
            id,
            data,
          );
          userBuckets = data['bucket'];
          listBucketId.removeAt(event.index);
        }

        emit(UserLoaded(
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userId: userId,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
      if (event is UserAddBucket) {
        addBucket() async {
          userBuckets = [];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          String id = await prefs.getString('id') ?? '';
          DocumentSnapshot<Map<String, dynamic>>? document =
              await FirestoreService().getDocumentById('users', id);
          Map<String, dynamic> data;
          if (document != null && document.exists) {
            data = document.data()!;

            data['bucket'].add({
              'color': event.color,
              'count': event.count,
              'productId': event.id,
              'size': event.size
            });
            listBucketId.add(event.id);
            userBuckets = data['bucket'];
            await FirestoreService().updateDocument(
              'users',
              id,
              data,
            );
          }
        }

        bool mustAdd = true;
        for (var i = 0; i < userBuckets.length; i++) {
          if (userBuckets[i]['productId'] == event.id) {
            if (userBuckets[i]['color'] == event.color) {
              if (userBuckets[i]['size'] == event.size) {
                mustAdd = false;
              }
            }
          }
        }
        if (mustAdd) {
          await addBucket();
        }

        emit(UserLoaded(
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            userId: userId,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
      if (event is UserSetTotalSum) {
        totalCartSum = event.sum;
        emit(UserLoaded(
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userAdresses: userAdresses,
            currency: currency,
            userId: userId,
            userOrders: userOrders,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
      if (event is UserAdressDelete) {
        userAdresses.removeAt(event.index);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = await prefs.getString('id') ?? '';
        DocumentSnapshot<Map<String, dynamic>>? document =
            await FirestoreService().getDocumentById('users', id);
        Map<String, dynamic> data;
        if (document != null && document.exists) {
          data = document.data()!;

          data['adresses'] = userAdresses;

          await FirestoreService().updateDocument(
            'users',
            id,
            data,
          );
        }
        emit(UserLoaded(
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            userId: userId,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }

      if (event is UserAdressAdd) {
        userAdresses.add({
          'name': event.name,
          'city': event.city,
          'street': event.street,
          'phone': event.phone,
          'postcode': event.postcode,
          'country': event.country
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = await prefs.getString('id') ?? '';
        DocumentSnapshot<Map<String, dynamic>>? document =
            await FirestoreService().getDocumentById('users', id);
        Map<String, dynamic> data;
        if (document != null && document.exists) {
          data = document.data()!;

          data['adresses'] = userAdresses;

          await FirestoreService().updateDocument(
            'users',
            id,
            data,
          );
        }
        emit(UserLoaded(
            totalSum: totalCartSum,
            userId: userId,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
      if (event is UserAdressChoose) {
        selectedAdress = event.index;
        emit(UserLoaded(
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userId: userId,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
      if (event is UserBucketFinish) {
        totalCartSum = 0;
        listBucketId = [];
        userBuckets = [];

        emit(UserLoaded(
            totalSum: totalCartSum,
            listBucketId: listBucketId,
            userLikes: userLikes,
            userAdresses: userAdresses,
            currency: currency,
            userOrders: userOrders,
            userId: userId,
            selectedAdress: selectedAdress,
            userBuckets: userBuckets));
      }
    });
  }
}
