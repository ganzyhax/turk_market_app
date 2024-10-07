import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      List<String> rates = [];
      bool isRated = false;
      double localRate = 0.0;
      if (event is ProductLoad) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        rates = prefs.getStringList('rates') ?? [];

        emit(ProductLoaded(
            rates: rates, isRated: isRated, localRate: localRate));
      }
      if (event is ProductRateAdd) {
        print('done');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        rates = prefs.getStringList('rates') ?? [];
        rates.add(event.productId + '|' + event.rate);
        await prefs.setStringList('rates', rates);
        CollectionReference collection =
            FirebaseFirestore.instance.collection('products');
        DocumentReference documentReference = collection.doc(event.productId);

        DocumentSnapshot documentSnapshot = await documentReference.get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          if (data.containsKey('rate')) {
            // Field exists, do something with the field value
            var fieldValue = data['rate'];
            fieldValue.add(event.rate);
            await collection
                .doc(event.productId)
                .set({'rate': fieldValue}, SetOptions(merge: true)).catchError(
                    (error) => print("Failed to update or add field: $error"));
            // Perform your action with fieldValue here
          } else {
            // Field does not exist
            await collection.doc(event.productId).set({
              'rate': [event.rate]
            }, SetOptions(merge: true)).catchError(
                (error) => print("Failed to update or add field: $error"));
            // Handle the case where the field doesn't exist
          }
        } else {
          // Document does not exist
          print("Document does not exist.");
          // Handle
          //the case where the document doesn't exist
        }
        emit(ProductLoaded(
            rates: rates, isRated: isRated, localRate: localRate));
      }
      if (event is ProductSetLocalRate) {
        isRated = true;
        localRate = event.rate;
        emit(ProductLoaded(
            rates: rates, isRated: isRated, localRate: localRate));
      }
      if (event is ProductSetIsRated) {
        isRated = event.isRated;
        emit(ProductLoaded(
            rates: rates, isRated: isRated, localRate: localRate));
      }
    });
  }
}
