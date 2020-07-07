import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportationapp/MyConstants.dart';
import 'package:transportationapp/User.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserDriver userDriver;

  Future<bool> doSomeAction() async {
    await Future.delayed(Duration(seconds: 2), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool("rememberMe");
    if (rememberMe==true) {
      userDriver = UserDriver.fromJson(json.decode(prefs.getString("userDriver")));
    }
    return Future.value(rememberMe);
  }

  @override
  void initState() {
    super.initState();
    doSomeAction().then((value) {
      if (value == true) {
        Navigator.pushReplacementNamed(context, homePage, arguments: userDriver);
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
