import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/display/main/bloc/main_bloc.dart';
import 'package:turkmarket_app/display/product/bloc/product_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/widgets/alert/custom_alert.dart';

class ProductAppBar extends StatelessWidget {
  final String id;
  const ProductAppBar({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  icon: const Icon(Ionicons.chevron_back),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  icon: const Icon(Ionicons.share_social_outline),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (prefs.getString('id') == null ||
                        prefs.getString('id') == '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            alertTitle:
                                'Вы не регистрированы, регистрируйтесь!',
                            buttonText: 'Регистрация',
                            function: () {
                              BlocProvider.of<MainBloc>(context)
                                  .add(MainChangeIndex(index: 2));
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    } else {
                      BlocProvider.of<UserBloc>(context)
                        ..add(UserLikeProduct(id: id));
                    }
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  icon: (state.userLikes.contains(id))
                      ? Icon(Ionicons.heart)
                      : Icon(Ionicons.heart_outline),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
