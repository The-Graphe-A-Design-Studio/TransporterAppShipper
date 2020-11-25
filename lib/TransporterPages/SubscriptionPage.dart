import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/SubscriptionPlan.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:toast/toast.dart';

enum CouponStatus {
  notChecked,
  checking,
  exists,
  notExists,
  applied,
}

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
  double selectedPlanPrice;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  UserTransporter transporter;
  TextEditingController couponCode;
  String coupon = '';

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

  void _openCheckOut(SubscriptionPlan s, double price) async {
    selected = s;
    selectedPlanPrice = price;
    HTTPHandler().generateRazorpayOrderId((price * 100).round()).then((value) {
      var options = {
        'key': RAZORPAY_ID,
        'amount': (price * 100).round(),
        'order_id': value,
        'name': transporter.compName,
        'description': 'TruckWale',
        'prefill': {
          'contact': transporter.mobileNumber,
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

    HTTPHandler()
        .storeData(
      transporter,
      selected,
      selectedPlanPrice,
      response,
      coupon,
    )
        .then((value) {
      if (value.success) {
        // Navigator.of(context).pop();
        reloadUser();
      } else
        print('error');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Success => $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Success => $response');
  }

  @override
  void initState() {
    super.initState();
    transporter = widget.userTransporter;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    couponCode = TextEditingController();
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
    Map couponData;
    CouponStatus status = CouponStatus.notChecked;

    double sellingPrice = p.planSellingPrice;
    double finalPrice = double.parse(p.finalPrice);

    _scaffoldKey.currentState.showBottomSheet((context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 310.0,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
                item('Selling Price', 'Rs. ${sellingPrice.toStringAsFixed(2)}'),
                item('GST', '18 %'),
                item('Final Price', 'Rs. ${finalPrice.toStringAsFixed(2)}'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: couponCode,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        if (couponCode.text == '')
                          Toast.show('Coupon Code required', context);
                        else {
                          setSheetState(() {
                            status = CouponStatus.checking;
                          });
                          HTTPHandler()
                              .checkCoupon(
                                  couponCode.text, widget.userTransporter.id)
                              .then((value) {
                            print(value);
                            if (value['success'] == '1') {
                              coupon = couponCode.text;
                              status = CouponStatus.exists;
                              couponData = value;
                              sellingPrice = (sellingPrice *
                                  (1 -
                                      (int.parse(couponData['discount']
                                              .split('%')[0])) /
                                          100));
                              finalPrice = sellingPrice + (0.18 * sellingPrice);
                            } else
                              status = CouponStatus.notExists;

                            setSheetState(() {});
                          });
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black87,
                            ),
                          ),
                          child: Text((status == CouponStatus.notChecked)
                              ? 'APPLY'
                              : (status == CouponStatus.exists)
                                  ? 'APPLIED'
                                  : 'APPLYING')),
                    ),
                  ],
                ),
                if (status == CouponStatus.exists)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Discount of : ${couponData['discount']}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (status == CouponStatus.notExists)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Coupon doesn\'t exist',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _openCheckOut(p, finalPrice);
                  },
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
          );
        },
      );
    });
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
