import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/SubscriptionPlan.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:toast/toast.dart';

class SubsriptionPage extends StatefulWidget {
  final UserTransporter userTransporter;

  SubsriptionPage({
    Key key,
    @required this.userTransporter,
  }) : super(key: key);

  @override
  _SubsriptionPageState createState() => _SubsriptionPageState();
}

class _SubsriptionPageState extends State<SubsriptionPage> {
  DateTime subscriptionEnd;
  String subscriptionStatus;
  bool subscriptionController = false;
  List<SubscriptionPlan> _plans;
  Razorpay _razorpay;
  SubscriptionPlan selected;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  UserTransporter transporter;

  getData() async {
    subscriptionController = true;
    await SharedPreferences.getInstance().then((value) {
      subscriptionEnd = (transporter.planType == '3')
          ? DateTime.now()
          : DateTime.parse(value.getString('period_upto'));
      subscriptionStatus = value.getString('period_status');
    });
    await HTTPHandler()
        .getSubscriptionPlans()
        .then((value) => this._plans = value);
    setState(() {});
  }

  void reloadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPHandler().registerVerifyOtpCustomer(
        [transporter.mobileNumber, prefs.getString('otp')]).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("rememberMe", true);
      prefs.setString("userData", value[1]);
      getData();
      setState(() {
        transporter = UserTransporter.fromJson(json.decode(value[1]));
      });
    });
  }

  void _openCheckOut(SubscriptionPlan s) async {
    selected = s;
    HTTPHandler()
        .generateRazorpayOrderId((double.parse(s.finalPrice) * 100).round())
        .then((value) {
      var options = {
        'key': RAZORPAY_ID,
        'amount': (s.planSellingPrice * 100).round(),
        'order_id': value,
        'name': transporter.compName,
        'description': 'TruckWale',
        'prefill': {
          'contact': transporter.mobileNumber,
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Id => ${response.paymentId}');
    print('Order Id => ${response.orderId}');
    print('Signature => ${response.signature}');

    HTTPHandler().storeData(transporter, selected, response).then((value) {
      if (value.success) {
        // Toast.show(
        //   'You will be logged once your subscription is verified. Please login again!',
        //   context,
        //   gravity: Toast.CENTER,
        //   duration: Toast.LENGTH_LONG,
        // );
        // Future.delayed(
        //   Duration(milliseconds: 900),
        //   () => HTTPHandler().signOut(
        //     context,
        //     userMobile: transporter.mobileNumber,
        //   ),
        // );
        Navigator.of(context).pop();
        reloadUser();
      } else
        print('error');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed(
      '/homePageTransporter',
      arguments: transporter,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Success => $response');
    Navigator.of(context).popAndPushNamed(
      '/homePageTransporter',
      arguments: transporter,
    );
  }

  @override
  void initState() {
    super.initState();
    transporter = widget.userTransporter;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    if (!subscriptionController) getData();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Your Subscriptions',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: (_plans == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // width: 100.0,
                              height: 30.0,
                              alignment: Alignment.center,
                              child: Text(
                                subscriptionStatus,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              '${subscriptionEnd.difference(DateTime.now()).inDays} days left',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        alignment: Alignment.center,
                        child: Text(
                          (transporter.planType == '3')
                              ? 'Ends on \n00 - 00 - 0000'
                              : 'Ends on \n${subscriptionEnd.day} - ${subscriptionEnd.month} - ${subscriptionEnd.year}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: _plans
                      .map(
                        (e) => Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Plan ${_plans.indexOf(e) + 1} : ',
                                  ),
                                  Text(
                                    e.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Duration',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '${e.duration}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Text(
                                            '${e.planSellingPrice}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          SizedBox(width: 3.0),
                                          Text(
                                            '${e.planOriginalPrice}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    print('buy now');
                                    // _openCheckOut(e);
                                    _openModal(e);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                      'Buy Now',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
    );
  }

  void _openModal(SubscriptionPlan p) {
    _scaffoldKey.currentState.showBottomSheet((context) => Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: 250.0,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Plan Details'),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              Divider(),
              item('Duration', p.duration),
              item('Original Price', 'Rs. ${p.planOriginalPrice}'),
              item('Selling Price', 'Rs. ${p.planSellingPrice}'),
              item('GST', '18 %'),
              item('Final Price', 'Rs. ${double.parse(p.finalPrice)}'),
              SizedBox(height: 12.0),
              GestureDetector(
                onTap: () => _openCheckOut(p),
                child: Container(
                  width: double.infinity,
                  height: 40.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget item(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
}
