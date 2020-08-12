import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportationapp/DialogScreens/DialogFailed.dart';
import 'package:transportationapp/DialogScreens/DialogProcessing.dart';
import 'package:transportationapp/DialogScreens/DialogSuccess.dart';
import 'package:transportationapp/HttpHandler.dart';
import 'package:transportationapp/MyConstants.dart';
import 'package:transportationapp/PostMethodResult.dart';

class TransporterOptionsPage extends StatefulWidget {
  TransporterOptionsPage({Key key}) : super(key: key);

  @override
  _TransporterOptionsPageState createState() => _TransporterOptionsPageState();
}

enum WidgetMarker {
  options,
  signUpOption,
  individualCredentials,
  companyCredentials1,
  companyCredentials2,
  otpVerification,
  signIn,
}

class _TransporterOptionsPageState extends State<TransporterOptionsPage> {
  WidgetMarker selectedWidgetMarker;

  final GlobalKey<FormState> _formKeyIndividualCredentials =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCompanyCredentials1 =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCompanyCredentials2 =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyOtp = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySignIn = GlobalKey<FormState>();

  final inNameController = TextEditingController();
  final inMobileNumberController = TextEditingController();
  final inEmailController = TextEditingController();
  final inCityController = TextEditingController();
  final inAddressController = TextEditingController();
  final inPinController = TextEditingController();
  final inPanController = TextEditingController();
  final inPasswordController = TextEditingController();
  final inConfirmPasswordController = TextEditingController();

  final coCustomerNameController = TextEditingController();
  final coMobileNumberController = TextEditingController();
  final coEmailController = TextEditingController();
  final coCityController = TextEditingController();
  final coAddressController = TextEditingController();
  final coPinController = TextEditingController();
  final coCustomerPanController = TextEditingController();
  final coPasswordController = TextEditingController();
  final coConfirmPasswordController = TextEditingController();

  final coNameController = TextEditingController();
  String coTypeController;
  final coTaxController = TextEditingController();
  final coPanController = TextEditingController();
  final coWebsiteController = TextEditingController();

  final otpController = TextEditingController();

  final passwordControllerSignIn = TextEditingController();
  final mobileNumberControllerSignIn = TextEditingController();

  final FocusNode _inName = FocusNode();
  final FocusNode _inMobileNumber = FocusNode();
  final FocusNode _inEmail = FocusNode();
  final FocusNode _inPassword = FocusNode();
  final FocusNode _inConfirmPassword = FocusNode();
  final FocusNode _inCity = FocusNode();
  final FocusNode _inAddress = FocusNode();
  final FocusNode _inPin = FocusNode();
  final FocusNode _inPan = FocusNode();

  final FocusNode _coCustomerName = FocusNode();
  final FocusNode _coMobileNumber = FocusNode();
  final FocusNode _coEmail = FocusNode();
  final FocusNode _coPassword = FocusNode();
  final FocusNode _coConfirmPassword = FocusNode();
  final FocusNode _coCity = FocusNode();
  final FocusNode _coAddress = FocusNode();
  final FocusNode _coPin = FocusNode();
  final FocusNode _coCustomerPan = FocusNode();
  final FocusNode _coName = FocusNode();
  final FocusNode _coTax = FocusNode();
  final FocusNode _coPan = FocusNode();
  final FocusNode _coWebsite = FocusNode();

  final FocusNode _mobileNumberSignIn = FocusNode();
  final FocusNode _passwordSignIn = FocusNode();

  int regType = 0;
  bool rememberMe = true;

  @override
  void initState() {
    super.initState();
    selectedWidgetMarker = WidgetMarker.signUpOption;
  }

  @override
  void dispose() {
    inNameController.dispose();
    inMobileNumberController.dispose();
    inEmailController.dispose();
    inCityController.dispose();
    inAddressController.dispose();
    inPinController.dispose();
    inPanController.dispose();
    inPasswordController.dispose();
    inConfirmPasswordController.dispose();

    coCustomerNameController.dispose();
    coMobileNumberController.dispose();
    coEmailController.dispose();
    coCityController.dispose();
    coAddressController.dispose();
    coPinController.dispose();
    coCustomerPanController.dispose();
    coPasswordController.dispose();
    coConfirmPasswordController.dispose();

    coNameController.dispose();
    coTypeController = null;
    coTaxController.dispose();
    coPanController.dispose();
    coWebsiteController.dispose();

    otpController.dispose();

    mobileNumberControllerSignIn.dispose();
    passwordControllerSignIn.dispose();

    super.dispose();
  }

