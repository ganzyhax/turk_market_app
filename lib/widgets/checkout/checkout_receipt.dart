import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/widgets/adress_add.dart';
import 'package:turkmarket_app/widgets/adress_widget.dart';
import 'package:turkmarket_app/widgets/custom_button.dart';

class CheckoutReceipt extends StatelessWidget {
  const CheckoutReceipt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        TextEditingController name = TextEditingController();
        TextEditingController phone = TextEditingController();
        TextEditingController country = TextEditingController();
        TextEditingController adress = TextEditingController();
        TextEditingController city = TextEditingController();
        TextEditingController postcode = TextEditingController();
        if (state is UserLoaded) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26, width: 1)),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Итог'),
                    Text(state.totalSum.toString() + ' \$')
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Стоимость доставки'), Text('0 руб')],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Сумма к оплате',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text(
                          state.totalSum.toString() + ' \$',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${(int.parse(state.totalSum.toString()) * state.currency).toInt().toString()} руб",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Адрес доставки',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0)),
                              ),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: Column(
                                      children: state.userAdresses.map((data) {
                                        var index =
                                            state.userAdresses.indexOf(data);
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: AdressCard(
                                            isEdit: false,
                                            index: index,
                                            data: data,
                                            // Add any other customization or functionality you need for each entry
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: (!state.userAdresses.isEmpty)
                            ? Text('Изменить',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent))
                            : Container())
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                (!state.userAdresses.isEmpty)
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  state.userAdresses[state.selectedAdress]
                                      ['name'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 15,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  state.userAdresses[state.selectedAdress]
                                      ['phone'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                size: 15,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: Text(
                                  state.userAdresses[state.selectedAdress]
                                          ['country'] +
                                      ', ' +
                                      state.userAdresses[state.selectedAdress]
                                          ['city'] +
                                      ', ' +
                                      state.userAdresses[state.selectedAdress]
                                          ['street'] +
                                      ', ' +
                                      state.userAdresses[state.selectedAdress]
                                          ['postcode'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Center(
                        child: InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0)),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.2,
                                    child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              Text(
                                                'Добавьте адрес',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                controller: name,
                                                decoration: InputDecoration(
                                                    labelText: 'Имя'),
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                controller: phone,
                                                decoration: InputDecoration(
                                                    labelText: 'Телефон'),
                                                keyboardType:
                                                    TextInputType.phone,
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                controller: country,
                                                decoration: InputDecoration(
                                                    labelText: 'Страна'),
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                controller: city,
                                                decoration: InputDecoration(
                                                    labelText: 'Город'),
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                controller: adress,
                                                decoration: InputDecoration(
                                                    labelText: 'Адресс'),
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                controller: postcode,
                                                decoration: InputDecoration(
                                                    labelText: 'Индекс код'),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                              SizedBox(height: 16),
                                              CustomButton(
                                                  isEnable:
                                                      (name.text.length > 0)
                                                          ? true
                                                          : false,
                                                  function: () {
                                                    BlocProvider.of<UserBloc>(
                                                            context)
                                                        .add(UserAdressAdd(
                                                            name: name.text,
                                                            street: adress.text,
                                                            phone: phone.text,
                                                            postcode:
                                                                postcode.text,
                                                            city: city.text,
                                                            country:
                                                                country.text));

                                                    Navigator.pop(context);
                                                  },
                                                  title: 'Сохранить')
                                            ])),
                                  );
                                },
                              );
                            },
                            child: AdressAdd()))
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
