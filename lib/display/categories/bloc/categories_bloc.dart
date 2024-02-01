import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:turkmarket_app/gateway/gateway.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesInitial()) {
    var data = [];
    int selectedSubCat = 0;
    List<Widget> tabs = [];
    on<CategoriesEvent>((event, emit) async {
      if (event is CategoriesLoad) {
        data = await FirestoreService().fetchDataFromFirestore('categories');
        print(data);
        emit(CategoriesLoaded(data: data, selectedSub: selectedSubCat));
      }
      if (event is CategoriesChooseIndexSubCategory) {
        selectedSubCat = event.index;
        emit(CategoriesLoaded(data: data, selectedSub: selectedSubCat));
      }
    });
  }
}
