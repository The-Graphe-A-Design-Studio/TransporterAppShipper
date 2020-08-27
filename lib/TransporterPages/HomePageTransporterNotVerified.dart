import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetUnknown.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';

class HomePageTransporterNotVerified extends StatefulWidget {
  final UserTransporter userTransporter;

  HomePageTransporterNotVerified({Key key, this.userTransporter})
      : super(key: key);

  @override
  _HomePageTransporterNotVerifiedState createState() =>
      _HomePageTransporterNotVerifiedState();
}

class _HomePageTransporterNotVerifiedState
    extends State<HomePageTransporterNotVerified> {
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
                          "Let's Post a new Load",
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text("Tap to post a new load",
                            style: TextStyle(
                              color: Colors.white12,
                              fontSize: 18.0,
                            )),
                        Text("for Shipping",
                            style: TextStyle(
                              color: Colors.white12,
                              fontSize: 18.0,
                            )),
                        SizedBox(
                          height: 40.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, postLoad);
                          },
                          child: FlatButton(
                            onPressed: () {
                              SharedPreferences.getInstance().then((value) {
                                var temp = value.getString(
                                    "DocNumber${widget.userTransporter.id}");
                                var passval = 0;
                                if (temp == "4") {
                                  passval = 4;
                                }
                                Navigator.pushNamed(
                                    context, uploadDocsTransporter, arguments: {
                                  'user': widget.userTransporter,
                                  'passValue': passval
                                });
                              });
                            },
                            child: Text("Upload Docs to Continue..."),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, postLoad);
                          },
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, postLoad,
                                  arguments: {
                                    'user': widget.userTransporter,
                                  });
                            },
                            child: Text("Post Load (Temp)"),
                            color: Colors.white,
                          ),
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    child: AccountBottomSheetUnknown(
                        scrollController: scrollController)),
              );
            },
          ),
        ],
      ),
    );
  }
}
