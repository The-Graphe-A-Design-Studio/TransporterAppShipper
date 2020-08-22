import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';

class HomePageTransporter extends StatefulWidget {
  final UserTransporter userTransporter;
  HomePageTransporter({Key key, this.userTransporter}) : super(key: key);

  @override
  _HomePageTransporterState createState() => _HomePageTransporterState();
}

class _HomePageTransporterState extends State<HomePageTransporter> {
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
                      children: <Widget>[
                        Image(
                            image: AssetImage('assets/images/newOrder.png'),
                            height: 300.0),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "Customer Login",
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text("Tap to Add a New Truck",
                            style: TextStyle(
                              color: Colors.white12,
                              fontSize: 18.0,
                            )),
                        Text("for Transporting",
                            style: TextStyle(
                              color: Colors.white12,
                              fontSize: 18.0,
                            )),
                        SizedBox(
                          height: 40.0,
                        ),
                        FlatButton(
                          child: Text("Upload"),
                          onPressed: () {
                            Navigator.pushNamed(context, uploadDocsTransporter);
                          },
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
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
