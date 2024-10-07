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
    double rate = 0.0;
    try {
      if (product['rate'] != null) {
        var rateList = product['rate'] ?? [];
        if (rateList.length > 1) {
          for (var l = 0; l < rateList.length; l++) {
            rate = rate + double.parse(rateList[l].toString());
          }
          rate = rate / rateList.length;
        } else {
          if (rateList.length == 1) {
            rate = double.parse(rateList[0].toString());
          }
        }
      }
    } catch (e) {}
    print('Final rate ' + rate.toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 220,
              child: Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
        ),
        Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
                Text(
                  rate.toStringAsFixed(1),
                  style: TextStyle(fontSize: 28),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
