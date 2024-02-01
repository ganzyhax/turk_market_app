import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final data;
  const CategoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 200.0,
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color:
                Colors.white, // You can change the background color as needed
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    data['name'],
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    color: Colors
                        .white, // You can change the background color as needed
                  ),
                  child: Image.network(
                    data['image'], // Replace with your image URL
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
