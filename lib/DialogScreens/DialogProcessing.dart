import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogProcessing {
  static DialogProcessing _instance = new DialogProcessing.internal();
  BuildContext context;
  String title;
  String text;

  DialogProcessing.internal();

  factory DialogProcessing() => _instance;

  Widget showCustomDialog(BuildContext context, {String title, String text}) {
    this.context = context;
    this.title = title;
    this.text = text;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () {return Future.value(false);},
            child: AlertDialog(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              backgroundColor: Colors.transparent,
              content: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 100.0, bottom: 16.0, left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 16.0,
                    right: 16.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
