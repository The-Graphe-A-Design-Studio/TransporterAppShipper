import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportationapp/DriverOptionsPage.dart';
import 'package:transportationapp/FadeTransition.dart';
import 'package:transportationapp/TransporterOptionsPage.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
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
                      Image(
                        image: AssetImage('assets/images/logo_white.png'),
                        height: 145.0,
                        width: 145.0,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Choose Your Account Type",
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
                            onTap: () => Navigator.push(
                                context, FadeRoute(page: TransporterOptionsPage())),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: MediaQuery.of(context).size.width * 0.38,
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 18.0, bottom: 10.0),
                                    child: Text(
                                      "Transporter",
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
                            onTap: () => Navigator.push(
                                context, FadeRoute(page: DriverOptionsPage())),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: MediaQuery.of(context).size.width * 0.38,
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 18.0, bottom: 10.0),
                                    child: Text(
                                      "Driver",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Hero(
              tag: 'AnimeBottom',
              child: Container(
                margin: EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                height: 60.0,
              ),
            ),
          ],
        ));
  }
}
