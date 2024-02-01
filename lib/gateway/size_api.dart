import 'package:cloud_firestore/cloud_firestore.dart';

class SingleSizeApi {
  final firestore = FirebaseFirestore.instance;
  Future<List<dynamic>> fetchSizes() async {
    List<dynamic> currentArray;
    final DocumentReference documentRef =
        firestore.collection('singleSizes').doc('6GecG2heUB2QVh4xY9S2');
    final DocumentSnapshot documentSnapshot = await documentRef.get();
    if (documentSnapshot.exists) {
      currentArray = documentSnapshot.get('sizes');
      return currentArray;
    }
    return [];
  }

  Future<void> addSingleSize(
    String valueToAdd,
  ) async {
    try {
      final DocumentReference documentRef =
          firestore.collection('singleSizes').doc('6GecG2heUB2QVh4xY9S2');

      // Get the current data of the document.
      final DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        final List<dynamic> currentArray = documentSnapshot.get('sizes');

        if (!currentArray.contains(valueToAdd)) {
          // The string is not in the array, so add it.
          currentArray.add(valueToAdd);

          // Update the document with the modified data.
          await documentRef.update({'sizes': currentArray});
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

  Future<void> deleteSingleSize(
    String valueToDelete,
  ) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final DocumentReference documentRef =
          firestore.collection('singleSize').doc('6GecG2heUB2QVh4xY9S2');

      // Get the current data of the document.
      final DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        final List<dynamic> currentArray = documentSnapshot.get('sizes');

        if (currentArray.contains(valueToDelete)) {
          // The string is in the array, so remove it.
          currentArray.remove(valueToDelete);

          // Update the document with the modified data.
          await documentRef.update({'sizes': currentArray});
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
