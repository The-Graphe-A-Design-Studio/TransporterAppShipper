import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportationapp/HomePage.dart';
import 'package:transportationapp/IntroPageLoginOptions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn");

  runApp(isLoggedIn == null ? LoginOptionScreen() : HomePageScreen());
}

class LoginOptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transportation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff252427),
        canvasColor: Colors.transparent,
        accentColor: Colors.black12,
        accentColorBrightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroPageLoginOptions(),
    );
  }
}

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transportation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff252427),
        canvasColor: Colors.transparent,
        accentColor: Colors.black12,
        accentColorBrightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
