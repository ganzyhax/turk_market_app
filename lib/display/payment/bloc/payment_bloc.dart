import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/gateway/gateway.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(BuildContext context) : super(PaymentInitial()) {
    File? _pickedPdf;
    String? _downloadURL = '';
    bool loadingUpload = false;
    on<PaymentEvent>((event, emit) async {
      if (event is PaymentLoad) {
        emit(
            PaymentLoaded(urlPdf: _downloadURL!, loadingUpload: loadingUpload));
      }
      if (event is PaymentUploadPdf) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null) {
          _pickedPdf = File(result.files.single.path!);
          print(_downloadURL.toString() + 'here'.toString());
          loadingUpload = true;
          emit(PaymentLoaded(
              urlPdf: _downloadURL!, loadingUpload: loadingUpload));

          _downloadURL =
              await FirestoreService().uploadPdfToFirebaseStorage(_pickedPdf!);
          if (_downloadURL != '') {
            loadingUpload = false;
          }
          emit(PaymentLoaded(
              urlPdf: _downloadURL!, loadingUpload: loadingUpload));
        } else {
          emit(PaymentLoaded(
              urlPdf: _downloadURL!, loadingUpload: loadingUpload));
        }
      }
      if (event is PaymentAccept) {
        String orderId = '';
        var productList = [];
        for (var i = 0; i < event.userBuckets.length; i++) {
          var product = event.userBuckets[i];

          var data = await FirestoreService()
              .getDocumentById('products', product['productId']);
          var productEdit = data!.data();
          for (var c = 0; c < productEdit!['colors'].length; c++) {
            if (productEdit['colors'][c]['colorName'] == product['color']) {
              for (var s = 0;
                  s < productEdit['colors'][c]['colorSizes'].length;
                  s++) {
                if (productEdit['colors'][c]['colorSizes'][s] ==
                    product['size']) {
                  if (productEdit['colors'][c]['sizesCount'][s] ==
                      product['count'].toString()) {
                    productEdit['colors'][c]['colorSizes'].removeAt(s);
                    productEdit['colors'][c]['sizesCount'].removeAt(s);
                  } else {
                    int sizeCount = int.parse(productEdit['colors'][c]
                                ['sizesCount'][s]
                            .toString()) -
                        int.parse(product['count'].toString());
                    productEdit['colors'][c]['sizesCount'][s] =
                        sizeCount.toString();
                    print(sizeCount);
                  }
                }
              }
            }
          }
          await FirestoreService()
              .updateDocument('products', product['productId'], productEdit);

          productList.add(product);
        }
        DateTime now = DateTime.now();

        orderId =
            await FirestoreService().addDocumentToFirestoreWithId('orders', {
          'status': 'inprocess',
          'productData': productList,
          'userData': event.userData,
          'checkPdf': _downloadURL,
          'createdAt': now,
          'orderPrice': event.orderPrice
        });
        _pickedPdf = null;
        _downloadURL = '';

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = await prefs.getString('id') ?? '';
        DocumentSnapshot<Map<String, dynamic>>? document =
            await FirestoreService().getDocumentById('users', id);
        Map<String, dynamic> data;
        if (document != null && document.exists) {
          data = document.data()!;
          data['bucket'] = [];
          data['orders'].add(orderId);

          await FirestoreService().updateDocument(
            'users',
            id,
            data,
          );
        }

        emit(PaymentSuccess());
      }
    });
  }
}
