import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    Stream<QuerySnapshot<Map<String, dynamic>>> query;
    List selectedColors = [];
    bool isFilter = false;
    List selectedSizes = [];
    double curr = 0;
    on<ProductsEvent>((event, emit) async {
      if (event is ProductLoad) {}
      if (event is ProductsSearhSubCategory) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('subCategory', isEqualTo: event.subCategory)
            .snapshots();
        emit(ProductsLoaded(
          selectedColors: selectedColors,
          isFilter: false,
          selectedSizes: selectedSizes,
          query: query,
        ));
      }
      if (event is ProductsSearhCategory) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: event.category)
            .snapshots();
        emit(ProductsLoaded(
          isFilter: false,
          query: query,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearhBrand) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('brand', isEqualTo: event.brand)
            .snapshots();
        emit(ProductsLoaded(
          query: query,
          isFilter: false,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearhInput) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('searchKey', arrayContains: event.input.toLowerCase())
            .snapshots();
        emit(ProductsLoaded(
          query: query,
          isFilter: false,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearhSex) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('mainCategory', isEqualTo: event.sex)
            .snapshots();
        emit(ProductsLoaded(
          query: query,
          isFilter: false,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearchFilter) {
        selectedColors = event.colors;
        selectedSizes = event.sizes;
        if (!event.brands.isEmpty) {
          query = FirebaseFirestore.instance
              .collection('products')
              .where('mainCategory', isEqualTo: event.category)
              .where(
                'category',
                isEqualTo: event.subCategory,
              )
              .where('subCategory', isEqualTo: event.subsubCategory)
              .where('brand', arrayContains: event.brands)
              .where('price', isLessThanOrEqualTo: event.maxPrice)
              .where('price', isGreaterThanOrEqualTo: event.minPrice)
              .snapshots();
          emit(ProductsLoaded(
            isFilter: true,
            query: query,
            selectedColors: selectedColors,
            selectedSizes: selectedSizes,
          ));
        } else {
          query = FirebaseFirestore.instance
              .collection('products')
              .where('mainCategory', isEqualTo: event.category)
              .where(
                'category',
                isEqualTo: event.subCategory,
              )
              .where('subCategory', isEqualTo: event.subsubCategory)
              .where('price',
                  isGreaterThanOrEqualTo: int.parse(event.minPrice.toString()))
              .where('price',
                  isLessThanOrEqualTo: int.parse(event.maxPrice.toString()))
              .snapshots();
          emit(ProductsLoaded(
            isFilter: true,
            query: query,
            selectedColors: selectedColors,
            selectedSizes: selectedSizes,
          ));
        }
      }
    });
  }
}
