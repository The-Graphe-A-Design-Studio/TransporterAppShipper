import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shipperapp/DialogScreens/DialogFailed.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/Delivery.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MyDeliveryPage extends StatefulWidget {
  final UserTransporter user;

  MyDeliveryPage({Key key, @required this.user}) : super(key: key);

  @override
  _MyDeliveryPageState createState() => _MyDeliveryPageState();
}

class _MyDeliveryPageState extends State<MyDeliveryPage> {
  List<Delivery> delivery;
  Razorpay _razorpay;
  Razorpay _razorPayRemaining;
  Delivery selected;
  bool loadingDone = false;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Id => ${response.paymentId}');
    print('Order Id => ${response.orderId}');
    print('Signature => ${response.signature}');

    DialogProcessing().showCustomDialog(context,
        title: "Processing Payment", text: "Processing, Please Wait!");
    HTTPHandler()
        .storeLoadPaymentData(
            widget.user, selected.payment['advance amount']['pay id'], true,
            paymentResponse: response)
        .then((value) async {
      Navigator.of(context).pop();
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Advance Payment");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        getMyDels();
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Advance Payment", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((e) async {
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Advance payment", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void _handlePaymentSuccessRem(PaymentSuccessResponse response) {
    print('Payment Id => ${response.paymentId}');
    print('Order Id => ${response.orderId}');
    print('Signature => ${response.signature}');

    DialogProcessing().showCustomDialog(context,
        title: "Processing Payment", text: "Processing, Please Wait!");
    HTTPHandler()
        .storeLoadPaymentData(
            widget.user, selected.payment['remaining amount']['pay id'], true,
            paymentResponse: response)
        .then((value) async {
      Navigator.of(context).pop();
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Remaining Payment");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        getMyDels();
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Remaining Payment", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((e) async {
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Remaining payment", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed('/Home');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed('/Home');
  }

  void _openCheckOut(Delivery d, String amt) async {
    selected = d;
    HTTPHandler()
        .generateRazorpayOrderId((double.parse(amt) * 100).round())
        .then((value) {
      var options = {
        'key': RAZORPAY_ID,
        'amount': (double.parse(amt) * 100).round(),
        'order_id': value,
        'name': widget.user.compName,
        'description': 'TruckWale',
        'prefill': {
          'contact': widget.user.mobileNumber,
          'email': 'rishav@thegraphe.com',
        },
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e);
        throw e;
      }
    });
  }

  void _openCheckOutRem(Delivery d, String amt) async {
    selected = d;
    HTTPHandler()
        .generateRazorpayOrderId((double.parse(amt) * 100).round())
        .then((value) {
      var options = {
        'key': RAZORPAY_ID,
        'amount': (double.parse(amt) * 100).round(),
        'order_id': value,
        'name': widget.user.compName,
        'description': 'TruckWale',
        'prefill': {
          'contact': widget.user.mobileNumber,
          'email': 'rishav@thegraphe.com',
        },
      };

      try {
        _razorPayRemaining.open(options);
      } catch (e) {
        debugPrint(e);
        throw e;
      }
    });
  }

  getMyDels() {
    HTTPHandler().myDel([widget.user.id]).then((value) {
      setState(() {
        this.delivery = value;
        // print('some ${value[0].deliveryTrucks.length}');
        loadingDone = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _razorPayRemaining = Razorpay();
    _razorPayRemaining.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessRem);
    _razorPayRemaining.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPayRemaining.on(
        Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    getMyDels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Deliveries'),
      ),
      body: (delivery == null && !loadingDone)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (delivery == null && loadingDone)
              ? Center(
                  child: Text(
                    'No Deliveries Yet',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Column(
                  children: delivery
                      .map((e) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 15.0,
                                          height: 15.0,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.green[600],
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          '${e.load.sources[0].city}, ${e.load.sources[0].state}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 3.0,
                                      ),
                                      height: 5.0,
                                      width: 1.5,
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 3.0,
                                      ),
                                      height: 5.0,
                                      width: 1.5,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 15.0,
                                          height: 15.0,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.red[600],
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(
                                          '${e.load.destinations[e.load.destinations.length - 1].city}, ${e.load.destinations[e.load.destinations.length - 1].state}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Truck Type',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              '${e.load.truckPreferences}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 30.0),
                                        Text(
                                          '${e.load.truckTypes[0]}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Cost',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              'Rs. ${e.totalPrice}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 30.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Payment Method',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              '${e.modeName}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (e.modeName == 'Advance Pay')
                                          SizedBox(width: 30.0),
                                        if (e.modeName == 'Advance Pay')
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Advance Amount',
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                '${e.payment['advance amount']['amount']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    // SizedBox(height: 20.0),
                                    Divider(),
                                    if (e.modeName == 'Advance Pay' &&
                                        e.payment['advance amount']['status'] ==
                                            '0')
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: RaisedButton(
                                          color: Colors.black,
                                          child: Text(
                                            'Pay Advance',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () => _openCheckOut(
                                              e,
                                              e.payment['advance amount']
                                                  ['amount']),
                                        ),
                                      ),
                                    if ((e.modeName == 'Advance Pay' &&
                                            e.payment['advance amount']
                                                    ['status'] ==
                                                '1') ||
                                        e.modeName ==
                                            'Pay full after unloading')
                                      if (e.deliveryTrucksStatus == '0')
                                        Text(
                                            'Trucks will be assigned soon by the owner.')
                                      else
                                        Column(
                                          children: e.deliveryTrucks
                                              .map(
                                                (t) => Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Driver Details ${e.deliveryTrucks.indexOf(t) + 1}',
                                                      style: TextStyle(
                                                        fontSize: 13.0,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          UrlLauncher.launch(
                                                              "tel:${t.driverPhone}"),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.call),
                                                          SizedBox(width: 5.0),
                                                          Text(
                                                            '${t.driverName}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' (OTP - ${t.otp} )',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (e.deliveryTrucks
                                                            .indexOf(t) !=
                                                        e.deliveryTrucks
                                                                .length -
                                                            1)
                                                      SizedBox(height: 10.0),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        )
                                  ],
                                ),
                                if ((e.modeName == 'Advance Pay' &&
                                        e.payment['advance amount']['status'] ==
                                            '1') ||
                                    (e.modeName == 'Pay full after unloading' &&
                                        e.payment['remaining amount']
                                                ['status'] ==
                                            '0'))
                                  SizedBox(height: 20.0),
                                if ((e.modeName == 'Advance Pay' &&
                                        e.payment['advance amount']['status'] ==
                                            '1') ||
                                    (e.modeName == 'Pay full after unloading' &&
                                        e.payment['remaining amount']
                                                ['status'] ==
                                            '0'))
                                  Text(
                                    'Pay Remaining Amount',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                if ((e.modeName == 'Advance Pay' &&
                                        e.payment['advance amount']['status'] ==
                                            '1') ||
                                    (e.modeName == 'Pay full after unloading' &&
                                        e.payment['remaining amount']
                                                ['status'] ==
                                            '0'))
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RaisedButton(
                                        color: Colors.black,
                                        child: Text(
                                          'Online',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () => _openCheckOutRem(
                                            e,
                                            e.payment['remaining amount']
                                                ['amount']),
                                      ),
                                      SizedBox(width: 30.0),
                                      RaisedButton(
                                        color: Colors.black,
                                        child: Text(
                                          'Cash',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          DialogProcessing().showCustomDialog(
                                              context,
                                              title: "Processing Payment",
                                              text: "Processing, Please Wait!");
                                          HTTPHandler()
                                              .storeLoadPaymentDataCash(
                                            e.payment['remaining amount']
                                                ['pay id'],
                                          )
                                              .then((value) async {
                                            Navigator.of(context).pop();
                                            if (value.success) {
                                              DialogSuccess().showCustomDialog(
                                                  context,
                                                  title: "Remaining Payment");
                                              await Future.delayed(
                                                  Duration(seconds: 1), () {});
                                              Navigator.pop(context);
                                              getMyDels();
                                            } else {
                                              DialogFailed().showCustomDialog(
                                                  context,
                                                  title: "Remaining Payment",
                                                  text: value.message);
                                              await Future.delayed(
                                                  Duration(seconds: 3), () {});
                                              Navigator.pop(context);
                                            }
                                          }).catchError((e) async {
                                            print(e);
                                            Navigator.pop(context);
                                            DialogFailed().showCustomDialog(
                                                context,
                                                title: "Remaining payment",
                                                text: "Network Error");
                                            await Future.delayed(
                                                Duration(seconds: 3), () {});
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                if ((e.modeName == 'Advance Pay' ||
                                        e.modeName ==
                                            'Pay full after unloading') &&
                                    e.payment['remaining amount']['status'] ==
                                        '1')
                                  SizedBox(height: 20.0),
                                if ((e.modeName == 'Advance Pay' ||
                                        e.modeName ==
                                            'Pay full after unloading') &&
                                    e.payment['remaining amount']['status'] ==
                                        '1')
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      'Completed',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
    );
  }
}
