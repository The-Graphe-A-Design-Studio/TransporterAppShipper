import 'package:flutter/material.dart';

class AccountBottomSheetDummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:16.0, left: 16.0, right: 16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 60.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