  void clearControllers() {
    inNameController.clear();
    inMobileNumberController.clear();
    inEmailController.clear();
    inCityController.clear();
    inAddressController.clear();
    inPinController.clear();
    inPanController.clear();
    inPasswordController.clear();
    inConfirmPasswordController.clear();

    coCustomerNameController.clear();
    coMobileNumberController.clear();
    coEmailController.clear();
    coCityController.clear();
    coAddressController.clear();
    coPinController.clear();
    coCustomerPanController.clear();
    coPasswordController.clear();
    coConfirmPasswordController.clear();

    coNameController.clear();
    coTypeController = null;
    coTaxController.clear();
    coPanController.clear();
    coWebsiteController.clear();

    otpController.clear();

    mobileNumberControllerSignIn.clear();
    passwordControllerSignIn.clear();
  }

  void postSignUpRequestIndividual(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Up Request", text: "Processing, Please Wait!");
    HTTPHandler().registerCustomerIndividual([
      inNameController.text.toString(),
      '91',
      inMobileNumberController.text.toString(),
      inEmailController.text.toString(),
      inAddressController.text.toString(),
      inCityController.text.toString(),
      inPasswordController.text.toString(),
      inConfirmPasswordController.text.toString(),
      inPanController.text.toString(),
      inPinController.text.toString()
    ]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Sign Up");
        await Future.delayed(Duration(seconds: 1), () {});
        setState(() {
          selectedWidgetMarker = WidgetMarker.otpVerification;
        });
        Navigator.pop(context);
        Scaffold.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            value.message,
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DialogFailed()
            .showCustomDialog(context, title: "Sign Up", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed()
          .showCustomDialog(context, title: "Sign Up", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void postSignUpRequestCompany(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Sign Up Request", text: "Processing, Please Wait!");
    HTTPHandler().registerCustomerIndividual([
      coCustomerNameController.text.toString(),
      '91',
      coMobileNumberController.text.toString(),
      coEmailController.text.toString(),
      coAddressController.text.toString(),
      coCityController.text.toString(),
      coPasswordController.text.toString(),
      coConfirmPasswordController.text.toString(),
      coCustomerPanController.text.toString(),
      coPinController.text.toString(),
      coNameController.text.toString(),
      coTypeController.toString(),
      coTaxController.text.toString(),
      coPanController.text.toString(),
      coWebsiteController.text.toString()
    ]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Sign Up");
        await Future.delayed(Duration(seconds: 1), () {});
        setState(() {
          selectedWidgetMarker = WidgetMarker.otpVerification;
        });
        Navigator.pop(context);
        Scaffold.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            value.message,
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DialogFailed()
            .showCustomDialog(context, title: "Sign Up", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed()
          .showCustomDialog(context, title: "Sign Up", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void postOtpVerificationRequest(
      BuildContext _context, String phNumber, String otpNumber) {
    DialogProcessing().showCustomDialog(context,
        title: "OTP Verification", text: "Processing, Please Wait!");
    HTTPHandler()
        .registerVerifyOtpCustomer([phNumber, otpNumber]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "OTP Verification");
        await Future.delayed(Duration(seconds: 1), () {});
        setState(() {
          selectedWidgetMarker = WidgetMarker.signIn;
        });
        Navigator.pop(context);
        Scaffold.of(_context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "You may now Sign In to your Account.",
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        DialogFailed().showCustomDialog(context,
            title: "OTP Verification", text: value.message);
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

  void postSignInRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Sign In", text: "Processing, Please Wait!");
    HTTPHandler().loginCustomer([
      regType.toString(),
      '91',
      mobileNumberControllerSignIn.text,
      passwordControllerSignIn.text,
      rememberMe
    ]).then((value) async {
      if (value[0]) {
        Navigator.pop(context);
        DialogSuccess().showCustomDialog(context, title: "Sign In");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        if (regType == 1) {
          Navigator.pushNamedAndRemoveUntil(
              _context, homePageTransporterIndividual, (route) => false,
              arguments: value[1]);
        } else if (regType == 2) {
          Navigator.pushNamedAndRemoveUntil(
              _context, homePageTransporterCompany, (route) => false,
              arguments: value[1]);
        }
      } else {
        PostResultOne postResultOne = value[1];
        Navigator.pop(context);
        DialogFailed().showCustomDialog(context,
            title: "Sign In", text: postResultOne.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed()
          .showCustomDialog(context, title: "Sign In", text: "Network Error");
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

  Widget getSignUpOptionsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(
      controller: scrollController,
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
        Align(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage('assets/images/logo_black.png'),
            height: 145.0,
            width: 145.0,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Welcome to Some App."),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Intro Content Intro Content"),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Intro Content"),
          ),
        ),
        SizedBox(height: 40.0),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                regType = 1;
                selectedWidgetMarker = WidgetMarker.options;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Individual",
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
        SizedBox(
          height: 30.0,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                regType = 2;
                selectedWidgetMarker = WidgetMarker.options;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Company",
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
    );
  }

  Widget getOptionsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(
      controller: scrollController,
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
        Align(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage('assets/images/logo_black.png'),
            height: 145.0,
            width: 145.0,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Welcome to Some App."),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Intro Content Intro Content"),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Material(
            child: Text("Intro Content"),
          ),
        ),
        SizedBox(height: 40.0),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                if (regType == 1) {
                  selectedWidgetMarker = WidgetMarker.individualCredentials;
                } else if (regType == 2) {
                  selectedWidgetMarker = WidgetMarker.companyCredentials1;
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Sign Up",
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
        SizedBox(
          height: 30.0,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                selectedWidgetMarker = WidgetMarker.signIn;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50.0,
              child: Center(
                child: Text(
                  "Sign In",
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
    );
  }

  Widget getIndividualCredentialsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyIndividualCredentials,
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
                            clearControllers();
                            selectedWidgetMarker = WidgetMarker.options;
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
                            regType = 0;
                            selectedWidgetMarker = WidgetMarker.signUpOption;
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
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: inNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _inName,
                onFieldSubmitted: (term) {
                  _inName.unfocus();
                  FocusScope.of(context).requestFocus(_inMobileNumber);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Full Name",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  SizedBox(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.dialpad),
                        hintText: "+91",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.amber,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                    width: 97.0,
                  ),
                  SizedBox(width: 16.0),
                  Flexible(
                    child: TextFormField(
                      controller: inMobileNumberController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _inMobileNumber,
                      onFieldSubmitted: (term) {
                        _inMobileNumber.unfocus();
                        FocusScope.of(context).requestFocus(_inEmail);
                      },
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
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
                        } else if (value.length < 10) {
                          return "Enter Valid Mobile Number";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: inEmailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _inEmail,
                onFieldSubmitted: (term) {
                  _inEmail.unfocus();
                  FocusScope.of(context).requestFocus(_inPan);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Email",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: inPanController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                focusNode: _inPan,
                onFieldSubmitted: (term) {
                  _inPan.unfocus();
                  FocusScope.of(context).requestFocus(_inAddress);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  labelText: "Pan Card",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: inAddressController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _inAddress,
                onFieldSubmitted: (term) {
                  _inAddress.unfocus();
                  FocusScope.of(context).requestFocus(_inCity);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  labelText: "Address",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: inCityController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _inCity,
                onFieldSubmitted: (term) {
                  _inCity.unfocus();
                  FocusScope.of(context).requestFocus(_inPin);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  labelText: "City",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: inPinController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _inPin,
                onFieldSubmitted: (term) {
                  _inPin.unfocus();
                  FocusScope.of(context).requestFocus(_inPassword);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  labelText: "ZIP Code",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                  obscureText: true,
                  controller: inPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  focusNode: _inPassword,
                  onFieldSubmitted: (term) {
                    _inPassword.unfocus();
                    FocusScope.of(context).requestFocus(_inConfirmPassword);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: "Password",
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
                    }
                    return null;
                  }),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                obscureText: true,
                controller: inConfirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _inConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  labelText: "Confirm Password",
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
                  } else if (value.toString() !=
                      inPasswordController.text.toString()) {
                    return "Passwords Don't Match";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeyIndividualCredentials.currentState.validate()) {
                      postSignUpRequestIndividual(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Sign Up",
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

  Widget getCompanyCredentials1BottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyCompanyCredentials1,
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
                            clearControllers();
                            selectedWidgetMarker = WidgetMarker.options;
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
                            regType = 0;
                            selectedWidgetMarker = WidgetMarker.signUpOption;
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
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coCustomerNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _coCustomerName,
                onFieldSubmitted: (term) {
                  _coCustomerName.unfocus();
                  FocusScope.of(context).requestFocus(_coMobileNumber);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Full Name",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  SizedBox(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.dialpad),
                        hintText: "+91",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.amber,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                    width: 97.0,
                  ),
                  SizedBox(width: 16.0),
                  Flexible(
                    child: TextFormField(
                      controller: coMobileNumberController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _coMobileNumber,
                      onFieldSubmitted: (term) {
                        _coMobileNumber.unfocus();
                        FocusScope.of(context).requestFocus(_coEmail);
                      },
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
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
                        } else if (value.length < 10) {
                          return "Enter Valid Mobile Number";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coEmailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _coEmail,
                onFieldSubmitted: (term) {
                  _coEmail.unfocus();
                  FocusScope.of(context).requestFocus(_coCustomerPan);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Email",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coCustomerPanController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                focusNode: _coCustomerPan,
                onFieldSubmitted: (term) {
                  _coCustomerPan.unfocus();
                  FocusScope.of(context).requestFocus(_coAddress);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.credit_card),
                  labelText: "Pan Number",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coAddressController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _coAddress,
                onFieldSubmitted: (term) {
                  _coAddress.unfocus();
                  FocusScope.of(context).requestFocus(_coCity);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  labelText: "Address",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coCityController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _coCity,
                onFieldSubmitted: (term) {
                  _coCity.unfocus();
                  FocusScope.of(context).requestFocus(_coPin);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  labelText: "City",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coPinController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _coPin,
                onFieldSubmitted: (term) {
                  _coPin.unfocus();
                  FocusScope.of(context).requestFocus(_coPassword);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  labelText: "ZIP Code",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                  obscureText: true,
                  controller: coPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  focusNode: _coPassword,
                  onFieldSubmitted: (term) {
                    _coPassword.unfocus();
                    FocusScope.of(context).requestFocus(_coConfirmPassword);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: "Password",
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
                    }
                    return null;
                  }),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                obscureText: true,
                controller: coConfirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _coConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  labelText: "Confirm Password",
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
                  } else if (value.toString() !=
                      coPasswordController.text.toString()) {
                    return "Passwords Don't Match";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeyCompanyCredentials1.currentState.validate()) {
                      setState(() {
                        selectedWidgetMarker = WidgetMarker.companyCredentials2;
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Next",
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

  Widget getCompanyCredentials2BottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyCompanyCredentials2,
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
                            selectedWidgetMarker =
                                WidgetMarker.companyCredentials1;
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
                            regType = 0;
                            selectedWidgetMarker = WidgetMarker.signUpOption;
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
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _coName,
                onFieldSubmitted: (term) {
                  _coName.unfocus();
                  FocusScope.of(context).requestFocus(_coTax);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.people),
                  labelText: "Company Name",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coTaxController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _coTax,
                onFieldSubmitted: (term) {
                  _coTax.unfocus();
                  FocusScope.of(context).requestFocus(_coPan);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.payment),
                  labelText: "Service Tax",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coPanController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                focusNode: _coPan,
                onFieldSubmitted: (term) {
                  _coPan.unfocus();
                  FocusScope.of(context).requestFocus(_coWebsite);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Pan Number",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: coWebsiteController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                focusNode: _coWebsite,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.link),
                  labelText: "Website",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              DropdownButton(
                isExpanded: true,
                value: coTypeController,
                dropdownColor: Colors.white,
                items: [
                  DropdownMenuItem(
                    child: Text("Agro Products Mfg/Supplier"),
                    value: "Agro Products Mfg/Supplier",
                  ),
                  DropdownMenuItem(
                    child: Text("Builder/Building Material Suppliers"),
                    value: "Builder/Building Material Suppliers",
                  ),
                  DropdownMenuItem(
                    child: Text("Cement/Coal Plant"),
                    value: "Cement/Coal Plant",
                  ),
                  DropdownMenuItem(
                    child: Text("Dealer/Commission Agent/Distributor"),
                    value: "Dealer/Commission Agent/Distributor",
                  ),
                  DropdownMenuItem(
                    child: Text("Export/Import Firm"),
                    value: "Export/Import Firm",
                  ),
                  DropdownMenuItem(
                    child: Text("Job/Maintenance"),
                    value: "Job/Maintenance",
                  ),
                  DropdownMenuItem(
                    child: Text("Manufacturing/Traders"),
                    value: "Manufacturing/Traders",
                  ),
                  DropdownMenuItem(
                    child: Text("Machinery Manufacturing/Suppliers"),
                    value: "Machinery Manufacturing/Suppliers",
                  ),
                  DropdownMenuItem(
                    child: Text("Print/Media Related"),
                    value: "Print/Media Related",
                  ),
                  DropdownMenuItem(
                    child: Text("Raw Material Supplier"),
                    value: "Raw Material Supplier",
                  ),
                  DropdownMenuItem(
                    child: Text("Sales & Services"),
                    value: "Sales & Services",
                  ),
                  DropdownMenuItem(
                    child: Text("Traders/Shop Keeper/Merchant"),
                    value: "Traders/Shop Keeper/Merchant",
                  ),
                  DropdownMenuItem(
                      child: Text("Wood Product Mfg/Supplier/Merchant"),
                      value: "Wood Product Mfg/Supplier/Merchant")
                ],
                onChanged: (value) {
                  setState(() {
                    coTypeController = value;
                  });
                },
                hint: Text("Select Company Type"),
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeyCompanyCredentials2.currentState.validate() && (coTypeController!=null)) {
                      postSignUpRequestCompany(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Sign Up",
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
                            if (regType == 1) {
                              selectedWidgetMarker =
                                  WidgetMarker.individualCredentials;
                            } else if (regType == 2) {
                              selectedWidgetMarker =
                                  WidgetMarker.companyCredentials2;
                            } else {
                              clearControllers();
                              regType = 0;
                              selectedWidgetMarker = WidgetMarker.signUpOption;
                            }
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
                            regType = 0;
                            selectedWidgetMarker = WidgetMarker.signUpOption;
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
              TextFormField(
                obscureText: true,
                controller: otpController,
                keyboardType: TextInputType.phone,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  labelText: "Enter OTP",
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
                  }
                  return null;
                },
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
                    if (regType == 1) {
                      postResendOtpRequest(
                          context, inMobileNumberController.text.toString());
                    } else if (regType == 2) {
                      postResendOtpRequest(
                          context, coMobileNumberController.text.toString());
                    }
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
                    print(regType);
                    print(otpController.text.toString());
                    if (regType == 1) {
                      postOtpVerificationRequest(
                          context,
                          inMobileNumberController.text.toString(),
                          otpController.text.toString());
                    } else if (regType == 2) {
                      postOtpVerificationRequest(
                          context,
                          coMobileNumberController.text.toString(),
                          otpController.text.toString());
                    }
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
                          setState(() {
                            clearControllers();
                            selectedWidgetMarker = WidgetMarker.options;
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
                            regType = 0;
                            selectedWidgetMarker = WidgetMarker.signUpOption;
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
              Row(
                children: [
                  SizedBox(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.dialpad),
                        hintText: "+91",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.amber,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                    width: 97.0,
                  ),
                  SizedBox(width: 16.0),
                  Flexible(
                    child: TextFormField(
                      controller: mobileNumberControllerSignIn,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _mobileNumberSignIn,
                      onFieldSubmitted: (term) {
                        _mobileNumberSignIn.unfocus();
                        FocusScope.of(context).requestFocus(_passwordSignIn);
                      },
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
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
                  )
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordControllerSignIn,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _passwordSignIn,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  labelText: "Password",
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
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    checkColor: Colors.white,
                    activeColor: Color(0xff252427),
                    onChanged: (bool value) {
                      setState(() {
                        rememberMe = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 0.0,
                  ),
                  Text("Remember Me"),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      print("Forgot Password");
                    },
                    child: Container(
                      child: Text("Forgot Password?"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeySignIn.currentState.validate()) {
                      postSignInRequest(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Sign In",
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

  Widget getSignUpOptionsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "User",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Type",
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

  Widget getOptionsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Text(
            "Hi, User",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget getIndividualCredentialsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Enter",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Credentials",
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

  Widget getCompanyCredentials1Widget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Enter",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Credentials",
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

  Widget getCompanyCredentials2Widget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Enter",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Company Data",
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
            "Welcome Back!",
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

  Widget getCustomWidget(context) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.signUpOption:
        return getSignUpOptionsWidget(context);
      case WidgetMarker.options:
        return getOptionsWidget(context);
      case WidgetMarker.individualCredentials:
        return getIndividualCredentialsWidget(context);
      case WidgetMarker.companyCredentials1:
        return getCompanyCredentials1Widget(context);
      case WidgetMarker.companyCredentials2:
        return getCompanyCredentials2Widget(context);
      case WidgetMarker.otpVerification:
        return getOtpVerificationWidget(context);
      case WidgetMarker.signIn:
        return getSignInWidget(context);
    }
    return getSignUpOptionsWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.signUpOption:
        return getSignUpOptionsBottomSheetWidget(context, scrollController);
      case WidgetMarker.options:
        return getOptionsBottomSheetWidget(context, scrollController);
      case WidgetMarker.individualCredentials:
        return getIndividualCredentialsBottomSheetWidget(
            context, scrollController);
      case WidgetMarker.companyCredentials1:
        return getCompanyCredentials1BottomSheetWidget(
            context, scrollController);
      case WidgetMarker.companyCredentials2:
        return getCompanyCredentials2BottomSheetWidget(
            context, scrollController);
      case WidgetMarker.otpVerification:
        return getOtpVerificationBottomSheetWidget(context, scrollController);
      case WidgetMarker.signIn:
        return getSignInBottomSheetWidget(context, scrollController);
    }
    return getSignUpOptionsBottomSheetWidget(context, scrollController);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.signUpOption:
        return Future.value(true);
      case WidgetMarker.options:
        setState(() {
          clearControllers();
          regType = 0;
          selectedWidgetMarker = WidgetMarker.signUpOption;
        });
        return Future.value(false);
      case WidgetMarker.individualCredentials:
        setState(() {
          clearControllers();
          selectedWidgetMarker = WidgetMarker.options;
        });
        return Future.value(false);
      case WidgetMarker.companyCredentials1:
        setState(() {
          clearControllers();
          selectedWidgetMarker = WidgetMarker.options;
        });
        return Future.value(false);
      case WidgetMarker.companyCredentials2:
        setState(() {
          selectedWidgetMarker = WidgetMarker.companyCredentials1;
        });
        return Future.value(false);
      case WidgetMarker.otpVerification:
        setState(() {
          if (regType == 1) {
            selectedWidgetMarker = WidgetMarker.individualCredentials;
          } else if (regType == 2) {
            selectedWidgetMarker = WidgetMarker.companyCredentials2;
          } else {
            regType = 0;
            selectedWidgetMarker = WidgetMarker.signUpOption;
          }
        });
        return Future.value(false);
      case WidgetMarker.signIn:
        setState(() {
          clearControllers();
          selectedWidgetMarker = WidgetMarker.options;
        });
        return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xff252427),
        body: Stack(children: <Widget>[
          getCustomWidget(context),
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
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: getCustomBottomSheetWidget(
                            context, scrollController),
                      )));
            },
          ),
        ]),
      ),
    );
  }
}
