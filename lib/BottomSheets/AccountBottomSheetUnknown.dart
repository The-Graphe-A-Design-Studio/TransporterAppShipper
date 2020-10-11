import 'package:flutter/material.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/User.dart';

class AccountBottomSheetUnknown extends StatefulWidget {
  final ScrollController scrollController;
  final UserTransporter userTransporter;

  AccountBottomSheetUnknown({
    Key key,
    @required this.scrollController,
    @required this.userTransporter,
  }) : super(key: key);

  @override
  _AccountBottomSheetUnknownState createState() =>
      _AccountBottomSheetUnknownState();
}

class _AccountBottomSheetUnknownState extends State<AccountBottomSheetUnknown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      children: [
        SizedBox(height: 20.0),
        Material(
          child: ListTile(
            onTap: () {
              HTTPHandler().signOut(
                context,
                userMobile: widget.userTransporter.mobileNumber,
              );
            },
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
    // return Padding(
    //   padding: EdgeInsets.only(left: 16.0, right: 16.0),
    //   child: ListView(
    //     controller: widget.scrollController,
    //     children: <Widget>[
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Container(
    //           width: 60.0,
    //           height: 4.0,
    //           decoration: BoxDecoration(
    //             color: Colors.grey,
    //             borderRadius: BorderRadius.circular(30.0),
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 40.0,
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(left: 16.0),
    //         child: Material(
    //           child: Text(
    //             "Plan Your Trip",
    //             style: TextStyle(
    //               fontSize: 23.0,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.black,
    //             ),
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 15.0,
    //       ),
    //       Container(
    //         height: 150.0,
    //         child: ListView(
    //           padding: EdgeInsets.only(right: 16.0, left: 16.0),
    //           scrollDirection: Axis.horizontal,
    //           children: <Widget>[
    //             Material(
    //               child: InkWell(
    //                 onTap: () {
    //                   Navigator.pushNamed(context, tripPlannerPage);
    //                 },
    //                 child: Container(
    //                   width: 160,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10.0),
    //                       border:
    //                           Border.all(color: Color(0xff252427), width: 3.0),
    //                       color: Colors.transparent),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: CircleAvatar(
    //                           radius: 30.0,
    //                           backgroundColor: Color(0xff252427),
    //                           child: Icon(
    //                             Icons.link,
    //                             color: Colors.white,
    //                             size: 30.0,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: Material(
    //                           child: Text(
    //                             "Trip Planner",
    //                             style: TextStyle(
    //                               fontSize: 16.0,
    //                               fontWeight: FontWeight.bold,
    //                               color: Color(0xff252427),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               width: 16.0,
    //             ),
    //             Material(
    //               child: InkWell(
    //                 onTap: () {
    //                   Navigator.pushNamed(context, freightCalculatorPage);
    //                 },
    //                 child: Container(
    //                   width: 160,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10.0),
    //                       border:
    //                           Border.all(color: Color(0xff252427), width: 3.0),
    //                       color: Colors.transparent),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: CircleAvatar(
    //                           radius: 30.0,
    //                           backgroundColor: Color(0xff252427),
    //                           child: Icon(
    //                             Icons.link,
    //                             color: Colors.white,
    //                             size: 30.0,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: Material(
    //                           child: Text(
    //                             "Freight Calculator",
    //                             style: TextStyle(
    //                               fontSize: 16.0,
    //                               fontWeight: FontWeight.bold,
    //                               color: Color(0xff252427),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               width: 16.0,
    //             ),
    //             Material(
    //               child: InkWell(
    //                 onTap: () {
    //                   Navigator.pushNamed(context, tollCalculatorPage);
    //                 },
    //                 child: Container(
    //                   width: 160,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10.0),
    //                       border:
    //                           Border.all(color: Color(0xff252427), width: 3.0),
    //                       color: Colors.transparent),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: CircleAvatar(
    //                           radius: 30.0,
    //                           backgroundColor: Color(0xff252427),
    //                           child: Icon(
    //                             Icons.link,
    //                             color: Colors.white,
    //                             size: 30.0,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: Material(
    //                           child: Text(
    //                             "Toll Calculator",
    //                             style: TextStyle(
    //                               fontSize: 16.0,
    //                               fontWeight: FontWeight.bold,
    //                               color: Color(0xff252427),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               width: 16.0,
    //             ),
    //             Material(
    //               child: InkWell(
    //                 onTap: () {
    //                   Navigator.pushNamed(context, emiCalculatorPage);
    //                 },
    //                 child: Container(
    //                   width: 160,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10.0),
    //                       border:
    //                           Border.all(color: Color(0xff252427), width: 3.0),
    //                       color: Colors.transparent),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: CircleAvatar(
    //                           radius: 30.0,
    //                           backgroundColor: Color(0xff252427),
    //                           child: Icon(
    //                             Icons.link,
    //                             color: Colors.white,
    //                             size: 30.0,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       Align(
    //                         alignment: Alignment.center,
    //                         child: Material(
    //                           child: Text(
    //                             "EMI Calculator",
    //                             style: TextStyle(
    //                               fontSize: 16.0,
    //                               fontWeight: FontWeight.bold,
    //                               color: Color(0xff252427),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 10.0,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       SizedBox(
    //         height: 20.0,
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(left: 16.0),
    //         child: Material(
    //           child: Text(
    //             "Verification Required",
    //             style: TextStyle(
    //               fontSize: 23.0,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.black,
    //             ),
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 20.0,
    //       ),
    //       Row(
    //         children: [
    //           Text("Sign Out"),
    //           Spacer(),
    //           FlatButton(
    //             onPressed: () {
    //               HTTPHandler().signOut(context);
    //             },
    //             child: Text("Link"),
    //           )
    //         ],
    //       ),
    //       SizedBox(
    //         height: 40.0,
    //       ),
    //     ],
    //   ),
    // );
  }
}
