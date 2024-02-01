import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/display/main/bloc/main_bloc.dart';
import 'package:turkmarket_app/display/sign_up/sign_up_screen.dart';

import '../constants.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Нет аккаунта? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<MainBloc>(context)
              ..add(MainChangeIndex(index: 1, isForLog: true));
          },
          child: const Text(
            "Зарегистрироваться",
            style: TextStyle(fontSize: 16, color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
