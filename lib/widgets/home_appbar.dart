import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/main/bloc/main_bloc.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            BlocProvider.of<MainBloc>(context).add(MainChangeIndex(index: 1));
          },
          style: IconButton.styleFrom(
            backgroundColor: kcontentColor,
            padding: const EdgeInsets.all(15),
          ),
          iconSize: 30,
          icon: const Icon(Ionicons.grid_outline),
        ),
        // IconButton(
        //   onPressed: () {},
        //   style: IconButton.styleFrom(
        //     backgroundColor: kcontentColor,
        //     padding: const EdgeInsets.all(15),
        //   ),
        //   iconSize: 30,
        //   icon: const Icon(Ionicons.notifications_outline),
        // ),
      ],
    );
  }
}
