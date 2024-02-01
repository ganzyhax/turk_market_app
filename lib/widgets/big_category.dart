import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/products/products_screen.dart';

import 'package:turkmarket_app/models/category.dart';

class BigCategory extends StatelessWidget {
  BigCategory({
    super.key,
    required this.title,
    required this.image,
  });
  final title;
  final image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ProductsBloc>(context)
          ..add(ProductsSearhSex(sex: title));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductsScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        height: 170.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
