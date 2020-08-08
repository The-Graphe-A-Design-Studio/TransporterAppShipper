import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transportationapp/CommonPages/LoadingBody.dart';
import 'package:transportationapp/DialogScreens/DialogImageTruckDocsOwner.dart';
import 'package:transportationapp/HttpHandler.dart';
import 'package:transportationapp/Models/Truck.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:transportationapp/Models/User.dart';
import 'package:transportationapp/MyConstants.dart';

class ViewTrucksOwner extends StatefulWidget {
  final UserOwner userOwner;

  ViewTrucksOwner({Key key, this.userOwner}) : super(key: key);

  @override
  ViewTrucksOwnerState createState() => new ViewTrucksOwnerState();
}

class ViewTrucksOwnerState extends State<ViewTrucksOwner> {
  var temp = false;
  List<Truck> truckList;

  void postGetTrucksRequest(BuildContext _context) async {
    HTTPHandler().viewAllTrucks([widget.userOwner.oId]).then((value) {
      setState(() {
        truckList = value;
        temp = true;
      });
    }).catchError((error) {
      print("Error " + error.toString());
      Scaffold.of(_context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text("Network Error"),
        duration: Duration(seconds: 2),
      ));
    });
  }

  void postChangeTruckStatusRequest(BuildContext _context, int i,
      String status) async {
    HTTPHandler().changeTruckStatus([truckList[i].truckId, status]).then((
        value) {
      setState(() {
        truckList[i].truckActive = status == "1" ? true : false;
      });
    }).catchError((error) {
      print("Error?? " + error.toString());
      Scaffold.of(_context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text("Network Error"),
        duration: Duration(seconds: 2),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!temp) {
      temp = true;
      postGetTrucksRequest(context);
    }
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: (truckList == null)
          ? LoadingBody()
          : (truckList.isNotEmpty)
          ? Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 60.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            "Your",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 40.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            "Trucks",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 40.0),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, addTruckOwner,
                              arguments: widget.userOwner);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 35.0,
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 35.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                CarouselSlider(
                  items: truckList.map((truck) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              height: 500.0,
                              padding: EdgeInsets.all(22.0),
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              20),
                                          border: Border.all(
                                              color:
                                              Color(0xff252427)),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 4.0,
                                              right: 20.0,
                                              left: 20.0,
                                              bottom: 4.0),
                                          child:
                                          Text("Category : " +
                                              truck.truckCat.toString()),
                                        ),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: truck.truckActive,
                                        onChanged: (value) {
                                          print(value);
                                          postChangeTruckStatusRequest(
                                              context, truckList.indexOf(truck),
                                              value==true ? "1" : "0");
                                        },
                                        inactiveTrackColor: Colors.red
                                            .withOpacity(0.6),
                                        activeTrackColor: Colors.green
                                            .withOpacity(0.6),
                                        activeColor: Colors.white,
                                      ),
                                    ],
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        truck.truckNumber,
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.blueGrey,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          print("Edit");
                                          Navigator.pushNamed(context,
                                              editTrucksOwner,
                                              arguments:
                                              {"truck" : truck, "state" : this});
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: Text("Edit"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Driver Name",
                                            style: TextStyle(
                                                color: Colors.blueGrey
                                                    .withOpacity(
                                                    0.9)),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(truck.truckDriverName),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Capacity",
                                            style: TextStyle(
                                                color: Colors.blueGrey
                                                    .withOpacity(
                                                    0.9)),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(truck.truckLoad + " Tons"),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 1.0,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        "Driver License",
                                        style: TextStyle(
                                            color: Colors.blueGrey
                                                .withOpacity(0.9)),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          print("DL");
                                          DialogImageTruckDocs()
                                              .showCustomDialog(
                                              context, title: "Driver License",
                                              truckId: truck.truckId.toString(),
                                              fileName: "trk_dr_license_edit",
                                              srcURL: "https://truckwale.co.in/" + truck.truckDriverLicense.toString());
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: Text("View"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Truck RC",
                                        style: TextStyle(
                                            color: Colors.blueGrey
                                                .withOpacity(0.9)),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          print("RC");
                                          DialogImageTruckDocs()
                                              .showCustomDialog(
                                              context, title: "Truck RC",
                                              truckId: truck.truckId.toString(),
                                              fileName: "trk_rc_edit",
                                              srcURL: "https://truckwale.co.in/" + truck.truckRc.toString());
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: Text("View"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Truck Insurance",
                                        style: TextStyle(
                                            color: Colors.blueGrey
                                                .withOpacity(0.9)),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          print("TI");
                                          DialogImageTruckDocs()
                                              .showCustomDialog(
                                              context, title: "Truck Insurance",
                                              truckId: truck.truckId.toString(),
                                              fileName: "trk_insurance_edit",
                                              srcURL: "https://truckwale.co.in/" + truck.truckInsurance.toString());
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: Text("View"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Road Tax",
                                        style: TextStyle(
                                            color: Colors.blueGrey
                                                .withOpacity(0.9)),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          print("Tax");
                                          DialogImageTruckDocs()
                                              .showCustomDialog(
                                              context, title: "Road Tax",
                                              truckId: truck.truckId.toString(),
                                              fileName: "trk_road_tax_edit",
                                              srcURL: "https://truckwale.co.in/" + truck.truckRoadTax.toString());
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: Text("View"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "RTO Passing",
                                        style: TextStyle(
                                            color: Colors.blueGrey
                                                .withOpacity(0.9)),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          print("RTO");
                                          DialogImageTruckDocs()
                                              .showCustomDialog(
                                              context, title: "RTO Passing",
                                              truckId: truck.truckId.toString(),
                                              fileName: "trk_rto_edit",
                                              srcURL: "https://truckwale.co.in/" + truck.truckRTO.toString());
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: Text("View"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      FlatButton(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.file_upload,
                                              color: Colors.black
                                                  .withOpacity(0.7),
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              "Call +91 " +
                                                  truck.truckDriverPhone,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.7)),
                                            )
                                          ],
                                        ),
                                        onPressed: () {},
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          HTTPHandler().deleteTrucks(
                                              [truck.truckId]).then((value) {
                                            setState(() {
                                              temp = false;
                                            });
                                          });
                                        },
                                        child: Icon(Icons.delete, color: Colors
                                            .red.withOpacity(0.6),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 500.0,
                    reverse: false,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    initialPage: 0,
                    scrollDirection: Axis.horizontal,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                  ),
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
      )
          : Stack(
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
                            image: AssetImage(
                                'assets/images/newOrder.png'),
                            height: 300.0),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "Let's Add a New Truck",
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text("Tap to add a new Truck",
                            style: TextStyle(
                              color: Colors.white12,
                              fontSize: 18.0,
                            )),
                        Text("for Accepting Transport",
                            style: TextStyle(
                              color: Colors.white12,
                              fontSize: 18.0,
                            )),
                        SizedBox(
                          height: 40.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, addTruckOwner,
                                arguments: widget.userOwner);
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
            builder: (BuildContext context,
                ScrollController scrollController) {
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