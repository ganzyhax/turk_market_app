import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/cart/cart_screen.dart';
import 'package:turkmarket_app/display/categories/categories_screen.dart';
import 'package:turkmarket_app/display/chat/chat_screen.dart';
import 'package:turkmarket_app/display/favourite/favourite_screen.dart';
import 'package:turkmarket_app/display/home/home_screen.dart';
import 'package:turkmarket_app/display/main/bloc/main_bloc.dart';
import 'package:turkmarket_app/display/profile/profile_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainLoaded) {
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndDocked,
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              height: 70,
              color: Colors.white,
              shape: CircularNotchedRectangle(),
              notchMargin: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: (state.screens.length == 5)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceAround,
                  children: (state.screens.length == 5)
                      ? [
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 0));
                            },
                            icon: Icon(
                              Ionicons.home,
                              color: state.index == 0
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 1));
                            },
                            icon: Icon(
                              Ionicons.grid_outline,
                              color: state.index == 1
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 2));
                            },
                            icon: Icon(
                              Ionicons.heart_outline,
                              color: state.index == 2
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 3));
                            },
                            icon: Icon(
                              Ionicons.cart_outline,
                              color: state.index == 3
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 4));
                            },
                            icon: Icon(
                              Ionicons.person_outline,
                              color: state.index == 4
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ]
                      : [
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 0));
                            },
                            icon: Icon(
                              Ionicons.home,
                              color: state.index == 0
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 1));
                            },
                            icon: Icon(
                              Ionicons.grid_outline,
                              color: state.index == 1
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 2));
                            },
                            icon: Icon(
                              Ionicons.person_outline,
                              color: state.index == 2
                                  ? kprimaryColor
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ]),
            ),
            floatingActionButton: Container(
              height: 45.0,
              width: 45.0,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.contact_support_outlined,
                    color: Colors.white,
                  ),
                  // elevation: 5.0,
                ),
              ),
            ),
            body: state.screens[state.index],
          );
        }
        return Container();
      },
    );
  }
}
