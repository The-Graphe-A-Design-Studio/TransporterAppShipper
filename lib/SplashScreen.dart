import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserTransporter userTransporter;
  String userType;

  Future<bool> doSomeAction() async {
    await Future.delayed(Duration(seconds: 2), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool("rememberMe");
    userType = prefs.getString("userType");
    if (rememberMe == true) {
      userTransporter =
          UserTransporter.fromJson(json.decode(prefs.getString("userData")));
    }
    return Future.value(rememberMe);
  }

  @override
  void initState() {
    super.initState();
    doSomeAction().then((value) {
      if (value == true) {
        Navigator.pushReplacementNamed(context, homePageTransporter,
            arguments: userTransporter);
      } else {
        Navigator.pushReplacementNamed(context, introLoginOptionPage);
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
