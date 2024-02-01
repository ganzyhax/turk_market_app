import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';

class AdressCard extends StatelessWidget {
  const AdressCard(
      {super.key,
      required this.data,
      required this.index,
      required this.isEdit});
  final data;
  final index;
  final isEdit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return InkWell(
            onTap: () {
              if (!isEdit) {
                BlocProvider.of<UserBloc>(context)
                    .add(UserAdressChoose(index: index));
              }
            },
            child: Center(
              child: Stack(children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                      color: (isEdit == false && state.selectedAdress == index)
                          ? Colors.blue[50]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12, width: 1)),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(data['phone']),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(data['country'] +
                              ', ' +
                              data['city'] +
                              ', ' +
                              data['street'] +
                              ', ' +
                              data['postcode']),
                        ],
                      ),
                    ],
                  ),
                ),
                (isEdit)
                    ? Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            print(index);
                            BlocProvider.of<UserBloc>(context)
                                .add(UserAdressDelete(index: index));
                          },
                        ),
                      )
                    : Container(),
              ]),
            ),
          );
        }
        return Container();
      },
    );
  }
}
