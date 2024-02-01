import 'package:flutter/material.dart';
import 'package:turkmarket_app/widgets/custom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String alertTitle;

  final String buttonText;
  final Function() function;

  CustomAlertDialog({
    required this.function,
    required this.alertTitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        alertTitle,
        style: TextStyle(fontSize: 17),
      ),
      actions: [
        CustomButton(
          function: function,
          title: buttonText,
          fontSize: 17,
        ),
      ],
    );
  }
}
