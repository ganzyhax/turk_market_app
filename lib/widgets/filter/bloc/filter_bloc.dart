import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:turkmarket_app/gateway/brand_api.dart';
import 'package:turkmarket_app/gateway/color_api.dart';
import 'package:turkmarket_app/gateway/gateway.dart';
import 'package:turkmarket_app/gateway/size_api.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    String selectedCategory = '';
    String selectedSubCategory = '';
    String selectedSubSubCategory = '';
    int indexSelectedCategory = 0;
    int indexSelectedSubCategory = 0;
    int indexSelectedSubSubCategory = 0;
    List lCategories = [];
    List lSubCategories = [];
    List lSubSubCategories = [];
    List allSubCategories = [];
    // =============================Brand
    List selectedBrands = [];
    List brands = [];
    // =============================Colors
    List colors = [];
    String selectedColor = '';
    List selectedColors = [];
    // ==============================Sizes
    List sizes = [];
    List selectedSizes = [];

    bool isVisibleColors = false;
    bool isVisibleSizes = false;
    bool isVisibleBrands = false;
    on<FilterEvent>((event, emit) async {
      if (event is FilterLoad) {
        List<DocumentSnapshot> categoriess =
            await FirestoreService().fetchDataFromFirestoreList('categories');

        for (var category in categoriess) {
          Map<String, dynamic> data = category.data() as Map<String, dynamic>;
          lCategories.add(data['name']);
          allSubCategories.add({'name': data['name']});
          lSubCategories = [];
          lSubSubCategories = [];
          for (var s = 0; s < data['subCategories'].length; s++) {
            lSubCategories.add(data['subCategories'][s]['name']);
            allSubCategories[allSubCategories.length - 1]['subCategories'] =
                lSubCategories;
            lSubSubCategories.add([]);
            for (var i = 0;
                i < data['subCategories'][s]['subCategories'].length;
                i++) {
              lSubSubCategories[lSubSubCategories.length - 1]
                  .add(data['subCategories'][s]['subCategories'][i]);
            }
          }
          allSubCategories[allSubCategories.length - 1]['subsubCategories'] =
              lSubSubCategories;
        }
        selectedCategory = lCategories[indexSelectedCategory];
        selectedSubCategory =
            allSubCategories[indexSelectedCategory]['subCategories'][0];

        selectedSubSubCategory = allSubCategories[indexSelectedCategory]
            ['subsubCategories'][0][indexSelectedSubCategory];
        // ============================Colors
        colors = await SingleColorApi().fetchColors();
        // ============================Sizes
        sizes = await SingleSizeApi().fetchSizes();
        // ============================Brand
        brands = await BrandApi().fetchBrands();

        emit(FilterLoaded(
            selectedColors: selectedColors,
            isVisibleBrands: isVisibleBrands,
            isVisibleColors: isVisibleColors,
            isVisibleSizes: isVisibleSizes,
            colors: colors,
            selectedCategory: selectedCategory,
            selectedSubCategory: selectedSubCategory,
            selectedSubSubCategory: selectedSubSubCategory,
            lSubCategories: allSubCategories,
            selectedBrands: selectedBrands,
            selectedSizes: selectedSizes,
            sizes: sizes,
            brands: brands,
            indexSelectedCategory: indexSelectedCategory,
            indexSelectedSubCategory: indexSelectedSubCategory,
            lCategories: lCategories,
            lSubSubCategories: lSubSubCategories));
      }
      if (event is FilterVisibleColors) {
        if (isVisibleColors == true) {
          isVisibleColors = false;
        } else {
          isVisibleColors = true;
        }
        emit(FilterLoaded(
            selectedColors: selectedColors,
            isVisibleBrands: isVisibleBrands,
            isVisibleColors: isVisibleColors,
            isVisibleSizes: isVisibleSizes,
            sizes: sizes,
            selectedBrands: selectedBrands,
            colors: colors,
            brands: brands,
            selectedSizes: selectedSizes,
            selectedCategory: selectedCategory,
            selectedSubCategory: selectedSubCategory,
            selectedSubSubCategory: selectedSubSubCategory,
            lSubCategories: allSubCategories,
            indexSelectedCategory: indexSelectedCategory,
            indexSelectedSubCategory: indexSelectedSubCategory,
            lCategories: lCategories,
            lSubSubCategories: lSubSubCategories));
      }
      if (event is FilterVisibleSizes) {
        if (isVisibleSizes == true) {
          isVisibleSizes = false;
        } else {
          isVisibleSizes = true;
        }
        emit(FilterLoaded(
            selectedColors: selectedColors,
            isVisibleBrands: isVisibleBrands,
            isVisibleColors: isVisibleColors,
            isVisibleSizes: isVisibleSizes,
            sizes: sizes,
            selectedBrands: selectedBrands,
            colors: colors,
            brands: brands,
            selectedSizes: selectedSizes,
            selectedCategory: selectedCategory,
            selectedSubCategory: selectedSubCategory,
            selectedSubSubCategory: selectedSubSubCategory,
            lSubCategories: allSubCategories,
            indexSelectedCategory: indexSelectedCategory,
            indexSelectedSubCategory: indexSelectedSubCategory,
            lCategories: lCategories,
            lSubSubCategories: lSubSubCategories));
      }
      if (event is FilterVisibleBrands) {
        if (isVisibleBrands == true) {
          isVisibleBrands = false;
        } else {
          isVisibleBrands = true;
        }
        emit(FilterLoaded(
            selectedColors: selectedColors,
            isVisibleBrands: isVisibleBrands,
            isVisibleColors: isVisibleColors,
            isVisibleSizes: isVisibleSizes,
            sizes: sizes,
            selectedBrands: selectedBrands,
            colors: colors,
            brands: brands,
            selectedSizes: selectedSizes,
            selectedCategory: selectedCategory,
            selectedSubCategory: selectedSubCategory,
            selectedSubSubCategory: selectedSubSubCategory,
            lSubCategories: allSubCategories,
            indexSelectedCategory: indexSelectedCategory,
            indexSelectedSubCategory: indexSelectedSubCategory,
            lCategories: lCategories,
            lSubSubCategories: lSubSubCategories));
      }
      if (event is FilterSearch) {
        List colorsToGo = [];
        List sizesToGo = [];
        if (event.colors.isEmpty) {
          colorsToGo = colors;
        } else {
          colorsToGo = event.colors;
        }
        if (event.sizes.isEmpty) {
          sizesToGo = sizes;
        } else {
          sizesToGo = event.sizes;
        }
        print(sizesToGo);

        emit(FilterSearchLoad(
            category: event.category,
            subCategory: event.subCategory,
            subsubCategory: event.subsubCategory,
            colors: colorsToGo,
            sizes: sizesToGo,
            brands: event.brands,
            minPrice: event.minPrice,
            maxPrice: event.maxPrice));
        emit(FilterLoaded(
            selectedColors: selectedColors,
            isVisibleBrands: isVisibleBrands,
            isVisibleColors: isVisibleColors,
            isVisibleSizes: isVisibleSizes,
            sizes: sizes,
            selectedBrands: selectedBrands,
            colors: colors,
            brands: brands,
            selectedSizes: selectedSizes,
            selectedCategory: selectedCategory,
            selectedSubCategory: selectedSubCategory,
            selectedSubSubCategory: selectedSubSubCategory,
            lSubCategories: allSubCategories,
            indexSelectedCategory: indexSelectedCategory,
            indexSelectedSubCategory: indexSelectedSubCategory,
            lCategories: lCategories,
            lSubSubCategories: lSubSubCategories));
      }
    });
  }
}
