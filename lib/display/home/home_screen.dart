import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/display/splash/splash_screen.dart';
import 'package:turkmarket_app/models/product.dart';
import 'package:turkmarket_app/widgets/big_category.dart';
import 'package:turkmarket_app/widgets/brands.dart';
import 'package:turkmarket_app/widgets/categories.dart';
import 'package:turkmarket_app/widgets/home_appbar.dart';
import 'package:turkmarket_app/widgets/home_slider.dart';
import 'package:turkmarket_app/widgets/product_card.dart';
import 'package:turkmarket_app/widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final int _perPage = 6;
  bool canLoad = true;
  DocumentSnapshot? _lastDocument;
  ScrollController _scrollController = ScrollController();
  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController();
  List<DocumentSnapshot> _data = [];
  int currentSlide = 0;
  bool loading = false;
  Query query = FirebaseFirestore.instance.collection('products').limit(6);
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  _loadData() {
    query = FirebaseFirestore.instance.collection('products').limit(_perPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    query.snapshots().listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _data.addAll(snapshot.docs);
        _data.toSet().toList();
        _streamController.add(_data);
        canLoad = true;
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      log('SCROLL TICK');
      if (canLoad) {
        canLoad = false;

        _loadData();
      } else {
        print('loading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kscaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                const SizedBox(height: 20),
                SearchField(
                  withNavigation: true,
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display a loading indicator
                    }
                    if (!snapshot.hasData) {
                      return Text('No data available');
                    }
                    final data = snapshot.data?.docs;

                    return Categories(
                      data: data,
                    );
                  },
                ),
                const SizedBox(height: 25),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('banners')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display a loading indicator
                    }
                    if (!snapshot.hasData) {
                      return Text('No data available');
                    }
                    final data = snapshot.data?.docs;
                    return HomeSlider(
                      data: data,
                      onChange: (value) {
                        setState(() {
                          currentSlide = value;
                        });
                      },
                      currentSlide: currentSlide,
                    );
                  },
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('brands')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display a loading indicator
                    }
                    if (!snapshot.hasData) {
                      return Text('No data available');
                    }
                    final data = snapshot.data?.docs;

                    return Brands(
                      data: data,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Категории",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Показать все"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categoryBanners')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display a loading indicator
                    }
                    if (!snapshot.hasData) {
                      return Text('No data available');
                    }
                    final data = snapshot.data?.docs;
                    return SizedBox(
                      height: (data!.length == 1)
                          ? 200
                          : (data!.length == 2)
                              ? 400
                              : (data!.length == 3)
                                  ? 600
                                  : (data!.length == 4)
                                      ? 800
                                      : (data!.length == 5)
                                          ? 1000
                                          : (data!.length == 6)
                                              ? 1200
                                              : 1400,
                      child: ListView.builder(
                        itemCount: data!.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: BigCategory(
                              title: data[index]['category'],
                              image: data[index]['image'],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "В тренде",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Показать все"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                StreamBuilder<List<DocumentSnapshot>>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display a loading indicator
                    }
                    if (!snapshot.hasData) {
                      return Text('No data available');
                    }

                    final data = snapshot.data!;
                    _lastDocument = data[data.length - 1];
                    return BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoaded) {
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 110,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                curr: state.currency,
                                product: data[index],
                                isLiked:
                                    (state.userLikes.contains(data[index]['id'])
                                        ? true
                                        : false),
                              );
                            },
                          );
                        }
                        return SplashScreen();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
