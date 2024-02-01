import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/gateway/gateway.dart';
import 'package:turkmarket_app/widgets/adress_widget.dart';
import 'package:turkmarket_app/widgets/cart_tile.dart';
import 'package:turkmarket_app/widgets/order/cart_tile_order_detail.dart';

class OrdersDetail extends StatelessWidget {
  final data;
  const OrdersDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List productsId = [];
    String status = '';
    if (data['status'] == 'inprocess') {
      status = 'Рассмотрение';
    } else {
      status = 'Рассмотрение';
    }
    for (var i = 0; i < data['productData'].length; i++) {
      productsId.add(data['productData'][i]['productId']);
    }

    print(data);
    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        backgroundColor: kcontentColor,
        centerTitle: true,
        title: const Text(
          "Детали заказа",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 60,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return StreamBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
              stream: FirestoreService()
                  .createDocumentStream('products', productsId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Пусто',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Статус: ' + status,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'ID заказа: ' + data['id'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Товары',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String documentId = snapshot.data![index].id;
                          if (snapshot.data![index].exists) {
                            Map<String, dynamic> datas =
                                snapshot.data![index].data()!;
                            return CartTileDetail(
                              itemData: data['productData'][index],
                              item: datas,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Адресс',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: AdressCard(
                            data: data['userData'], index: 1, isEdit: false),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Итог',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Column(
                            children: [
                              Text(
                                data['orderPrice'].toString() + ' \$',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${(int.parse(data['orderPrice'].toString()) * state.currency).toInt().toString()} руб",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }
          return Center(
            child: Text('NOT LOADLED'),
          );
        },
      ),
    );
  }
}
