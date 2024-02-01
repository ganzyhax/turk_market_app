import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
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
  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                const SizedBox(height: 25),
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
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
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
                              mainAxisSpacing: 20,
                            ),
                            itemCount: data!.length,
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
                        return Container();
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),
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
                BigCategory(
                  image:
                      'https://cdn.create.vista.com/api/media/medium/303332216/stock-photo-handsome-man-jeans-shirt-standing-hands-pockets-white?token=',
                  title: 'Для мужчин',
                ),
                SizedBox(
                  height: 10,
                ),
                BigCategory(
                  // https://image.khaleejtimes.com/?uuid=19e6bed3-9524-418f-a1cc-67400ede8778&function=cropresize&type=preview&source=false&q=75&crop_w=0.99999&crop_h=0.84375&x=0&y=0&width=1500&height=844
                  image:
                      'https://www.abouther.com/sites/default/files/2017/07/03/shutterstock_423857110.jpg',
                  // image:
                  //     'https://mykaleidoscope.ru/uploads/posts/2021-11/thumbs/1637109567_1-mykaleidoscope-ru-p-minimalizm-odezhda-zhenskaya-devushka-kras-1.png',
                  title: 'Для женщин',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
