import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 16.0),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.black, // Customize the background color
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
