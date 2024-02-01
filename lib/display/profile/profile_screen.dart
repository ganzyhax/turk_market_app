import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/display/adresses/adress_page.dart';
import 'package:turkmarket_app/display/checkout/checkout_page.dart';
import 'package:turkmarket_app/display/main/bloc/main_bloc.dart';
import 'package:turkmarket_app/display/orders/orders_screen.dart';
import 'package:turkmarket_app/display/payment/payment_screen.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const ProfilePic(),
                  const SizedBox(height: 20),
                  ProfileMenu(
                    text: "Мой аккаунт",
                    icon: "assets/icons/User Icon.svg",
                    press: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen()),
                      )
                    },
                  ),
                  ProfileMenu(
                    text: "Заказы",
                    icon: "assets/icons/Bell.svg",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderScreen()),
                      );
                    },
                  ),
                  // ProfileMenu(
                  //   text: "Settings",
                  //   icon: "assets/icons/Settings.svg",
                  //   press: () {},
                  // ),
                  // ProfileMenu(
                  //   text: "Адресы",
                  //   icon: "assets/icons/Percel.svg",
                  //   press: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => AddressScreen()),
                  //     );
                  //   },
                  // ),
                  ProfileMenu(
                    text: "Выйти",
                    icon: "assets/icons/Log out.svg",
                    press: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setBool('isLogged', false);
                      await prefs.setString('id', '');
                      BlocProvider.of<MainBloc>(context)
                        ..add(MainChangeIndex(index: 2));
                      BlocProvider.of<UserBloc>(context)..add(UserLoad());
                    },
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
