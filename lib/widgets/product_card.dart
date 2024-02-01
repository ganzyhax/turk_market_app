import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/main/bloc/main_bloc.dart';
import 'package:turkmarket_app/display/product/product_screen.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/models/product.dart';
import 'package:turkmarket_app/widgets/alert/custom_alert.dart';

class ProductCard extends StatelessWidget {
  final product;
  final bool isLiked;
  final double curr;
  const ProductCard(
      {super.key,
      required this.product,
      required this.isLiked,
      required this.curr});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              curr: curr,
              product: product,
              isLiked: isLiked,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            // padding: EdgeInsets.all(2),
            height: 270,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kscaffoldColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Image.network(
                  product['mainImage'],
                  width: 120,
                  height: 120,
                ),
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      "\$${product['price']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${(int.parse(product['price'].toString()) * curr).toInt().toString()} руб",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: kprimaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: InkWell(
                    onTap: () async {
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
                              },
                            );
                          },
                        );
                      } else {
                        BlocProvider.of<UserBloc>(context)
                          ..add(UserLikeProduct(id: product['id']));
                      }
                    },
                    child: (isLiked == false)
                        ? Icon(
                            Ionicons.heart_outline,
                            color: Colors.white,
                            size: 18,
                          )
                        : Icon(
                            Ionicons.heart,
                            color: Colors.red,
                            size: 18,
                          )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
