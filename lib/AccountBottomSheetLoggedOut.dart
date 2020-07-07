import 'package:flutter/material.dart';
import 'package:transportationapp/EmiCalculator.dart';
import 'package:transportationapp/FadeTransition.dart';
import 'package:transportationapp/FreightCalculator.dart';
import 'package:transportationapp/TollCalculator.dart';
import 'package:transportationapp/TripPlanner.dart';

class AccountBottomSheetLoggedOut extends StatefulWidget {
  final ScrollController scrollController;

  AccountBottomSheetLoggedOut({Key key, @required this.scrollController})
      : super(key: key);

  @override
  _AccountBottomSheetLoggedOutState createState() =>
      _AccountBottomSheetLoggedOutState();
}

class _AccountBottomSheetLoggedOutState
    extends State<AccountBottomSheetLoggedOut> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        controller: widget.scrollController,
        children: <Widget>[
          Align(
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
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Material(
              child: Text(
                "Plan Your Trip",
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            height: 150.0,
            child: ListView(
              padding: EdgeInsets.only(right: 16.0, left: 16.0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, FadeRoute(page: TripPlanner()));
                    },
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Color(0xff252427), width: 3.0),
                          color: Colors.transparent),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Color(0xff252427),
                              child: Icon(
                                Icons.link,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Material(
                              child: Text(
                                "Trip Planner",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252427),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context, FadeRoute(page: FreightCalculator()));
                    },
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Color(0xff252427), width: 3.0),
                          color: Colors.transparent),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Color(0xff252427),
                              child: Icon(
                                Icons.link,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Material(
                              child: Text(
                                "Freight Calculator",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252427),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context, FadeRoute(page: TollCalculator()));
                    },
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Color(0xff252427), width: 3.0),
                          color: Colors.transparent),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Color(0xff252427),
                              child: Icon(
                                Icons.link,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Material(
                              child: Text(
                                "Toll Calculator",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252427),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, FadeRoute(page: EmiCalculator()));
                    },
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Color(0xff252427), width: 3.0),
                          color: Colors.transparent),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Color(0xff252427),
                              child: Icon(
                                Icons.link,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Material(
                              child: Text(
                                "EMI Calculator",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff252427),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Material(
              child: Text(
                "Please Login to Continue...",
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }
}
