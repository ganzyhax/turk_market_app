import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {
      if (event is ProductLoad) {
        emit(ProductLoaded());
      }
      if (event is ProductChooseColor) {}
      if (event is ProductChooseSize) {}
      if (event is ProductAddFavourite) {
        emit(ProductLoaded());
      }
    });
  }
}
