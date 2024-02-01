import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/cart/bloc/cart_bloc.dart';
import 'package:turkmarket_app/display/payment/bloc/payment_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/gateway/gateway.dart';
import 'package:turkmarket_app/widgets/adress_add.dart';
import 'package:turkmarket_app/widgets/custom_button.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        backgroundColor: kcontentColor,
        centerTitle: true,
        title: const Text(
          "Реквизиты для оплаты",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 60,
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            BlocProvider.of<UserBloc>(context)..add(UserBucketFinish());
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is PaymentLoaded) {
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state2) {
                  if (state2 is UserLoaded) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'СБЕРБАНК',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  CreditCardWidget(
                                    cardNumber: '4276 6000 4994 0899',
                                    expiryDate: '**/**',
                                    cardHolderName: 'MAGOMED SIRAZHUDINOV',
                                    cvvCode: '***',
                                    cardType: CardType.mastercard,
                                    obscureCardNumber: false,
                                    showBackView:
                                        false, //true when you want to show cvv(back) view
                                    onCreditCardWidgetChange:
                                        (CreditCardBrand brand) {},
                                    isHolderNameVisible:
                                        true, // Callback for anytime credit card brand is changed
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      'СБЕРБАНК',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  CreditCardWidget(
                                    cardNumber: '2202 2008 0787 3417',
                                    expiryDate: '**/**',
                                    cardHolderName: 'MAGOMED SIRAZHUDINOV',
                                    cvvCode: '***',
                                    cardType: CardType.mastercard,
                                    obscureCardNumber: false,
                                    showBackView:
                                        false, //true when you want to show cvv(back) view
                                    onCreditCardWidgetChange:
                                        (CreditCardBrand brand) {},
                                    isHolderNameVisible:
                                        true, // Callback for anytime credit card brand is changed
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Сумма к оплате' + ': ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            state2.totalSum.toString() + ' \$',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${(int.parse(state2.totalSum.toString()) * state2.currency).toInt().toString()} руб",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'После совершение оплаты, загрузите сюда ваш чек.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  (state.loadingUpload == false &&
                                          state.urlPdf == '')
                                      ? InkWell(
                                          onTap: () {
                                            BlocProvider.of<PaymentBloc>(
                                                    context)
                                                .add(PaymentUploadPdf());
                                          },
                                          child: AdressAdd())
                                      : (state.loadingUpload == true)
                                          ? Center(
                                              child: Column(
                                                children: [
                                                  CircularProgressIndicator(
                                                    color: kPrimaryColor,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text('Загрузка...')
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .picture_as_pdf_outlined,
                                                      color: Colors.red,
                                                      size: 50,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Чек загружен!',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 19, right: 10, left: 10),
                          child: CustomButton(
                              function: () async {
                                await makeSucces(context, state2);
                                // Navigator.pop(context);
                                // Navigator.pop(context);

                                //recommend
                              },
                              isEnable: (state.urlPdf != '') ? true : false,
                              title: 'Подвердить заказ'),
                        )
                      ],
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  makeSucces(context, state2) async {
    final snackBar = SnackBar(
      content: Text('Ваш заказ подвержден!'),
      duration: Duration(
          seconds:
              3), // Set the duration for how long the SnackBar will be displayed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    BlocProvider.of<PaymentBloc>(context)
      ..add(PaymentAccept(
          orderPrice: state2.totalSum,
          userBuckets: state2.userBuckets,
          userData: state2.userAdresses[state2.selectedAdress]));
  }
}
