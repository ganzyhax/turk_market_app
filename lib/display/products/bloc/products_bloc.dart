import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    final int _perPage = 8;
    Query query =
        FirebaseFirestore.instance.collection('products').limit(_perPage);
    ;
    List selectedColors = [];

    List selectedSizes = [];
    bool canLoad = true;
    DocumentSnapshot? _lastDocument = null;

    List<DocumentSnapshot> _data = [];
    StreamController<List<DocumentSnapshot>> _streamController =
        StreamController();
    on<ProductsEvent>((event, emit) async {
      void _clearScrollData() {
        StreamController<List<DocumentSnapshot>> _nstreamController =
            StreamController();
        _streamController = _nstreamController;
        _lastDocument = null;
        _data.clear();
      }

      void _loadData() {
        if (_lastDocument != null) {
          query = query.startAfterDocument(_lastDocument!);
        }

        query.snapshots().listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            _lastDocument = snapshot.docs.last;
            _data.addAll(snapshot.docs);
            _data.toSet().toList();
            _streamController.add(_data);
          }
        });
        canLoad = true;
      }

      if (event is ProductsSearchLoadMoreScroll) {
        if (canLoad) {
          canLoad = false;
          _loadData();
        }

        emit(ProductsLoaded(
          selectedColors: selectedColors,
          isFilter: false,
          selectedSizes: selectedSizes,
          query: _streamController,
        ));
      }
      if (event is ProductLoad) {
        // _loadData();
        // emit(ProductsLoaded(
        //   selectedColors: selectedColors,
        //   isFilter: false,
        //   selectedSizes: selectedSizes,
        //   query: _streamController,
        // ));
      }
      if (event is ProductsSearhSubCategory) {
        log(event.mainCategory);
        log(event.category);
        log(event.subCategory);
        query = FirebaseFirestore.instance
            .collection('products')
            .where('mainCategory', isEqualTo: event.mainCategory)
            .where('category', isEqualTo: event.category)
            .where('subCategory', isEqualTo: event.subCategory)
            .limit(_perPage);
        _clearScrollData();
        _loadData();
        emit(ProductsLoaded(
          selectedColors: selectedColors,
          isFilter: false,
          selectedSizes: selectedSizes,
          query: _streamController,
        ));
      }
      if (event is ProductsSearhCategory) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: event.category)
            .limit(_perPage);
        _clearScrollData();
        _loadData();
        emit(ProductsLoaded(
          isFilter: false,
          query: _streamController,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearhBrand) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('brand', isEqualTo: event.brand)
            .limit(_perPage);
        _clearScrollData();
        _loadData();
        emit(ProductsLoaded(
          query: _streamController,
          isFilter: false,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearhInput) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('searchKey', arrayContains: event.input.toLowerCase())
            .limit(_perPage);
        _clearScrollData();
        _loadData();
        emit(ProductsLoaded(
          query: _streamController,
          isFilter: false,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearhSex) {
        query = FirebaseFirestore.instance
            .collection('products')
            .where('mainCategory', isEqualTo: event.sex)
            .limit(_perPage);
        _clearScrollData();
        _loadData();
        emit(ProductsLoaded(
          query: _streamController,
          isFilter: false,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ));
      }
      if (event is ProductsSearchFilter) {
        selectedColors = event.colors;
        selectedSizes = event.sizes;
        print('mainCategory  :  ' + event.category);
        print('category  :  ' + event.subCategory);
        print('SubCategory : ' + event.subsubCategory);
        print('brand : ' + event.brands.toString());
        print('max  Price : ' + event.maxPrice.toString());
        print('min  Price : ' + event.minPrice.toString());
        if (!event.brands.isEmpty) {
          print('RUN THIS');
          query = FirebaseFirestore.instance
              .collection('products')
              .where('mainCategory', isEqualTo: event.category)
              .where(
                'category',
                isEqualTo: event.subCategory,
              )
              .where('subCategory', isEqualTo: event.subsubCategory)
              .where('brand', whereIn: event.brands)
              .where('price',
                  isGreaterThanOrEqualTo: int.parse(event.minPrice.toString()))
              .where('price',
                  isLessThanOrEqualTo: int.parse(event.maxPrice.toString()))
              .limit(_perPage);
          _clearScrollData();
          _loadData();
          emit(ProductsLoaded(
            isFilter: true,
            query: _streamController,
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
              .limit(_perPage);
          _clearScrollData();
          _loadData();
          emit(ProductsLoaded(
            isFilter: true,
            query: _streamController,
            selectedColors: selectedColors,
            selectedSizes: selectedSizes,
          ));
        }
      }
    });
  }
}
