import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/models/cart_item.dart';
import 'package:turkmarket_app/widgets/cart_tile.dart';
import 'package:turkmarket_app/widgets/check_out_box.dart';
import 'package:turkmarket_app/widgets/filter/bloc/filter_bloc.dart';
import 'package:turkmarket_app/widgets/filter/filter_custom.dart';
import 'package:turkmarket_app/widgets/product_card.dart';
import 'package:turkmarket_app/widgets/search_field.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<FilterBloc, FilterState>(
      listener: (context, state) {
        if (state is FilterSearchLoad) {
          BlocProvider.of<ProductsBloc>(context).add(ProductsSearchFilter(
              category: state.category,
              subCategory: state.subCategory,
              subsubCategory: state.subsubCategory,
              colors: state.colors,
              sizes: state.sizes,
              brands: state.brands,
              minPrice: state.minPrice,
              maxPrice: state.maxPrice));
        }
      },
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          if (state is FilterLoaded) {
            return Scaffold(
              backgroundColor: kcontentColor,
              appBar: AppBar(
                backgroundColor: kscaffoldColor,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 45,
                    ),
                    Text('Фильтр'),
                    SizedBox(
                      width: 40,
                    ),
                    InkWell(
                        onTap: () {
                          filterModalBottomSheet(context, state);
                        },
                        child: Icon(
                          Ionicons.filter_sharp,
                          color: Colors.black,
                        ))
                  ],
                ),
                leadingWidth: 60,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state2) {
                  if (state2 is ProductsLoaded) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: state2.query,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Display a loading indicator
                        }
                        if (!snapshot.hasData) {
                          return Text('No data available');
                        }
                        final data = snapshot.data?.docs;

                        return BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              if (!data!.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                    ),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      if (state2.isFilter == true) {
                                        if (data[index]['colors'].any((color) =>
                                                state2.selectedColors.contains(
                                                    color['colorName'])) &&
                                            (data[index]['colors']
                                                    as List<dynamic>)
                                                .any((color) =>
                                                    color['colorSizes'].any(
                                                        (size) => state2
                                                            .selectedSizes
                                                            .contains(size)))) {
                                          return ProductCard(
                                            curr: state.currency,
                                            product: data[index],
                                            isLiked: (state.userLikes.contains(
                                                    data[index]['id']))
                                                ? true
                                                : false,
                                          );
                                        }
                                      } else {
                                        return ProductCard(
                                          curr: state.currency,
                                          product: data[index],
                                          isLiked: (state.userLikes
                                                  .contains(data[index]['id']))
                                              ? true
                                              : false,
                                        );
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text('Товары не найдено'),
                                );
                              }
                            }
                            return Container(
                              child: Text('Товары не найдено'),
                            );
                          },
                        );
                      },
                    );
                  }
                  return Container(
                    child: Text('asdasd'),
                  );
                },
              ),
            );
          }
          return Scaffold();
        },
      ),
    );
  }
}
