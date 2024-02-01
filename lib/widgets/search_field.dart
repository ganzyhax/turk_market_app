import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:turkmarket_app/constants.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/products/products_screen.dart';

class SearchField extends StatelessWidget {
  SearchField({
    this.withNavigation,
    super.key,
  });
  bool? withNavigation = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kcontentColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 5,
      ),
      child: Row(
        children: [
          const Icon(
            Ionicons.search,
            color: Colors.grey,
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: TextField(
              onSubmitted: (e) {
                BlocProvider.of<ProductsBloc>(context)
                  ..add(ProductsSearhInput(input: e));
                if (withNavigation == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsScreen()),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              decoration: InputDecoration(
                hintText: "Искать...",
                border: InputBorder.none,
              ),
            ),
          ),
          // (withFilter == true)
          //     ? Container(
          //         height: 25,
          //         width: 1.5,
          //         color: Colors.grey,
          //       )
          //     : Container(),
          // (withFilter == true)
          //     ? IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Ionicons.options_outline,
          //           color: Colors.grey,
          //         ),
          //       )
          //     : Container()
        ],
      ),
    );
  }
}
