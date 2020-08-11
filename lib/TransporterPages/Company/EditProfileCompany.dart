import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportationapp/DialogScreens/DialogFailed.dart';
import 'package:transportationapp/DialogScreens/DialogProcessing.dart';
import 'package:transportationapp/DialogScreens/DialogSuccess.dart';
import 'package:transportationapp/HttpHandler.dart';
import 'package:transportationapp/Models/User.dart';

class EditProfileCompany extends StatefulWidget {
  final UserCustomerCompany userCustomerCompany;

  EditProfileCompany({Key key, this.userCustomerCompany}) : super(key: key);

  @override
  _EditProfileCompanyState createState() => _EditProfileCompanyState();
}

enum WidgetMarker {
  companyCredentials,
  otpVerification,
  changePassword,
}

class _EditProfileCompanyState extends State<EditProfileCompany> {
  WidgetMarker selectedWidgetMarker;

  final GlobalKey<FormState> _formKeyCompanyCredentials =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyOtp = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyChangePassword = GlobalKey<FormState>();

  final coCustomerNameController = TextEditingController();
  final coMobileNumberController = TextEditingController();
  final coEmailController = TextEditingController();
  final coCityController = TextEditingController();
  final coAddressController = TextEditingController();
  final coPinController = TextEditingController();
  final coCustomerPanController = TextEditingController();

  final coNameController = TextEditingController();
  final coTypeController = TextEditingController();
  final coTaxController = TextEditingController();
  final coPanController = TextEditingController();
  final coWebsiteController = TextEditingController();

  final currPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final otpController = TextEditingController();

  final FocusNode _coCustomerName = FocusNode();
  final FocusNode _coMobileNumber = FocusNode();
  final FocusNode _coEmail = FocusNode();
  final FocusNode _coCity = FocusNode();
  final FocusNode _coAddress = FocusNode();
  final FocusNode _coPin = FocusNode();
  final FocusNode _coCustomerPan = FocusNode();
  final FocusNode _coName = FocusNode();
  final FocusNode _coType = FocusNode();
  final FocusNode _coTax = FocusNode();
  final FocusNode _coPan = FocusNode();
  final FocusNode _coWebsite = FocusNode();

  final FocusNode _currPassword = FocusNode();
  final FocusNode _newPassword = FocusNode();
  final FocusNode _confirmPassword = FocusNode();

  int regType = 0;
  bool rememberMe = true;

  @override
  void initState() {
    super.initState();
    selectedWidgetMarker = WidgetMarker.companyCredentials;
  }

  @override
  void dispose() {
    coCustomerNameController.dispose();
    coMobileNumberController.dispose();
    coEmailController.dispose();
    coCityController.dispose();
    coAddressController.dispose();
    coPinController.dispose();
    coCustomerPanController.dispose();

    coNameController.dispose();
    coTypeController.dispose();
    coTaxController.dispose();
    coPanController.dispose();
    coWebsiteController.dispose();

    currPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    otpController.dispose();

    super.dispose();
  }

