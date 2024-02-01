import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/display/product/product_screen.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/products/products_screen.dart';

import 'package:turkmarket_app/models/category.dart';

class Categories extends StatelessWidget {
  Categories({
    super.key,
    required this.data,
  });
  final data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              BlocProvider.of<ProductsBloc>(context)
                ..add(ProductsSearhCategory(
                    category: data[0]['subCategories'][index]['name']));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsScreen()),
              );
            },
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        data[0]['subCategories'][index]['image'],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data[0]['subCategories'][index]['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemCount: data[0]['subCategories'].length,
      ),
    );
  }
}
