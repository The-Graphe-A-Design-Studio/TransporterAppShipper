
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpIn extends StatefulWidget {
  SignUpIn({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpInState createState() => _SignUpInState();
}

class _SignUpInState extends State<SignUpIn> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
