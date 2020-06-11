
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransporterOptions extends StatelessWidget {

  TransporterOptions();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0)),
      ),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.65,
    );
  }
}
