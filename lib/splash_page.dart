import 'package:flutter/material.dart';
import 'package:journal_app_using_bloc/Home/ui/home_main.dart';
import 'package:journal_app_using_bloc/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToMain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome to My Journal App"),
      ),
    );
  }

  void navigateToMain() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeMain()));
  }
}
