import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/widgets/custom_button.dart';
import 'package:turkmarket_app/widgets/dropdown_listtile.dart';
import 'package:turkmarket_app/widgets/filter/bloc/filter_bloc.dart';

void filterModalBottomSheet(
  context,
  state,
) {
  double startval = 20, endval = 200000;
  var selectedCategory = state.selectedCategory;
  var selectedSubCategory = state.selectedSubCategory;
  var indexSelectedCategory = state.indexSelectedCategory;
  var selectedSubSubCategory = state.selectedSubSubCategory;
  var indexSelectedSubCategory = state.indexSelectedSubCategory;
  var isVisibleColors = state.isVisibleColors;
  var isVisibleSizes = state.isVisibleSizes;
  var isVisibleBrands = state.isVisibleBrands;
  var selectedColors = [];
  var selectedSizes = [];
  var selectedBrands = [];

  showModalBottomSheet<void>(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (bc, StateSetter _setState) {
          void addSizes(List value) {
            _setState(() {
              selectedSizes = value;
            });
          }

          void addColors(List value) {
            _setState(() {
              selectedColors = value;
            });
          }

          void addBrands(List value) {
            _setState(() {
              selectedBrands = value;
            });
          }

          return Container(
              padding: EdgeInsets.all(14),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              'Фильтр',
                              style: TextStyle(fontSize: 24),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Категория'),
                            SizedBox(
                              width: 65,
                            ),
                            DropdownButton<String>(
                              value: selectedCategory,
                              items: (state.lCategories as List<dynamic>)
                                  .map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                int index =
                                    (state.lCategories).indexOf(newValue!);

                                selectedCategory = state.lCategories[index];

                                indexSelectedCategory = index;

                                selectedSubCategory =
                                    state.lSubCategories[indexSelectedCategory]
                                        ['subCategories'][0];
                                selectedSubSubCategory =
                                    state.lSubCategories[indexSelectedCategory]
                                            ['subsubCategories']
                                        [indexSelectedSubCategory][0];
                                _setState(
                                  () {},
                                );
                                // BlocProvider.of<CreateProductBloc>(context)
                                //   ..add(CreateProductChooseCategories(
                                //       index: index,
                                //       which: 1,
                                //       value: newValue.toString()));
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Подкатегорию'),
                            SizedBox(
                              width: 40,
                            ),
                            DropdownButton<String>(
                              value: selectedSubCategory,
                              items: (state
                                          .lSubCategories[indexSelectedCategory]
                                      ['subCategories'] as List<dynamic>)
                                  .cast<String>()
                                  .map<DropdownMenuItem<String>>(
                                    (subcategory) => DropdownMenuItem<String>(
                                      value: subcategory,
                                      child: Text(subcategory),
                                    ),
                                  )
                                  .toList(), // Ensure to convert the result to a list
                              onChanged: (newValue) {
                                int index =
                                    (state.lSubCategories[indexSelectedCategory]
                                            ['subCategories'] as List<dynamic>)
                                        .indexOf(newValue!);
                                selectedSubCategory =
                                    state.lSubCategories[indexSelectedCategory]
                                        ['subCategories'][index];

                                indexSelectedSubCategory = index;
                                selectedSubSubCategory =
                                    state.lSubCategories[indexSelectedCategory]
                                            ['subsubCategories']
                                        [indexSelectedSubCategory][0];
                                _setState(
                                  () {},
                                );
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Подподкатегорию'),
                            SizedBox(
                              width: 20,
                            ),
                            DropdownButton<String>(
                              value: selectedSubSubCategory,
                              items:
                                  (state.lSubCategories[indexSelectedCategory]
                                                  ['subsubCategories']
                                              [indexSelectedSubCategory]
                                          as List<dynamic>)
                                      .cast<String>()
                                      .map<DropdownMenuItem<String>>(
                                          (String subsubcategory) {
                                return DropdownMenuItem<String>(
                                  value: subsubcategory,
                                  child: Text(subsubcategory),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                int index =
                                    (state.lSubCategories[indexSelectedCategory]
                                                    ['subsubCategories']
                                                [indexSelectedSubCategory]
                                            as List<dynamic>)
                                        .indexOf(newValue!);
                                selectedSubSubCategory =
                                    state.lSubCategories[indexSelectedCategory]
                                            ['subsubCategories']
                                        [indexSelectedSubCategory][index];
                                _setState(
                                  () {},
                                );
                              },
                            ),
                          ],
                        ),
                        DropdownListtile(
                          selectedValues: selectedSizes,
                          colors: state.colors,
                          withImage: false,
                          updateMessageCallback: addColors,
                          title: 'Цветы',
                          function: () async {
                            BlocProvider.of<FilterBloc>(context)
                              ..add(FilterVisibleColors());
                            _setState(() {
                              if (isVisibleColors == true) {
                                isVisibleColors = false;
                              } else {
                                isVisibleColors = true;
                              }
                            });
                          },
                          isSelected: isVisibleColors,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownListtile(
                          updateMessageCallback: addSizes,
                          selectedValues: selectedColors,
                          withImage: false,
                          colors: state.sizes,
                          title: 'Размеры',
                          function: () async {
                            BlocProvider.of<FilterBloc>(context)
                              ..add(FilterVisibleSizes());
                            _setState(() {
                              if (isVisibleSizes == true) {
                                isVisibleSizes = false;
                              } else {
                                isVisibleSizes = true;
                              }
                            });
                          },
                          isSelected: isVisibleSizes,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownListtile(
                          updateMessageCallback: addBrands,
                          withImage: true,
                          selectedValues: selectedBrands,
                          colors: state.brands,
                          title: 'Бренды',
                          function: () async {
                            _setState(() {
                              if (isVisibleBrands == true) {
                                isVisibleBrands = false;
                              } else {
                                isVisibleBrands = true;
                              }
                            });
                          },
                          isSelected: isVisibleBrands,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Цена'),
                          ],
                        ),
                        RangeSlider(
                          activeColor: kprimaryColor,
                          inactiveColor: Colors.grey,
                          min: 20,
                          max: 200000,
                          divisions: 10000,
                          labels:
                              RangeLabels("Мин. $startval", "Макс. $endval"),
                          values: RangeValues(startval, endval),
                          onChanged: (RangeValues value) {
                            _setState(() {
                              startval = value.start;
                              endval = value.end;
                            });
                          },
                        ),
                        Text("Минимальная цена: $startval",
                            style: TextStyle(fontSize: 12)),
                        Text("Максимальная цена: $endval",
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      title: 'Искать',
                      function: () {
                        int startPrice = startval.toInt();
                        int endPrice = endval.toInt();
                        BlocProvider.of<FilterBloc>(context).add(FilterSearch(
                            minPrice: startPrice,
                            maxPrice: endPrice,
                            sizes: selectedSizes,
                            subCategory: selectedSubCategory,
                            subsubCategory: selectedSubSubCategory,
                            category: selectedCategory,
                            brands: selectedBrands,
                            colors: selectedColors));
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ));
        });
      });
}
