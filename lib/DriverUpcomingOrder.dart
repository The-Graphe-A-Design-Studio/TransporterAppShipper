import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transportationapp/AccountBottomSheetLoggedIn.dart';

final List<Color> imgList = [
  Colors.green,
  Colors.red,
  Colors.yellow,
  Colors.white,
  Colors.blue,
];

class DriverUpcomingOrder extends StatelessWidget {
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
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Orders",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40.0),
                  ),
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
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Color(0xff252427)),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Text("WB 02Q 9401"),
                                        ),
                                      ),
                                      Spacer(),
                                      Text("KOL"),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Icon(Icons.directions_car),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text("DEL"),
                                      SizedBox(width: 10.0),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Transporter Name",
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Column(
                                            children: [
                                              Text("Client"),
                                              Text("Transporter User"),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              Text("Date"),
                                              Text("15 May, 2020"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Pickup Address"),
                                  ),
                                  SizedBox(height: 5.0),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child:
                                    Text("Road 15a, Jheel Road, Bank plot"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Kolkata - 700075"),
                                  ),
                                  SizedBox(height: 15.0),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Delivery Address"),
                                  ),
                                  SizedBox(height: 5.0),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child:
                                    Text("Road 15a, Jheel Road, Bank plot"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Kolkata - 700075"),
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
                              top: 380.0,
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
                              top: 350.0,
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
                              top: 350.0,
                              right: -10,
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
                SizedBox(height: 100.0,),
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
