import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/gateway/functoins.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msg = TextEditingController();
  _chatBubble(var text, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                            'https://icones.pro/wp-content/uploads/2021/02/icone-utilisateur-orange.png'),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage('images/akhi.jpg'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: msg,
              decoration: InputDecoration.collapsed(
                hintText: 'Отправить сообщения',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: kPrimaryColor,
            ),
            iconSize: 25,
            color: Colors.black,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String id = await prefs.getString('id') ?? '';
              if (id == '') {
                id = await HelpFunctions().getDeviceId();
              }
              var collection = FirebaseFirestore.instance.collection('chats');
              var query = await collection.doc(id + '?chat').get();
              List<dynamic> userSearchItems;
              if (query.exists) {
                userSearchItems = query['chating'];
                userSearchItems.add(msg.text);
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(id + '?chat')
                    .set({
                  "name": 'User',
                  "id": id,
                  "chating": userSearchItems,
                });
                msg.text = '';
              } else {
                FirebaseFirestore.instance
                    .collection('chats')
                    .doc(id + '?chat')
                    .set({
                  "name": 'User',
                  "id": id,
                  "chating": [msg.text],
                });
                msg.text = '';
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'TurkMarket Поддержка',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              TextSpan(text: '.'),
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: BlocProvider(
        create: (context) => UserBloc()..add(UserLoad()),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              print(state.userId);
              return Column(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .doc(state.userId + '?chat')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            print('noData');
                            return SizedBox();
                          } else {
                            var userDocument = snapshot.data.data();

                            try {
                              return ListView.builder(
                                reverse: false,
                                padding: EdgeInsets.all(20),
                                itemCount: userDocument['chating'] != null
                                    ? userDocument['chating'].length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  if (userDocument['chating'][index]
                                      .toString()
                                      .contains('}sup')) {
                                    print(userDocument['chating'][index]);
                                    return _chatBubble(
                                        userDocument['chating'][index]
                                            .toString()
                                            .split('}')[0],
                                        false,
                                        true);
                                  } else {
                                    return _chatBubble(
                                        userDocument['chating'][index]
                                            .toString()
                                            .split('}')[0],
                                        true,
                                        true);
                                  }
                                },
                              );
                            } catch (e) {}
                            return Text('Чат');
                          }
                        }),
                  ),
                  _sendMessageArea(),
                ],
              );
            }
            return Container(
              child: Text('NOT LOADED'),
            );
          },
        ),
      ),
    );
  }
}
