import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    int totalPrice = 0;
    on<CartEvent>((event, emit) {
      if (event is CartLoad) {
        emit(CartLoaded(totalPrice: totalPrice));
      }
      if (event is CartMakeLoading) {
        emit(CartLoading());
      }
    });
  }
}
