import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:shipperapp/CommonPages/LoadingBody.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/PostLoad.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class HomePageTransporter extends StatefulWidget {
  final UserTransporter userTransporter;

  HomePageTransporter({Key key, this.userTransporter}) : super(key: key);

  @override
  _HomePageTransporterState createState() => _HomePageTransporterState();
}

class _HomePageTransporterState extends State<HomePageTransporter> {
  List<PostLoad1> activeLoad;
  List<PostLoad1> inactiveLoad;
  bool loadData = true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  UserTransporter transporter;

  @override
  void initState() {
    final fcm = FirebaseMessaging();
    fcm.requestNotificationPermissions();
    fcm.configure();
    super.initState();
    fcm.getToken().then((value) => print(value));
    transporter = widget.userTransporter;
  }

  void getData() {
    HTTPHandler().getPostLoad([transporter.id, "0"]).then((value) {
      setState(() {
        inactiveLoad = [];
        inactiveLoad = value;
      });
    });
    HTTPHandler().getPostLoad([transporter.id, "1"]).then((value) {
      setState(() {
        activeLoad = [];
        activeLoad = value;
      });
    });
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpCustomer(
        [transporter.mobileNumber, prefs.getString('otp')]).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("rememberMe", true);
      prefs.setString("userData", value[1]);
      getData();
      setState(() {
        transporter = UserTransporter.fromJson(json.decode(value[1]));
      });
    });
  }

  void _onRefresh(BuildContext context) async {
    // monitor network fetch
    print('working properly');
    reloadUser();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    if (loadData) {
      loadData = false;
      getData();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: (activeLoad == null || inactiveLoad == null)
          ? LoadingBody()
          : Stack(
              children: [
                (activeLoad.length != 0)
                    ? SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () => _onRefresh(context),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 50.0),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    UrlLauncher.launch('tel:8488888822');
                                  },
                                  child: Container(
                                    width: 100.0,
                                    margin: const EdgeInsets.only(right: 20.0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 10.0,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black87,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text('Call Us'),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 20.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                color: Colors.black87,
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, postLoad,
                                            arguments: transporter)
                                        .then((value) {
                                      if (value != null) {
                                        if (value == true) {
                                          setState(() {
                                            loadData = true;
                                          });
                                        }
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Post a new load',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 5.0,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.0),
                              Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Previous Loads',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              Column(
                                children: activeLoad.map((e) {
                                  return Container(
                                    margin: const EdgeInsets.all(20.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: e.source
                                              .map((e1) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 15.0,
                                                            height: 15.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green[600],
                                                                width: 3.0,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.0),
                                                          Flexible(
                                                            child: Text(
                                                              e1,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 5.0,
                                                          vertical: 3.0,
                                                        ),
                                                        height: 5.0,
                                                        width: 1.5,
                                                        color: Colors.grey,
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 5.0,
                                                          vertical: 3.0,
                                                        ),
                                                        height: 5.0,
                                                        width: 1.5,
                                                        color: Colors.grey,
                                                      ),
                                                    ],
                                                  ))
                                              .toList(),
                                        ),
                                        Column(
                                          children: e.destination
                                              .map((e1) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 15.0,
                                                            height: 15.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .red[600],
                                                                width: 3.0,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10.0),
                                                          Flexible(
                                                            child: Text(
                                                              '$e1',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (e.destination
                                                              .indexOf(e1) !=
                                                          (e.destination
                                                                  .length -
                                                              1))
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 3.0,
                                                          ),
                                                          height: 5.0,
                                                          width: 1.5,
                                                          color: Colors.grey,
                                                        ),
                                                      if (e.destination
                                                              .indexOf(e1) !=
                                                          (e.destination
                                                                  .length -
                                                              1))
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 3.0,
                                                          ),
                                                          height: 5.0,
                                                          width: 1.5,
                                                          color: Colors.grey,
                                                        ),
                                                    ],
                                                  ))
                                              .toList(),
                                        ),
                                        SizedBox(height: 30.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Truck Type',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${e.truckPref}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 30.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Products',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${e.material}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () => _onRefresh(context),
                        child: ListView(
                          primary: true,
                          children: <Widget>[
                            SizedBox(
                              height: 80.0,
                            ),
                            Image(
                                image:
                                    AssetImage('assets/images/logo_white.png'),
                                height: 200.0),
                            SizedBox(height: 40.0),
                            if (transporter.planType != '2')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black,
                                child: Column(
                                  children: [
                                    Text(
                                      (transporter.planType == '1')
                                          ? 'You are on free trial!'
                                          : 'Your free trial has expired!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          subscription,
                                          arguments: transporter,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0,
                                          vertical: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Text(
                                          'Upgrade Now',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Let's Post a new Load",
                                style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Tap to post a new load",
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "for Shipping",
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, postLoad,
                                        arguments: transporter)
                                    .then((value) {
                                  if (value != null) {
                                    if (value == true) {
                                      setState(() {
                                        loadData = true;
                                      });
                                    }
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60.0,
                            ),
                            SizedBox(
                              height: 100.0,
                            ),
                          ],
                        ),
                      ),
                DraggableScrollableSheet(
                  initialChildSize: 0.08,
                  minChildSize: 0.08,
                  maxChildSize: 0.9,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
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
                        child: AccountBottomSheetLoggedIn(
                          scrollController: scrollController,
                          userTransporter: transporter,
                          activeLoads: activeLoad,
                          inactiveLoads: inactiveLoad,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
