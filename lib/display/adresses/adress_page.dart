import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/widgets/adress_add.dart';
import 'package:turkmarket_app/widgets/adress_widget.dart';
import 'package:turkmarket_app/widgets/custom_button.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController country = TextEditingController();
    TextEditingController adress = TextEditingController();
    TextEditingController city = TextEditingController();
    TextEditingController postcode = TextEditingController();
    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        backgroundColor: kcontentColor,
        centerTitle: true,
        title: const Text(
          "Мой аккаунт",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 60,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Мои адреса',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: state.userAdresses.map((data) {
                      var index = state.userAdresses.indexOf(data);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: AdressCard(
                          isEdit: true,
                          index: index,
                          data: data,
                          // Add any other customization or functionality you need for each entry
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
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
                                return SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.2,
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
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
                                                    function: () {
                                                      BlocProvider.of<UserBloc>(
                                                              context)
                                                          .add(UserAdressAdd(
                                                              name: name.text,
                                                              street:
                                                                  adress.text,
                                                              phone: phone.text,
                                                              postcode:
                                                                  postcode.text,
                                                              city: city.text,
                                                              country: country
                                                                  .text));
                                                      Navigator.pop(context);
                                                    },
                                                    title: 'Сохранить')
                                              ])),
                                    ),
                                  ),
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
      ),
    );
  }
}
