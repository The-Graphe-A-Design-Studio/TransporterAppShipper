import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:transportationapp/BottomSheets/AccountBottomSheetLoggedIn.dart';
import 'package:transportationapp/DialogScreens/DialogFailed.dart';
import 'package:transportationapp/DialogScreens/DialogProcessing.dart';
import 'package:transportationapp/DialogScreens/DialogSuccess.dart';
import 'package:transportationapp/HttpHandler.dart';
import 'package:transportationapp/Models/User.dart';
import 'package:transportationapp/MyConstants.dart';

class UploadDocs extends StatefulWidget {
  UploadDocs({Key key}) : super(key: key);

  @override
  _UploadDocsState createState() => _UploadDocsState();
}

enum WidgetMarker {
  otpVerification,
  signIn,
}

class _UploadDocsState extends State<UploadDocs> {
  WidgetMarker selectedWidgetMarker;

  final GlobalKey<FormState> _formKeyOtp = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySignIn = GlobalKey<FormState>();

  final otpController = TextEditingController();
  final mobileNumberControllerSignIn = TextEditingController();

  bool rememberMe = true;

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
    DialogProcessing().showCustomDialog(context,
        title: "OTP Verification", text: "Processing, Please Wait!");
    HTTPHandler().registerVerifyOtpCustomer([
      mobileNumberControllerSignIn.text,
      otpController.text,
    ]).then((value) async {
      if (value[0].success) {
        Navigator.pop(context);
        DialogSuccess().showCustomDialog(context, title: "OTP Verification");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          _context,
          homePageTransporter,
          (route) => false,
          arguments: UserTransporter.fromJson(json.decode(value[1])),
        );
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
  }

  void postOtpRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Requesting OTP", text: "Processing, Please Wait!");
    HTTPHandler().registerLoginCustomer([
      '91',
      mobileNumberControllerSignIn.text,
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
                  image: AssetImage('assets/images/logo_black.png'),
                  height: 145.0,
                  width: 145.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.center,
                child: PinCodeTextField(
                  autofocus: true,
                  controller: otpController,
                  highlight: true,
                  highlightColor: Colors.black,
                  defaultBorderColor: Colors.grey,
                  hasTextBorderColor: Colors.black,
                  pinBoxWidth: 32,
                  maxLength: 6,
                  wrapAlignment: WrapAlignment.center,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 26.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 150),
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                ),
              ),
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

  PickedFile pickedFile;

  Future getImageFromCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      pickedFile = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedFile = image;
    });
  }

  Widget getSignInBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeySignIn,
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
                  image: AssetImage('assets/images/logo_black.png'),
                  height: 145.0,
                  width: 145.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage("assets/images/logo_black.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            getImageFromCamera();
                          },
                          child: Icon(Icons.camera_alt),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 30.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeySignIn.currentState.validate()) {
                      postOtpRequest(context);
                    }
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
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
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
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Verification",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
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
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Phone Number",
            style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold),
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
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                getCustomWidget(context),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
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
                        topRight: Radius.circular(30.0)),
                  ),
                  child: AccountBottomSheetLoggedIn(
                      scrollController: scrollController),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
