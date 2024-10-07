import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/products/products_screen.dart';

import 'package:turkmarket_app/models/category.dart';

class Brands extends StatelessWidget {
  Brands({
    super.key,
    required this.data,
  });
  final data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                  onTap: () {
                    BlocProvider.of<ProductsBloc>(context)
                      ..add(ProductsSearhBrand(
                          brand: data[0]['brands'][index]['brandName']));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductsScreen()),
                    );
                  },
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/no_image.png',
                        image: data[0]['brands'][index]['brandImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              const SizedBox(height: 5),
              Text(
                data[0]['brands'][index]['brandName'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemCount: data[0]['brands'].length,
      ),
    );
  }
}
