import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/SubscriptionPlan.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';

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

  getData() async {
    subscriptionController = true;
    await SharedPreferences.getInstance().then((value) {
      if (value.getString('plan_type') == '1') {
        subscriptionEnd = DateTime.parse(value.getString('trial_period_upto'));
        subscriptionStatus = value.getString('trial_period_status');
      } else {
        subscriptionEnd =
            DateTime.parse(value.getString('subscription_period_upto'));
        subscriptionStatus = value.getString('subscription_period_status');
      }
    });
    await HTTPHandler()
        .getSubscriptionPlans()
        .then((value) => this._plans = value);
    setState(() {});
  }

  void _openCheckOut(SubscriptionPlan s) async {
    selected = s;
    HTTPHandler()
        .generateRazorpayOrderId((s.planSellingPrice * 100).round())
        .then((value) {
      var options = {
        'key': RAZORPAY_ID,
        'amount': (s.planSellingPrice * 100).round(),
        'order_id': value,
        'name': widget.userTransporter.compName,
        'description': 'TruckWale',
        'prefill': {
          'contact': widget.userTransporter.mobileNumber,
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

    HTTPHandler()
        .storeData(widget.userTransporter, selected, response)
        .then((value) {
      if (value.success)
        Navigator.pop(context);
      else
        print('error');
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

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    if (!subscriptionController) getData();

    return Scaffold(
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
                          'Ends on \n${subscriptionEnd.day} - ${subscriptionEnd.month} - ${subscriptionEnd.year}',
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
                          height: 150.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Original Price'),
                                  Text(
                                    '${e.planOriginalPrice}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Selling Price'),
                                  Text(
                                    '${e.planSellingPrice}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Discount'),
                                  Text(
                                    '${e.planDiscount}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Duration'),
                                  Text(
                                    '${e.duration}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Divider(),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    print('buy now');
                                    _openCheckOut(e);
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
}
