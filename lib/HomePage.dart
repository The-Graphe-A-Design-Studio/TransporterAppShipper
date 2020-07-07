import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportationapp/AccountBottomSheetLoggedIn.dart';
import 'package:transportationapp/MyConstants.dart';
import 'package:transportationapp/User.dart';

class HomePage extends StatefulWidget {
  final UserDriver userDriver;
  HomePage({Key key, this.userDriver}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  signOut() async {
    await SharedPreferences.getInstance().then((value) => value.setBool("rememberMe", false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              SizedBox(
                height: 75.0,
              ),
              Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: "WhiteLogo",
                          child: Image(
                            image: AssetImage('assets/images/logo_white.png'),
                            height: 145.0,
                            width: 145.0,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "You Are Logged in : Name - ${widget.userDriver.dName}",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.35,
                            ),
                            GestureDetector(
                              onTap: () {
                                signOut();
                                Navigator.pushNamedAndRemoveUntil(context, introLoginOptionPage, (route) => false);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 18.0, bottom: 10.0),
                                      child: Text(
                                        "Sign Out",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                    child:
                        AccountBottomSheetLoggedIn(scrollController: scrollController)),
              );
            },
          ),
        ],
      ),
    );
  }
}
