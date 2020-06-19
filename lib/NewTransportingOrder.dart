import 'package:flutter/material.dart';

class NewTransportingOrder extends StatefulWidget {
  NewTransportingOrder({Key key}) : super(key: key);

  @override
  _NewTransportingOrderState createState() => _NewTransportingOrderState();
}

class _NewTransportingOrderState extends State<NewTransportingOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Column(
        children: <Widget>[
          Spacer(),
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage('assets/images/newOrder.png'),
                        height: 300.0),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Let's Start a New Order",
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text("Tap to create a new Order",
                        style: TextStyle(
                          color: Colors.white12,
                          fontSize: 18.0,
                        )),
                    Text("for Transporting",
                        style: TextStyle(
                          color: Colors.white12,
                          fontSize: 18.0,
                        )),
                    SizedBox(
                      height: 40.0,
                    ),
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 35.0,
                      ),
                    )
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
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Align(
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
                )),
          ),
        ],
      ),
    );
  }
}
