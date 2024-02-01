import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turkmarket_app/display/orders/components/orders_detail.dart';

class OrderCard extends StatelessWidget {
  final data;
  const OrderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Timestamp firestoreTimestamp = data['createdAt'];

    // Convert Timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      firestoreTimestamp.seconds * 1000 +
          (firestoreTimestamp.nanoseconds / 1000000).round(),
    );

    // Format the DateTime object to the desired format
    String formattedDateTime = DateFormat('dd MMM yyyy HH:mm').format(dateTime);

    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12, width: 1)),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: Colors.black,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            'Статус',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            (data['status'] == 'inprocess')
                                ? 'Рассмотрение'
                                : '?',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersDetail(
                                    data: data,
                                  )),
                        );
                      },
                      child: Icon(Icons.keyboard_arrow_right_outlined))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        color: Colors.black,
                        size: 28,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('Заказ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          Text(data['id'].toString().substring(0, 11) + '...',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        color: Colors.black,
                        size: 28,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('Дата',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          Text(formattedDateTime,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}
