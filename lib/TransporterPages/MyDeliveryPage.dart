import 'package:flutter/material.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/Delivery.dart';
import 'package:shipperapp/Models/User.dart';

class MyDeliveryPage extends StatefulWidget {
  UserTransporter user;

  MyDeliveryPage({Key key, @required this.user}) : super(key: key);

  @override
  _MyDeliveryPageState createState() => _MyDeliveryPageState();
}

class _MyDeliveryPageState extends State<MyDeliveryPage> {
  List<Delivery> delivery;

  Widget item(String title, String value) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(height: 5.0),
        ],
      );

  @override
  void initState() {
    super.initState();
    HTTPHandler().myDel([widget.user.id]).then((value) {
      setState(() {
        this.delivery = value;
        print('some ${value[0].deliveryTrucks.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Deliveries'),
      ),
      body: (delivery == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              children: delivery
                  .map((e) => Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: e.deliveryTrucks
                              .map((d) => item(
                                  '${d.driverName} (${d.deleteTruckId})',
                                  d.otp))
                              .toList(),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
