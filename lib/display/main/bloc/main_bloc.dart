import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/display/cart/cart_screen.dart';
import 'package:turkmarket_app/display/categories/categories_screen.dart';
import 'package:turkmarket_app/display/favourite/favourite_screen.dart';
import 'package:turkmarket_app/display/home/home_screen.dart';
import 'package:turkmarket_app/display/profile/profile_screen.dart';
import 'package:turkmarket_app/display/sign_in/sign_in_screen.dart';
import 'package:turkmarket_app/display/sign_up/components/sign_up_form.dart';
import 'package:turkmarket_app/display/sign_up/sign_up_screen.dart';
import 'package:turkmarket_app/gateway/gateway.dart';
part 'main_state.dart';
part 'main_event.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    int index = 0;
    List screens = [];
    on<MainEvent>((event, emit) async {
      if (event is MainLoad) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var currency = await FirestoreService().getUsdRub();

        await prefs.setDouble('currency', currency);
        bool isLogged = await prefs.getBool('isLogged') ?? false;
        if (isLogged) {
          screens = [
            HomeScreen(),
            CategoriesScreen(),
            FavouriteScreen(),
            CartScreen(),
            ProfileScreen(),
          ];
        } else {
          screens = [
            HomeScreen(),
            CategoriesScreen(),
            SignUpScreen(),
          ];
        }
        emit(MainLoaded(index: index, screens: screens));
      }
      if (event is MainChangeIndex) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        if (event.isForLog == true) {
          if (event.index == 0) {
            screens = [
              HomeScreen(),
              CategoriesScreen(),
              SignInScreen(),
            ];
          } else {
            screens = [
              HomeScreen(),
              CategoriesScreen(),
              SignUpScreen(),
            ];
          }
        } else {
          index = event.index;

          bool isLogged = await prefs.getBool('isLogged') ?? false;
          if (isLogged) {
            screens = [
              CategoriesScreen(),
              FavouriteScreen(),
              HomeScreen(),
              CartScreen(),
              ProfileScreen(),
            ];
          } else {
            screens = [
              HomeScreen(),
              CategoriesScreen(),
              SignUpScreen(),
            ];
          }
        }

        emit(MainLoaded(index: index, screens: screens));
      }
    });
  }
}
