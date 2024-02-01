import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/categories/bloc/categories_bloc.dart';
import 'package:turkmarket_app/display/categories/subcategories_screen.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/widgets/category/main_category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          return DefaultTabController(
            length: state.data.length, // Number of tabs
            child: Scaffold(
              backgroundColor: kcontentColor,
              appBar: AppBar(
                backgroundColor: kcontentColor,
                centerTitle: true,
                title: const Text(
                  "Категории",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                bottom: TabBar(
                  labelColor: Colors.black,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  isScrollable: true,
                  tabs: state.data
                      .map<Widget>((e) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              e['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              body: TabBarView(
                children: state.data
                    .map<Widget>(
                      (data) => ListView(
                        children: List.generate(
                          data['subCategories'].length,
                          (index) => ListTile(
                            title: InkWell(
                              onTap: () {
                                BlocProvider.of<CategoriesBloc>(context).add(
                                    CategoriesChooseIndexSubCategory(
                                        index: index));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubCategoriesScreen(
                                            data: data['subCategories'][index]
                                                ['subCategories'],
                                          )),
                                );
                              },
                              child: CategoryCard(
                                data: data['subCategories'][index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
