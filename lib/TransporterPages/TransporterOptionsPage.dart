import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipperapp/DialogScreens/DialogFailed.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:toast/toast.dart';

class TransporterOptionsPage extends StatefulWidget {
  TransporterOptionsPage({Key key}) : super(key: key);

  @override
  _TransporterOptionsPageState createState() => _TransporterOptionsPageState();
}

enum WidgetMarker {
  otpVerification,
  signIn,
}

class _TransporterOptionsPageState extends State<TransporterOptionsPage> {
  WidgetMarker selectedWidgetMarker;

  final GlobalKey<FormState> _formKeyOtp = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKeySignIn = GlobalKey<FormState>();

  final otpController = TextEditingController();
  final mobileNumberControllerSignIn = TextEditingController();
  String userToken;
  bool rememberMe = true;

  String _otpCode = "";

  @override
  void initState() {
    super.initState();
    selectedWidgetMarker = WidgetMarker.signIn;
  }

  @override
  void dispose() {
    otpController.dispose();
    mobileNumberControllerSignIn.dispose();
    super.dispose();
  }

  void clearControllers() {
    otpController.clear();
    mobileNumberControllerSignIn.clear();
  }

  void postSignInRequest(BuildContext _context) {
    if (_otpCode.length == 6) {
      DialogProcessing().showCustomDialog(context,
          title: "OTP Verification", text: "Processing, Please Wait!");
      HTTPHandler().registerVerifyOtpCustomer([
        mobileNumberControllerSignIn.text,
        _otpCode,
      ]).then((value) async {
        if (value[0].success) {
          Navigator.pop(context);
          DialogSuccess().showCustomDialog(context, title: "OTP Verification");
          await Future.delayed(Duration(seconds: 1), () {});
          Navigator.pop(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("rememberMe", true);
          prefs.setString("userData", value[1]);
          if (json.decode(value[1])['verified'] == "1") {
            Navigator.pushNamedAndRemoveUntil(
              _context,
              homePageTransporter,
              (route) => false,
              arguments: UserTransporter.fromJson(json.decode(value[1])),
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              _context,
              homePageTransporterNotVerified,
              (route) => false,
              arguments: UserTransporter.fromJson(json.decode(value[1])),
            );
          }
        } else {
          Navigator.pop(context);
          DialogFailed().showCustomDialog(context,
              title: "OTP Verification", text: value[0].message);
          await Future.delayed(Duration(seconds: 3), () {});
          Navigator.pop(context);
        }
      }).catchError((error) async {
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "OTP Verification", text: "Network Error");
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      });
    } else {
      Toast.show('Enter Complete OTP', context);
    }
  }

  void postOtpRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Requesting OTP", text: "Processing, Please Wait!");
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((token) {
      userToken = token;
      HTTPHandler().registerLoginCustomer([
        '91',
        mobileNumberControllerSignIn.text,
        userToken
      ]).then((value) async {
        if (value.success) {
          Navigator.pop(context);
          DialogSuccess().showCustomDialog(context, title: "Requesting OTP");
          await Future.delayed(Duration(seconds: 1), () {});
          Navigator.pop(context);
          setState(() {
            selectedWidgetMarker = WidgetMarker.otpVerification;
          });
        } else {
          Navigator.pop(context);
          DialogFailed().showCustomDialog(context,
              title: "Requesting OTP", text: value.message);
          await Future.delayed(Duration(seconds: 3), () {});
          Navigator.pop(context);
        }
      }).catchError((error) async {
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "Requesting OTP", text: "Network Error");
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      });
    });
  }

  void postResendOtpRequest(BuildContext _context, String phNumber) {
    DialogProcessing().showCustomDialog(context,
        title: "Resend OTP", text: "Processing, Please Wait!");
    HTTPHandler().registerResendOtpCustomer([phNumber]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Resend OTP");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Scaffold.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            value.message,
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Resend OTP", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Resend OTP", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  _getSignatureCode() async {
    String signature = await SmsRetrieved.getAppSignature();
    print("signature $signature");
  }

  Widget getOtpVerificationBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyOtp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.signIn;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff252427),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            clearControllers();
                            selectedWidgetMarker = WidgetMarker.signIn;
                          });
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.black12,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/logo_white.png'),
                  height: 125.0,
                  width: 125.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              TextFieldPin(
                borderStyeAfterTextChange: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                borderStyle: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                codeLength: 6,
                boxSize: 40,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
                filledAfterTextChange: true,
                filledColor: Colors.white,
                onOtpCallback: (code, isAutofill) {
                  print(code);
                  this._otpCode = code;
                },
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: PinCodeTextField(
              //     autofocus: true,
              //     controller: otpController,
              //     highlight: true,
              //     highlightColor: Colors.black,
              //     defaultBorderColor: Colors.grey,
              //     hasTextBorderColor: Colors.black,
              //     pinBoxWidth: 32,
              //     maxLength: 6,
              //     wrapAlignment: WrapAlignment.center,
              //     pinBoxDecoration:
              //         ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
              //     pinTextStyle: TextStyle(fontSize: 26.0),
              //     pinTextAnimatedSwitcherTransition:
              //         ProvidedPinBoxTextAnimation.scalingTransition,
              //     pinTextAnimatedSwitcherDuration: Duration(milliseconds: 150),
              //     highlightAnimationBeginColor: Colors.black,
              //     highlightAnimationEndColor: Colors.white12,
              //     keyboardType: TextInputType.number,
              //   ),
              // ),
              SizedBox(
                height: 16.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      otpController.clear();
                    });
                    postResendOtpRequest(
                        context, mobileNumberControllerSignIn.text.toString());
                  },
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    postSignInRequest(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff252427),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2.0, color: Color(0xff252427)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getSignInBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      children: <Widget>[
        SingleChildScrollView(
          child: Form(
            //key: _formKeySignIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xff252427),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/images/logo_white.png'),
                    height: 125.0,
                    width: 125.0,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Material(
                    child: TextFormField(
                      controller: mobileNumberControllerSignIn,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        prefixText: "+91     ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.amber,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This Field is Required";
                        } else if (value.length != 10) {
                          return "Enter Valid Mobile Number";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      // if (_formKeySignIn.currentState.validate()) {
                      //   postOtpRequest(context);
                      // }
                      if (mobileNumberControllerSignIn.text.length == 10)
                        postOtpRequest(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Color(0xff252427),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2.0,
                          color: Color(0xff252427),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getOtpVerificationWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "OTP",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Verification",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getSignInWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            "Enter Your",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Phone Number",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget getCustomWidget(context) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.otpVerification:
        return getOtpVerificationWidget(context);
      case WidgetMarker.signIn:
        return getSignInWidget(context);
    }
    return getSignInWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.otpVerification:
        return getOtpVerificationBottomSheetWidget(context, scrollController);
      case WidgetMarker.signIn:
        return getSignInBottomSheetWidget(context, scrollController);
    }
    return getSignInBottomSheetWidget(context, scrollController);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.otpVerification:
        setState(() {
          selectedWidgetMarker = WidgetMarker.signIn;
        });
        return Future.value(false);
      case WidgetMarker.signIn:
        return Future.value(true);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    _getSignatureCode();
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xff252427),
        body: Stack(
          children: <Widget>[
            getCustomWidget(context),
            DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Hero(
                  tag: 'AnimeBottom',
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: getCustomBottomSheetWidget(
                        context,
                        scrollController,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
