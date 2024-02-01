import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkmarket_app/display/cart/bloc/cart_bloc.dart';
import 'package:turkmarket_app/display/categories/bloc/categories_bloc.dart';
import 'package:turkmarket_app/display/main/bloc/main_bloc.dart';
import 'package:turkmarket_app/display/main/main_screen.dart';
import 'package:turkmarket_app/display/payment/bloc/payment_bloc.dart';
import 'package:turkmarket_app/display/products/bloc/products_bloc.dart';
import 'package:turkmarket_app/display/profile/bloc/user_bloc.dart';
import 'package:turkmarket_app/firebase_options.dart';
import 'package:turkmarket_app/widgets/filter/bloc/filter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsBloc()..add(ProductLoad()),
        ),
        BlocProvider(
          create: (context) => UserBloc()..add(UserLoad()),
        ),
        BlocProvider(
          create: (context) => CategoriesBloc()..add(CategoriesLoad()),
        ),
        BlocProvider(
          create: (context) => FilterBloc()..add(FilterLoad()),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(context)..add(PaymentLoad()),
        ),
        BlocProvider(
          create: (context) => CartBloc()..add(CartLoad()),
        ),
        BlocProvider(
          create: (context) => MainBloc()..add(MainLoad()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
          textTheme: GoogleFonts.mulishTextTheme(),
        ),
        home: MainScreen(),
      ),
    );
  }
}
