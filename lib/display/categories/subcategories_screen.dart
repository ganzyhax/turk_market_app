import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/categories/bloc/categories_bloc.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/products/products_screen.dart';
import 'package:turkmarket_app/widgets/category/main_category_card.dart';

class SubCategoriesScreen extends StatelessWidget {
  final data;
  const SubCategoriesScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "Категории",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: ListView(
                children: List.generate(
                  data.length + 1,
                  (index) => (index == 0)
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 15,
                          ),
                          child: Text(
                            'Выберите котегорию',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            print('tappad');
                            BlocProvider.of<ProductsBloc>(context)
                              ..add(ProductsSearhSubCategory(
                                  subCategory: data[index - 1]));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsScreen()),
                            );
                          },
                          child: ListTile(
                              title: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Text(
                                data[index - 1],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),
                        ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
