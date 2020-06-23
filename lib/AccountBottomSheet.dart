import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AccountBottomSheet extends StatefulWidget {
  final ScrollController scrollController;

  AccountBottomSheet({Key key, @required this.scrollController})
      : super(key: key);

  @override
  _AccountBottomSheetState createState() => _AccountBottomSheetState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
    child: Container(
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'No. ${imgList.indexOf(item)} image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    ),
  ))
      .toList();

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
          SizedBox(height: 40.0,),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Upcoming Orders",
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Select an Order to view",
              style: TextStyle(
                color: Colors.black12,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            child: Column(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Orders",
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Select an Order to view",
              style: TextStyle(
                color: Colors.black12,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            height: 220.0,
            child: ListView(
              padding: EdgeInsets.only(right: 16.0, left: 16.0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white70, width: 3.0),
                      color: Color(0xff252427)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: Color(0xff252427),
                            size: 28.0,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Create New",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Tap to create new",
                          style: TextStyle(
                            color: Colors.white12,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white70, width: 3.0),
                      color: Color(0xff252427)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: Color(0xff252427),
                            size: 28.0,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Completed Order",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "March 15th 2020",
                          style: TextStyle(
                            color: Colors.white12,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white70, width: 3.0),
                      color: Color(0xff252427)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: Color(0xff252427),
                            size: 28.0,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Create New",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Tap to create new",
                          style: TextStyle(
                            color: Colors.white12,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
