import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:transportationapp/Models/User.dart';

class ViewTrucksOwner extends StatefulWidget {
  final UserOwner userOwner;

  ViewTrucksOwner({Key key, this.userOwner}) : super(key: key);

  @override
  _ViewTrucksOwnerState createState() => _ViewTrucksOwnerState();
}

class _ViewTrucksOwnerState extends State<ViewTrucksOwner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Spacer(),
              Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[],
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.08,
            minChildSize: 0.08,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Hero(
                tag: 'AnimeBottom',
                child: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    child: AccountBottomSheetLoggedIn(
                        scrollController: scrollController)),
              );
            },
          ),
        ],
      ),
    );
  }
}
