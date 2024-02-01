import 'package:flutter/material.dart';

class AdressAdd extends StatelessWidget {
  const AdressAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12, width: 1)),
      padding: EdgeInsets.all(30),
      child: Center(
        child: Icon(
          Icons.add_box_outlined,
          color: Colors.black,
          size: 45,
        ),
      ),
    );
  }
}
