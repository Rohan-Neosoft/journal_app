// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_app_using_bloc/Home/bloc/home_bloc.dart';
import 'package:journal_app_using_bloc/Home/ui/home_main.dart';
import 'package:journal_app_using_bloc/Utility/util.dart';
import 'package:journal_app_using_bloc/Wishlist/bloc/wishlist_bloc_bloc.dart';
import 'package:journal_app_using_bloc/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Util util = Util();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(props: util),
        ),
        BlocProvider<WishlistBlocBloc>(
          create: (context) => WishlistBlocBloc(props: util),
        ),
      ],
      child: MaterialApp(
        home: SplashPage(),
      ),
    );
  }
}
