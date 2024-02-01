import 'package:flutter/material.dart';
import 'package:turkmarket_app/constants.dart';

class CustomButton extends StatelessWidget {
  final Function() function;
  final String title;
  bool isEnable;
  final double? fontSize;
  CustomButton({
    super.key,
    this.fontSize = 21,
    this.isEnable = true,
    required this.function,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isEnable) ? function : () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: (isEnable) ? kPrimaryColor : Colors.amber[100]),
        padding: EdgeInsets.all(12),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
