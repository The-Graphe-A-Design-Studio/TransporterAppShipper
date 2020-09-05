import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';

class AccountBottomSheetLoggedIn extends StatefulWidget {
  final ScrollController scrollController;
  final UserTransporter userTransporter;

  AccountBottomSheetLoggedIn({
    Key key,
    @required this.scrollController,
    this.userTransporter,
  }) : super(key: key);

  @override
  _AccountBottomSheetLoggedInState createState() =>
      _AccountBottomSheetLoggedInState();
}

class _AccountBottomSheetLoggedInState
    extends State<AccountBottomSheetLoggedIn> {
  Map<dynamic, dynamic> map;

  Widget _listItem(String url, bool verified) => Stack(
        children: [
          Container(
            width: 150.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                image: NetworkImage('https://truckwale.co.in/$url'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(
                left: 14.0,
                bottom: 4.0,
              ),
              height: 20.0,
              width: 20.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.0,
                  color: Colors.white,
                ),
              ),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 10.0,
              ),
            ),
          ),
          if (verified)
            Container(
              width: 150.0,
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 10.0),
              child: Container(
                width: 80.0,
                height: 30.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )
        ],
      );

  @override
  void initState() {
    super.initState();
    HTTPHandler().getUserDocumentsData(widget.userTransporter.id).then((value) {
      setState(() {
        this.map = value;
      });
    }).catchError((e) {
      print(e);
    });
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
          ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage:
                  NetworkImage('https://truckwale.co.in/${map['selfie']}'),
            ),
            title: Text(
              widget.userTransporter.compName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '+${widget.userTransporter.mobileNumberCode} ${widget.userTransporter.mobileNumber}',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 30.0,
              left: 30.0,
            ),
            width: double.infinity,
            child: Text(
              'Upload all docs to be verified',
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            height: 175.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _listItem(
                  map['pan card'],
                  (map['pan card verified'].contains('1')) ? true : false,
                ),
                _listItem(
                  map['address front'],
                  (map['address front verified'].contains('1')) ? true : false,
                ),
                _listItem(
                  map['address back'],
                  (map['address back verified'].contains('1')) ? true : false,
                ),
                _listItem(
                  map['selfie'],
                  (map['selfie verified'].contains('1')) ? true : false,
                ),
                _listItem(
                  map['office address'],
                  (map['office address verified'].contains('1')) ? true : false,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          ListTile(
            leading: Icon(Icons.toc),
            title: Text(
              'Your Subscription',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'View Plan',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          ListTile(
            onTap: () {
              HTTPHandler().signOut(context);
            },
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 16.0),
          //   child: Material(
          //     child: Text(
          //       "Plan Your Trip",
          //       style: TextStyle(
          //         fontSize: 23.0,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 15.0,
          // ),
          // Container(
          //   height: 150.0,
          //   child: ListView(
          //     padding: EdgeInsets.only(right: 16.0, left: 16.0),
          //     scrollDirection: Axis.horizontal,
          //     children: <Widget>[
          //       Material(
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.pushNamed(context, tripPlannerPage);
          //           },
          //           child: Container(
          //             width: 160,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10.0),
          //                 border:
          //                     Border.all(color: Color(0xff252427), width: 3.0),
          //                 color: Colors.transparent),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: CircleAvatar(
          //                     radius: 30.0,
          //                     backgroundColor: Color(0xff252427),
          //                     child: Icon(
          //                       Icons.link,
          //                       color: Colors.white,
          //                       size: 30.0,
          //                     ),
          //                   ),
          //                 ),
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: Material(
          //                     child: Text(
          //                       "Trip Planner",
          //                       style: TextStyle(
          //                         fontSize: 16.0,
          //                         fontWeight: FontWeight.bold,
          //                         color: Color(0xff252427),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 10.0,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 16.0,
          //       ),
          //       Material(
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.pushNamed(context, freightCalculatorPage);
          //           },
          //           child: Container(
          //             width: 160,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10.0),
          //                 border:
          //                     Border.all(color: Color(0xff252427), width: 3.0),
          //                 color: Colors.transparent),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: CircleAvatar(
          //                     radius: 30.0,
          //                     backgroundColor: Color(0xff252427),
          //                     child: Icon(
          //                       Icons.link,
          //                       color: Colors.white,
          //                       size: 30.0,
          //                     ),
          //                   ),
          //                 ),
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: Material(
          //                     child: Text(
          //                       "Freight Calculator",
          //                       style: TextStyle(
          //                         fontSize: 16.0,
          //                         fontWeight: FontWeight.bold,
          //                         color: Color(0xff252427),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 10.0,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 16.0,
          //       ),
          //       Material(
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.pushNamed(context, tollCalculatorPage);
          //           },
          //           child: Container(
          //             width: 160,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10.0),
          //                 border:
          //                     Border.all(color: Color(0xff252427), width: 3.0),
          //                 color: Colors.transparent),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: CircleAvatar(
          //                     radius: 30.0,
          //                     backgroundColor: Color(0xff252427),
          //                     child: Icon(
          //                       Icons.link,
          //                       color: Colors.white,
          //                       size: 30.0,
          //                     ),
          //                   ),
          //                 ),
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: Material(
          //                     child: Text(
          //                       "Toll Calculator",
          //                       style: TextStyle(
          //                         fontSize: 16.0,
          //                         fontWeight: FontWeight.bold,
          //                         color: Color(0xff252427),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 10.0,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 16.0,
          //       ),
          //       Material(
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.pushNamed(context, emiCalculatorPage);
          //           },
          //           child: Container(
          //             width: 160,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10.0),
          //                 border:
          //                     Border.all(color: Color(0xff252427), width: 3.0),
          //                 color: Colors.transparent),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: CircleAvatar(
          //                     radius: 30.0,
          //                     backgroundColor: Color(0xff252427),
          //                     child: Icon(
          //                       Icons.link,
          //                       color: Colors.white,
          //                       size: 30.0,
          //                     ),
          //                   ),
          //                 ),
          //                 Spacer(),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: Material(
          //                     child: Text(
          //                       "EMI Calculator",
          //                       style: TextStyle(
          //                         fontSize: 16.0,
          //                         fontWeight: FontWeight.bold,
          //                         color: Color(0xff252427),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 10.0,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 20.0,
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 16.0),
          //   child: Material(
          //     child: Text(
          //       "Upcoming Orders",
          //       style: TextStyle(
          //         fontSize: 23.0,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 16.0),
          //   child: Material(
          //     child: Text(
          //       "Select an Order to view",
          //       style: TextStyle(
          //         color: Colors.black12,
          //         fontSize: 18.0,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 15.0,
          // ),
          // Container(
          //   child: Column(
          //     children: <Widget>[
          //       CarouselSlider(
          //         options: CarouselOptions(
          //           autoPlay: false,
          //           enableInfiniteScroll: false,
          //           aspectRatio: 2.0,
          //           enlargeCenterPage: true,
          //         ),
          //         items: imageSliders,
          //       ),
          //     ],
          //   ),
          // ),

          // SizedBox(
          //   height: 20.0,
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 16.0),
          //   child: Material(
          //     child: Text(
          //       "Temporary Links",
          //       style: TextStyle(
          //         fontSize: 23.0,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 15.0,
          // ),
          // Row(
          //   children: [
          //     Text(
          //         "Sign Out"
          //     ),
          //     Spacer(),
          //     FlatButton(
          //       onPressed: () {
          //         HTTPHandler().signOut(context);
          //       },
          //       child: Text("Link"),
          //     )
          //   ],
          // ),
          // SizedBox(
          //   height: 8.0,
          // ),
          // Row(
          //   children: [
          //     Text(
          //         "Order Summary Page"
          //     ),
          //     Spacer(),
          //     FlatButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, orderSummaryPage);
          //       },
          //       child: Text("Link"),
          //     )
          //   ],
          // ),
          // SizedBox(
          //   height: 8.0,
          // ),
          // Row(
          //   children: [
          //     Text(
          //         "Request Transport"
          //     ),
          //     Spacer(),
          //     FlatButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, requestTransportPage);
          //       },
          //       child: Text("Link"),
          //     )
          //   ],
          // ),
          // SizedBox(
          //   height: 40.0,
          // ),
        ],
      ),
    );
  }
}
