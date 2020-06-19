import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transportationapp/IntroPage.dart';

void main() async => {
  WidgetsFlutterBinding.ensureInitialized(),
  await SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp]),
  runApp(MyApp()),
};

class MyApp extends StatelessWidget {

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
      home: IntroPage(title: 'Transportation App'),
    );
  }
}