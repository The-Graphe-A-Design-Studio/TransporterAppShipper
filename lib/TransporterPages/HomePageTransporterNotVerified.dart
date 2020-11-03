import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetUnknown.dart';
import 'package:shipperapp/HttpHandler.dart';
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  UserTransporter transporter;

  void _onRefresh(BuildContext context) async {
    print('working properly');
    await Future.delayed(Duration(milliseconds: 1000));
    reloadUser();
    checkStatus();
    _refreshController.refreshCompleted();
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpCustomer(
        [transporter.mobileNumber, prefs.getString('otp')]).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("rememberMe", true);
      prefs.setString("userData", value[1]);
      setState(() {
        transporter = UserTransporter.fromJson(json.decode(value[1]));
      });
    });
  }

  checkStatus() {
    if (transporter.verified == "1") {
      Navigator.pushReplacementNamed(context, homePageTransporter,
          arguments: transporter);
    }
  }

  @override
  void initState() {
    super.initState();
    transporter = widget.userTransporter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SmartRefresher(
            controller: _refreshController,
            onRefresh: () => _onRefresh(context),
            child: Column(
              children: <Widget>[
                Spacer(),
                Center(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage('assets/images/logo_white.png'),
                              height: 200.0),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            "Let's Post a new Load",
                            style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text("Tap to post a new load",
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 18.0,
                              )),
                          Text("for Shipping",
                              style: TextStyle(
                                color: Colors.black38,
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
                                  var temp = value
                                      .getString("DocNumber${transporter.id}");
                                  var passval = 0;
                                  if (temp == "4") {
                                    passval = 4;
                                  }
                                  Navigator.pushNamed(
                                      context, uploadDocsTransporter,
                                      arguments: {
                                        'user': transporter,
                                        'passValue': passval
                                      });
                                });
                              },
                              child: Text(
                                "Upload Docs to Continue...",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
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
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    child: AccountBottomSheetUnknown(
                      scrollController: scrollController,
                      userTransporter: transporter,
                    )),
              );
            },
          ),
        ],
      ),
    );
  }
}
