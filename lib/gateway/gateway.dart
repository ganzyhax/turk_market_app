import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  Dio _dio = new Dio();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sortUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String userId = await prefs.getString('id') ?? '';
      if (userId != '') {
        try {
          final CollectionReference<Map<String, dynamic>> users =
              FirebaseFirestore.instance.collection('users');
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              await users.doc(userId).get();

          final CollectionReference<Map<String, dynamic>> collectionProducts =
              FirebaseFirestore.instance.collection('products');

          if (documentSnapshot.exists) {
            var userData = documentSnapshot.data();
            for (var i = 0; i < userData!['bucket'].length; i++) {
              log(userData.toString());
              DocumentSnapshot<Map<String, dynamic>> documentProductsSnapshot =
                  await collectionProducts
                      .doc(userData['bucket'][i]['productId'])
                      .get();

              if (!documentProductsSnapshot.exists) {
                userData['bucket'].removeAt(i);

                await updateDocument('users', userId, userData);
              }
            }
            for (var i = 0; i < userData['liked'].length; i++) {
              DocumentSnapshot<Map<String, dynamic>> documentLikesSnapshot =
                  await collectionProducts.doc(userData['liked'][i]).get();
              if (!documentLikesSnapshot.exists) {
                userData['liked'].removeAt(i);
                await updateDocument('users', userId, userData);
              }
            }
          } else {
            // Document doesn't exist
          }
        } catch (e) {
          // Error handling
          log('Error fetching user data: $e');
        }
      }
    } catch (e) {
      log('Error creating document: ${e.toString()}');
    }
  }

  Future<String> createUser(Map<String, dynamic> userData) async {
    try {
      // Reference to Firestore collection
      var collection = FirebaseFirestore.instance.collection('users');

      final documentReference = collection.doc();

      final docId = documentReference.id;
      userData['id'] = docId;
      await collection.doc(docId).set(userData);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('id', docId);
      await prefs.setBool('isLogged', true);
      print('User document created successfully!');
      return docId;
    } catch (e) {
      print('Error creating document: ${e.toString()}');
      return "null";
    }
  }

  Future<String> deleteUser(String id) async {
    try {
      // Reference to Firestore collection
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(id);
      // Delete the document
      await documentReference.delete();
      print('Document deleted successfully');
      return 'good';
    } catch (e) {
      print('Error creating document: ${e.toString()}');
      return "null";
    }
  }

  Future<bool> isEmailAvailable(String email) async {
    try {
      // Reference to Firestore collection where users are stored
      var collection = FirebaseFirestore.instance.collection('users');

      // Query for users with the provided email
      var querySnapshot =
          await collection.where('login', isEqualTo: email).limit(1).get();

      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // User with the email already exists
        return false;
      } else {
        // Email is available (no user found with this email)
        return true;
      }
    } catch (e) {
      print('Error checking email availability: ${e.toString()}');
      return false; // Assuming false in case of an error
    }
  }

  Future<bool> login(String login, String password) async {
    try {
      // Reference to Firestore collection
      var collection = FirebaseFirestore.instance.collection('users');

      // Query the collection
      var querySnapshot = await collection
          .where('login', isEqualTo: login)
          .where('password', isEqualTo: password)
          .get();

      // Check if the query returns any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming the field is unique and returns only one document
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('id', querySnapshot.docs.first.id);
        await prefs.setBool('isLogged', true);
        return true; // Returns the user ID
      } else {
        return false; // No user found
      }
    } catch (e) {
      print(e.toString());
      return false; // In case of an error
    }
  }

  Future<dynamic> getUsdRub() async {
    try {
      Response response =
          await _dio.get('https://open.er-api.com/v6/latest/USD');

      var curr = double.parse(response.data['rates']['RUB'].toString());
      double currency = double.parse(curr.toStringAsFixed(2));
      return currency;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return;
    }
  }

  Future<bool> isDocumentExists(
      String collectionName, String documentId) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionName);

    final DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();

    return documentSnapshot.exists;
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> createDocumentStream(
      String collection, List documentIds) {
    // Create a stream that listens to changes in each document
    return Stream.fromIterable(documentIds)
        .asyncMap((docId) =>
            FirebaseFirestore.instance.collection(collection).doc(docId).get())
        .toList()
        .asStream();
  }

  Future<String?> uploadPdfToFirebaseStorage(File pdfFile) async {
    try {
      // Get a reference to the storage service
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a reference to the PDF file in Firebase Storage
      String fileName = path.basename(pdfFile.path);
      Reference storageReference = storage.ref().child('pdfs/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(pdfFile);

      // Get the download URL when the upload is complete
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading PDF: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataFromFirestore(
      String collectionName) async {
    List<Map<String, dynamic>> dataList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      dataList = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data: $e');
    }

    return dataList;
  }

  Future<List<DocumentSnapshot>> fetchDataFromFirestoreList(
      String collectionName) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(collectionName);

    try {
      QuerySnapshot querySnapshot = await collection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the list of documents
        return querySnapshot.docs;
      } else {
        print('No documents found in the collection.');
        return [];
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
      throw e;
    }
  }

  Stream<QuerySnapshot> streamData(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  Future<String> addDocumentToFirestoreWithId(
      String collection, var data) async {
    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Add the document to Firestore with an automatically generated document ID
      DocumentReference documentReference =
          await firestore.collection(collection).add(data);

      // Get the automatically generated document ID
      String documentId = documentReference.id;

      // Update the document with the field 'id' containing the document ID
      await documentReference.update({
        'id': documentId,
      });

      print('Document added to Firestore with ID: $documentId');
      return documentId;
    } catch (error) {
      print('Error adding document to Firestore: $error');
      return null.toString();
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocumentById(
      String collection, String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection(collection)
              .doc(documentId)
              .get();

      if (documentSnapshot.exists) {
        return documentSnapshot;
      } else {
        print('Document does not exist');
        return null; // Return null for non-existent documents
      }
    } catch (e) {
      print('Error getting document: $e');
      return null; // Return null in case of an error
    }
  }

  Future<void> updateDocument(String collection, String documentId,
      Map<String, dynamic> dataToUpdate) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(collection);

      // Update the document with the specified data
      await collectionReference.doc(documentId).update(dataToUpdate);

      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }
}
