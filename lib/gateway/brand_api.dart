import 'package:cloud_firestore/cloud_firestore.dart';

class BrandApi {
  final firestore = FirebaseFirestore.instance;
  Future<List<dynamic>> fetchBrands() async {
    List<dynamic> currentArray;
    final DocumentReference documentRef =
        firestore.collection('brands').doc('5HZrPZiS5VXl5bbv5nsq');
    final DocumentSnapshot documentSnapshot = await documentRef.get();
    if (documentSnapshot.exists) {
      currentArray = documentSnapshot.get('brands');
      return currentArray;
    }
    return [];
  }

  Future<void> addBrand(
    String valueToAdd,
    String image,
  ) async {
    try {
      final DocumentReference documentRef =
          firestore.collection('brands').doc('5HZrPZiS5VXl5bbv5nsq');

      // Get the current data of the document.
      final DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        final List<dynamic> currentArray = documentSnapshot.get('brands');
        final Map<int, dynamic> currentMap = Map.from(currentArray.asMap());
        bool brandExists = currentMap.values.contains(valueToAdd);
        if (!brandExists) {
          // The string is not in the array, so add it.
          currentArray.add({'brandName': valueToAdd, 'brandImage': image});

          // Update the document with the modified data.
          await documentRef.update({'brands': currentArray});
        } else {
          print('String is already in the array and will not be added.');
        }
      } else {
        print('Document not found.');
      }
    } catch (e) {
      print('Error adding string to array: $e');
    }
  }

  Future<void> changeImage(String image, int index) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final DocumentReference documentRef =
          firestore.collection('brands').doc('5HZrPZiS5VXl5bbv5nsq');

      // Get the current data of the document.
      final DocumentSnapshot documentSnapshot = await documentRef.get();
      if (documentSnapshot.exists) {
        final List<dynamic> currentArray = documentSnapshot.get('brands');
        currentArray[index]['brandImage'] = image;
        await documentRef.update({'brands': currentArray});
      }
    } catch (e) {}
  }

  Future<void> deleteBrand(
    int index,
  ) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final DocumentReference documentRef =
          firestore.collection('brands').doc('5HZrPZiS5VXl5bbv5nsq');

      // Get the current data of the document.
      final DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        final List<dynamic> currentArray = documentSnapshot.get('brands');

        // The string is in the array, so remove it.
        currentArray.removeAt(index);

        // Update the document with the modified data.
        await documentRef.update({'brands': currentArray});
      } else {
        print('Document not found.');
      }
    } catch (e) {
      print('Error deleting string from array: $e');
    }
  }
}
