import 'package:flutter/material.dart';
import 'package:transportationapp/IntroPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transportation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        canvasColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroPage(title: 'Transportation App'),
    );
  }
}