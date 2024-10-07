import 'package:flutter/material.dart';

import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Зарегистрироваться"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Регистрация Аккаунта", style: headingStyle),
                  const SizedBox(height: 16),
                  const SignUpForm(),
                  const SizedBox(height: 16),
                  Text(
                    'Продолжая, вы подтверждаете, что\nсогласны с нашими Условиями использования.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
