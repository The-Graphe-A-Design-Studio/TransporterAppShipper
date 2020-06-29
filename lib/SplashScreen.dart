import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportationapp/FadeTransition.dart';
import 'package:transportationapp/HomePage.dart';
import 'package:transportationapp/IntroPageLoginOptions.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> doSomeAction() async {
    await Future.delayed(Duration(seconds: 2), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn");
    return Future.value(isLoggedIn);
  }

  @override
  void initState() {
    super.initState();
    doSomeAction().then((value) {
      if (value == true) {
        Navigator.of(context).pushReplacement(FadeRoute(page: HomePage()));
      } else {
        Navigator.pushReplacement(
            context, FadeRoute(page: IntroPageLoginOptions()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Center(
        child: Hero(
          tag: "WhiteLogo",
          child: Image(
            image: AssetImage('assets/images/logo_white.png'),
            height: 200.0,
            width: 200.0,
          ),
        ),
      ),
    );
  }
}