  void clearControllers() {
    coCustomerNameController.clear();
    coMobileNumberController.clear();
    coEmailController.clear();
    coCityController.clear();
    coAddressController.clear();
    coPinController.clear();
    coCustomerPanController.clear();

    coNameController.clear();
    coTypeController.clear();
    coTaxController.clear();
    coPanController.clear();
    coWebsiteController.clear();

    currPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    otpController.clear();
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
      coCustomerPanController.text.toString(),
      coPinController.text.toString(),
      coNameController.text.toString(),
      coTypeController.text.toString(),
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
        DialogSuccess().showCustomDialog(context,
            title: "OTP Verification", text: "Please Sign In Again");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        HTTPHandler().signOut(context);
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

  void postChangePasswordRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Change Password", text: "Processing, Please Wait!");
    HTTPHandler().editOwnerInfoChangePassword([
      widget.userCustomerCompany.coId.toString(),
      currPasswordController.text.toString(),
      newPasswordController.text.toString(),
      confirmPasswordController.text.toString()
    ]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context,
            title: "Change Password", text: value.message);
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        HTTPHandler().signOut(context);
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Change Password", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Change Password", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  Widget getCompanyCredentialsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyCompanyCredentials,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.changePassword;
                          });
                        },
                        child: Text(
                          "Change Password",
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
                  FocusScope.of(context).requestFocus(_coPan);
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
                textInputAction: TextInputAction.next,
                focusNode: _coCustomerPan,
                onFieldSubmitted: (term) {
                  _coCustomerPan.unfocus();
                  FocusScope.of(context).requestFocus(_coAddress);
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
                controller: coAddressController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _coAddress,
                onFieldSubmitted: (term) {
                  _coAddress.unfocus();
                  FocusScope.of(context).requestFocus(_coCity);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
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
                  prefixIcon: Icon(Icons.mail),
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
                  FocusScope.of(context).requestFocus(_coName);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "PIN",
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
                controller: coNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _coName,
                onFieldSubmitted: (term) {
                  _coName.unfocus();
                  FocusScope.of(context).requestFocus(_coType);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
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
                controller: coTypeController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _coType,
                onFieldSubmitted: (term) {
                  _coType.unfocus();
                  FocusScope.of(context).requestFocus(_coTax);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Type",
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
                  prefixIcon: Icon(Icons.location_on),
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
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _coPan,
                onFieldSubmitted: (term) {
                  _coPan.unfocus();
                  FocusScope.of(context).requestFocus(_coWebsite);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Pan",
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
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                focusNode: _coWebsite,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeyCompanyCredentials.currentState.validate()) {
                      setState(() {
                        selectedWidgetMarker = WidgetMarker.otpVerification;
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Update Profile",
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
                            selectedWidgetMarker =
                                WidgetMarker.companyCredentials;
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
                            otpController.clear();
                            selectedWidgetMarker =
                                WidgetMarker.companyCredentials;
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
                    postResendOtpRequest(
                        context, coMobileNumberController.text.toString());
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
                    postOtpVerificationRequest(
                        context,
                        coMobileNumberController.text.toString(),
                        otpController.text.toString());
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

  Widget getChangePasswordBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyChangePassword,
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
                                WidgetMarker.companyCredentials;
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
                            selectedWidgetMarker =
                                WidgetMarker.companyCredentials;
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
                controller: currPasswordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                focusNode: _currPassword,
                onFieldSubmitted: (term) {
                  _currPassword.unfocus();
                  FocusScope.of(context).requestFocus(_newPassword);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  labelText: "Current Password",
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
                  controller: newPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  focusNode: _newPassword,
                  onFieldSubmitted: (term) {
                    _newPassword.unfocus();
                    FocusScope.of(context).requestFocus(_confirmPassword);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: "New Password",
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
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _confirmPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  labelText: "Confirm New Password",
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
                      newPasswordController.text.toString()) {
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
                    if (_formKeyChangePassword.currentState.validate()) {
                      postChangePasswordRequest(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        "Change Password",
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

  Widget getCompanyCredentialsWidget(context) {
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

  Widget getChangePasswordWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Reset",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Password",
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

  Widget getCustomWidget(context) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.companyCredentials:
        return getCompanyCredentialsWidget(context);
      case WidgetMarker.otpVerification:
        return getOtpVerificationWidget(context);
      case WidgetMarker.changePassword:
        return getChangePasswordWidget(context);
    }
    return getCompanyCredentialsWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.companyCredentials:
        return getCompanyCredentialsBottomSheetWidget(
            context, scrollController);
      case WidgetMarker.otpVerification:
        return getOtpVerificationBottomSheetWidget(context, scrollController);
      case WidgetMarker.changePassword:
        return getChangePasswordBottomSheetWidget(context, scrollController);
    }
    return getCompanyCredentialsBottomSheetWidget(context, scrollController);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.companyCredentials:
        return Future.value(true);
      case WidgetMarker.otpVerification:
        setState(() {
          otpController.clear();
          selectedWidgetMarker = WidgetMarker.companyCredentials;
        });
        return Future.value(false);
      case WidgetMarker.changePassword:
        setState(() {
          currPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          selectedWidgetMarker = WidgetMarker.companyCredentials;
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
