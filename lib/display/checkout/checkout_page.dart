import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/payment/payment_screen.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/widgets/checkout/checkout_receipt.dart';
import 'package:turkmarket_app/widgets/custom_button.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kcontentColor,
        appBar: AppBar(
          backgroundColor: kcontentColor,
          centerTitle: true,
          title: const Text(
            "Посмотреть заказ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leadingWidth: 60,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            CheckoutReceipt(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                    child: CustomButton(
                        isEnable: (!state.userAdresses.isEmpty) ? true : false,
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentScreen()),
                          );
                        },
                        title: 'Оплатить'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              );
            }
            return Container();
          },
        ));
  }
}
