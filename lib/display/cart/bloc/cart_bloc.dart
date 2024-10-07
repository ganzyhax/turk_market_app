import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:turkmarket_app/gateway/gateway.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    int totalPrice = 0;
    on<CartEvent>((event, emit) async {
      if (event is CartLoad) {
        await FirestoreService().sortUserData();
        emit(CartLoaded(totalPrice: totalPrice));
      }
      if (event is CartMakeLoading) {
        emit(CartLoading());
      }
    });
  }
}
