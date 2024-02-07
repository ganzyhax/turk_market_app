import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/product/bloc/product_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/models/product.dart';
import 'package:turkmarket_app/widgets/custom_snackbar.dart';
import 'package:turkmarket_app/widgets/product_widgets/add_to_cart.dart';
import 'package:turkmarket_app/widgets/product_widgets/appbar.dart';
import 'package:turkmarket_app/widgets/product_widgets/image_slider.dart';
import 'package:turkmarket_app/widgets/product_widgets/information.dart';
import 'package:turkmarket_app/widgets/product_widgets/product_desc.dart';

class ProductScreen extends StatefulWidget {
  final product;
  final bool isLiked;
  final double curr;
  const ProductScreen(
      {super.key,
      required this.product,
      required this.isLiked,
      required this.curr});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int currentImage = 0;
  int currentColor = 0;
  int currentSize = 0;
  int currentNumber = 1;
  int maxQuandtity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      floatingActionButton: (widget
                  .product['colors'][currentColor]['colorSizes'].length >
              0)
          ? AddToCart(
              currentNumber: currentNumber,
              onAdd: () {
                setState(() {
                  if (currentNumber != maxQuandtity) {
                    currentNumber++;
                  }
                });
              },
              onRemove: () {
                if (currentNumber != 1) {
                  setState(() {
                    currentNumber--;
                  });
                }
              },
              onAddBucket: () {
                BlocProvider.of<UserBloc>(context).add(UserAddBucket(
                  color: widget.product['colors'][currentColor]['colorName'],
                  id: widget.product['id'],
                  count: currentNumber.toString(),
                  size: widget.product['colors'][currentColor]['colorSizes']
                      [currentSize],
                ));
                setState(() {
                  currentImage = 0;
                  currentColor = 0;
                  currentSize = 0;
                  currentNumber = 1;
                  maxQuandtity = 1;
                });
                CustomSnackbar.show(context, 'Успешно добавилось в корзину!');
              },
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocProvider(
        create: (context) => ProductBloc()..add(ProductLoad()),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoaded) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductAppBar(id: widget.product['id'].toString()),
                      ImageSlider(
                        images: widget.product['colors'][currentColor]
                            ['colorImages'],
                        onChange: (index) {
                          setState(() {
                            currentImage = index;
                          });
                        },
                        currentImage: currentImage,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          1,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: currentImage == index ? 15 : 8,
                            height: 1,
                            margin: const EdgeInsets.only(right: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              color: currentImage == index
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 20,
                          right: 20,
                          bottom: 100,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductInfo(
                              product: widget.product,
                              curr: widget.curr,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Цвет',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis
                                  .horizontal, // This makes it scroll horizontally
                              child: Row(
                                children: List.generate(
                                  widget.product['colors'].length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentColor = index;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: currentColor == index
                                              ? Border.all(
                                                  color: Colors.black,
                                                  width: 2,
                                                )
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.product['colors'][index]
                                                ['colorName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Размер",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            (widget
                                        .product['colors'][currentColor]
                                            ['colorSizes']
                                        .length >
                                    0)
                                ? Row(
                                    children: List.generate(
                                      widget
                                          .product['colors'][currentColor]
                                              ['colorSizes']
                                          .length,
                                      (index) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentNumber = 1;
                                              currentSize = index;
                                              maxQuandtity = int.parse(
                                                  widget.product['colors']
                                                          [currentColor]
                                                      ['sizesCount'][index]);
                                            });
                                          },
                                          child: (widget
                                                      .product['colors']
                                                          [currentColor]
                                                          ['colorSizes'][index]
                                                      .length <
                                                  4)
                                              ? AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  width: 40,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: currentSize == index
                                                        ? Colors.white
                                                        : Color.fromARGB(
                                                            15, 43, 43, 45),
                                                    border: currentSize == index
                                                        ? Border.all(
                                                            color: Colors.black,
                                                            width: 2,
                                                          )
                                                        : null,
                                                  ),
                                                  padding: currentSize == index
                                                      ? const EdgeInsets.all(2)
                                                      : null,
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          15, 56, 56, 60),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(widget
                                                                      .product[
                                                                  'colors']
                                                              [currentColor][
                                                          'colorSizes'][index]),
                                                    ),
                                                  ),
                                                )
                                              : AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  width: 110,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                    color: currentSize == index
                                                        ? Colors.white
                                                        : Color.fromARGB(
                                                            15, 43, 43, 45),
                                                    border: currentSize == index
                                                        ? Border.all(
                                                            color: Colors.black,
                                                            width: 2,
                                                          )
                                                        : null,
                                                  ),
                                                  padding: currentSize == index
                                                      ? const EdgeInsets.all(2)
                                                      : null,
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          15, 56, 56, 60),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Center(
                                                      child: Text(widget
                                                                      .product[
                                                                  'colors']
                                                              [currentColor][
                                                          'colorSizes'][index]),
                                                    ),
                                                  ),
                                                )),
                                    ),
                                  )
                                : Text('Нет в наличии'),
                            const SizedBox(height: 20),
                            ProductDescription(
                                text: widget.product['description']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
