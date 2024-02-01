import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/models/product.dart';

class ProductInfo extends StatelessWidget {
  final product;
  final double curr;
  const ProductInfo({super.key, required this.product, required this.curr});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product['name'],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "\$${product['price']}",
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "${(int.parse(product['price'].toString()) * curr).toInt().toString()} руб",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
