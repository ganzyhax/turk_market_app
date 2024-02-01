import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/cart/bloc/cart_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/gateway/gateway.dart';
import 'package:turkmarket_app/models/cart_item.dart';
import 'package:turkmarket_app/widgets/cart_tile.dart';
import 'package:turkmarket_app/widgets/check_out_box.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state2) {
              if (state2 is CartLoaded) {
                return Scaffold(
                    backgroundColor: kcontentColor,
                    appBar: AppBar(
                      backgroundColor: kcontentColor,
                      centerTitle: true,
                      title: const Text(
                        "Корзина",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leadingWidth: 60,
                    ),
                    bottomSheet: CheckOutBox(),
                    body: StreamBuilder<
                        List<DocumentSnapshot<Map<String, dynamic>>>>(
                      stream: FirestoreService()
                          .createDocumentStream('products', state.listBucketId),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState == ConnectionState.waiting) {
                        //   return Center(child: CircularProgressIndicator());
                        // }

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
                        } else {
                          if (state.listBucketId.length > 0) {
                            int totalSum = 0;
                            int index = 0;
                            snapshot.data!.forEach((doc) {
                              totalSum += (doc['price'] as int) *
                                  int.parse(state.userBuckets[index]['count']);
                              index++; // Assuming 'price' is a field in your documents
                            });
                            BlocProvider.of<UserBloc>(context)
                                .add(UserSetTotalSum(sum: totalSum));

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 380,
                                child: ListView.builder(
                                  // physics: const NeverScrollableScrollPhysics(),

                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data![index].exists) {
                                      Map<String, dynamic> data =
                                          snapshot.data![index].data()!;

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: CartTile(
                                          curr: state.currency,
                                          index: index,
                                          item: data,
                                          itemData: state.userBuckets[index],
                                          onRemove: () {
                                            setState(() {
                                              for (var i = 0;
                                                  i < data['colors'].length;
                                                  i++) {
                                                for (var s = 0;
                                                    s <
                                                        data['colors'][i]
                                                                ['colorSizes']
                                                            .length;
                                                    s++) {
                                                  if (data['colors'][i]
                                                          ['colorSizes'][s] ==
                                                      state.userBuckets[index]
                                                          ['size']) {
                                                    int maxCount = int.parse(
                                                        data['colors'][i][
                                                                'sizesCount'][s]
                                                            .toString());
                                                    int selectedCount =
                                                        int.parse(state
                                                            .userBuckets[index]
                                                                ['count']
                                                            .toString());
                                                    if (maxCount >=
                                                            selectedCount &&
                                                        selectedCount != 1) {
                                                      selectedCount =
                                                          selectedCount - 1;
                                                      state.userBuckets[index]
                                                              ['count'] =
                                                          selectedCount
                                                              .toString();
                                                    }
                                                  }
                                                }
                                              }
                                            });
                                          },
                                          onAdd: () {
                                            setState(() {
                                              for (var i = 0;
                                                  i < data['colors'].length;
                                                  i++) {
                                                for (var s = 0;
                                                    s <
                                                        data['colors'][i]
                                                                ['colorSizes']
                                                            .length;
                                                    s++) {
                                                  if (data['colors'][i]
                                                          ['colorSizes'][s] ==
                                                      state.userBuckets[index]
                                                          ['size']) {
                                                    int maxCount = int.parse(
                                                        data['colors'][i][
                                                                'sizesCount'][s]
                                                            .toString());
                                                    int selectedCount =
                                                        int.parse(state
                                                            .userBuckets[index]
                                                                ['count']
                                                            .toString());
                                                    if (maxCount >
                                                        selectedCount) {
                                                      totalSum = totalSum +
                                                          int.parse(
                                                              data['price']
                                                                  .toString());
                                                      selectedCount =
                                                          selectedCount + 1;
                                                      state.userBuckets[index]
                                                              ['count'] =
                                                          selectedCount
                                                              .toString();
                                                    }
                                                  }
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            BlocProvider.of<UserBloc>(context)
                                .add(UserSetTotalSum(sum: 0));
                            return Center(
                              child: Text('Пусто'),
                            );
                          }
                        }
                      },
                    ));
              }
              if (state2 is CartLoading) {
                return Container(
                  child: Text('Загрузка'),
                );
              }
              return Container();
            },
          );
        }

        return Scaffold();
      },
    );
  }
}
