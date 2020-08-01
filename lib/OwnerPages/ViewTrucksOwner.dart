import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:transportationapp/Models/User.dart';
import 'package:transportationapp/MyConstants.dart';

final List<Color> imgList = [
  Colors.green,
  Colors.red,
  Colors.yellow,
  Colors.white,
  Colors.blue,
];

class ViewTrucksOwner extends StatefulWidget {
  final UserOwner userOwner;

  ViewTrucksOwner({Key key, this.userOwner}) : super(key: key);

  @override
  _ViewTrucksOwnerState createState() => new _ViewTrucksOwnerState();
}

class _ViewTrucksOwnerState extends State<ViewTrucksOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          Navigator.pushNamed(context, addTruckOwner, arguments: widget.userOwner);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40.0,
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 40.0,
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
                  items: imgList.map((imageLink) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              height: 500.0,
                              padding: EdgeInsets.all(22.0),
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Color(0xff252427)),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 4.0,
                                              right: 20.0,
                                              left: 20.0,
                                              bottom: 4.0),
                                          child: Text("Truck Category"),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.fiber_manual_record,
                                        color: Colors.green.withOpacity(0.6),
                                        size: 30.0,
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Truck Number",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Driver Name",
                                            style: TextStyle(
                                                color: Colors.blueGrey
                                                    .withOpacity(0.9)),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text("Some Name"),
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
                                                    .withOpacity(0.9)),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text("1000 Tons"),
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
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text("Change"),
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
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text("Change"),
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
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text("Change"),
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
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text("Change"),
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
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text("Change"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              child: const Divider(
                                color: Colors.black12,
                                height: 1,
                                thickness: 1,
                              ),
                              top: 420.0,
                              left: 0,
                              right: 0,
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(100.0),
                                      bottomRight: Radius.circular(100.0)),
                                  color: Color(0xff252427),
                                ),
                                height: 60.0,
                                width: 30.0,
                              ),
                              top: 390.0,
                              left: -10,
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(100.0),
                                      bottomLeft: Radius.circular(100.0)),
                                  color: Color(0xff252427),
                                ),
                                height: 60.0,
                                width: 30.0,
                              ),
                              top: 390.0,
                              right: -10,
                            ),
                            Positioned(
                              child: Row(
                                children: [
                                  FlatButton(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.file_upload,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          "Call - +91 XXXXX XXXXX",
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                        )
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              left: 55,
                              top: 440,
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
