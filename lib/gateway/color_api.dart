import 'package:cloud_firestore/cloud_firestore.dart';

class SingleColorApi {
  final firestore = FirebaseFirestore.instance;
  Future<List<dynamic>> fetchColors() async {
    List<dynamic> currentArray;
    final DocumentReference documentRef =
        firestore.collection('singleColors').doc('IOwdrYABCmCHTx5FkBM1');
    final DocumentSnapshot documentSnapshot = await documentRef.get();
    if (documentSnapshot.exists) {
      currentArray = documentSnapshot.get('colors');
      return currentArray;
    }
    return [];
  }

  Future<void> addSingleColor(
    String valueToAdd,
  ) async {
    try {
      final DocumentReference documentRef =
          firestore.collection('singleColors').doc('IOwdrYABCmCHTx5FkBM1');

      // Get the current data of the document.
      final DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        final List<dynamic> currentArray = documentSnapshot.get('colors');

        if (!currentArray.contains(valueToAdd)) {
          // The string is not in the array, so add it.
          currentArray.add(valueToAdd);

          // Update the document with the modified data.
          await documentRef.update({'colors': currentArray});
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

  Future<void> deleteSingleColor(
    String valueToDelete,
  ) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final DocumentReference documentRef =
          firestore.collection('singleColors').doc('IOwdrYABCmCHTx5FkBM1');

      // Get the current data of the document.
      final DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        final List<dynamic> currentArray = documentSnapshot.get('colors');

        if (currentArray.contains(valueToDelete)) {
          // The string is in the array, so remove it.
          currentArray.remove(valueToDelete);

          // Update the document with the modified data.
          await documentRef.update({'colors': currentArray});
        } else {
          print('String is not in the array and cannot be deleted.');
        }
      } else {
        print('Document not found.');
      }
    } catch (e) {
      print('Error deleting string from array: $e');
    }
  }
}
