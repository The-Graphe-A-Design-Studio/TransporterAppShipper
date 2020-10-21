import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:shipperapp/CommonPages/LoadingBody.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/PostLoad.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';

class HomePageTransporter extends StatefulWidget {
  final UserTransporter userTransporter;

  HomePageTransporter({Key key, this.userTransporter}) : super(key: key);

  @override
  _HomePageTransporterState createState() => _HomePageTransporterState();
}

class _HomePageTransporterState extends State<HomePageTransporter> {
  List<PostLoad> activeLoad;
  List<PostLoad> inactiveLoad;
  bool loadData = true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    final fcm = FirebaseMessaging();
    fcm.requestNotificationPermissions();
    fcm.configure();
    super.initState();
    fcm.getToken().then((value) => print(value));
  }

  void getData() {
    HTTPHandler().getPostLoad([widget.userTransporter.id, "0"]).then((value) {
      setState(() {
        inactiveLoad = [];
        inactiveLoad = value;
      });
    });
    HTTPHandler().getPostLoad([widget.userTransporter.id, "1"]).then((value) {
      setState(() {
        activeLoad = [];
        activeLoad = value;
      });
    });
  }

  void _onRefresh(BuildContext context) async {
    // monitor network fetch
    print('working properly');
    getData();
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
      backgroundColor: Color(0xff252427),
      body: (activeLoad == null || inactiveLoad == null)
          ? LoadingBody()
          : Stack(
              children: [
                SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(context),
                  child: ListView(
                    primary: true,
                    children: <Widget>[
                      SizedBox(
                        height: 80.0,
                      ),
                      Image(
                          image: AssetImage('assets/images/newOrder.png'),
                          height: 300.0),
                      SizedBox(height: 20.0),
                      if (widget.userTransporter.planType != '2')
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Text(
                                (widget.userTransporter.planType == '1')
                                    ? 'You are on free trial!'
                                    : 'Your free trial has expired!',
                                style: TextStyle(
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
                                    arguments: widget.userTransporter,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    'Upgrade Now',
                                    style: TextStyle(color: Colors.white),
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
                            color: Colors.white,
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
                            color: Colors.white12,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "for Shipping",
                          style: TextStyle(
                            color: Colors.white12,
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
                                  arguments: widget.userTransporter)
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
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: Color(0xff252427),
                            size: 35.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: activeLoad.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              activeLoad[index].source.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              activeLoad[index].destination.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: inactiveLoad.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              inactiveLoad[index].source.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              inactiveLoad[index].destination.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
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
                        child: AccountBottomSheetLoggedIn(
                          scrollController: scrollController,
                          userTransporter: widget.userTransporter,
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
