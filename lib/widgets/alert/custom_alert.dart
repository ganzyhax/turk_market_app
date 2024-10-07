import 'package:flutter/material.dart';
import 'package:turkmarket_app/widgets/custom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String alertTitle;

  final String buttonText;
  final String? secondButton;
  final Function() function;

  CustomAlertDialog(
      {required this.function,
      required this.alertTitle,
      required this.buttonText,
      this.secondButton});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        alertTitle,
        style: TextStyle(fontSize: 17),
      ),
      actions: [
        (secondButton != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    function: function,
                    title: buttonText,
                    fontSize: 17,
                  ),
                  CustomButton(
                    function: () {
                      Navigator.pop(context);
                    },
                    title: secondButton.toString(),
                    fontSize: 17,
                  ),
                ],
              )
            : CustomButton(
                function: function,
                title: buttonText,
                fontSize: 17,
              ),
      ],
    );
  }
}
