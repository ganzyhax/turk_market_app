import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/products/products_screen.dart';

import 'package:turkmarket_app/models/category.dart';
import 'package:turkmarket_app/widgets/product_card.dart';

class RecommendedProducts extends StatelessWidget {
  RecommendedProducts(
      {super.key,
      required this.data,
      required this.currency,
      required this.userLikes});
  final data;
  final currency;
  final userLikes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 265,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(
                height: 265,
                width: 200,
                child: ProductCard(
                  curr: currency,
                  product: data![index],
                  isLiked:
                      (userLikes.contains(data[index]['id']) ? true : false),
                ),
              )
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemCount: data.length,
      ),
    );
  }
}
