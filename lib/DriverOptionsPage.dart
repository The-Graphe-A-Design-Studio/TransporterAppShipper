import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transportationapp/DriverUpcomingOrder.dart';
import 'package:transportationapp/FadeTransition.dart';
import 'package:transportationapp/HomePage.dart';
import 'package:transportationapp/PostMethodResult.dart';

class DriverOptionsPage extends StatefulWidget {
  DriverOptionsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DriverOptionsPageState createState() => _DriverOptionsPageState();
}

enum WidgetMarker {
  options,
  credentials,
  documents,
  otpVerification,
  signIn,
  ownerDetails
}

class _DriverOptionsPageState extends State<DriverOptionsPage> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.options;
  WidgetMarker selectedBottomSheetWidgetMarker = WidgetMarker.options;
  PostResultSignIn postResultSignIn;

  final GlobalKey<FormState> _formKeyCredentials = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDocuments = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyOwnerDetails = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyOtp = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySignIn = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final panCardNumberController = TextEditingController();
  final bankAccountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();

  final otpController = TextEditingController();

  final passwordControllerSignIn = TextEditingController();
  final mobileNumberControllerSignIn = TextEditingController();

  File rcFile, licenceFile, insuranceFile, roadTaxFile, rtoPassingFile;
  bool rcDone, licenceDone, insuranceDone, roadTaxDone, rtoPassingDone;

  final FocusNode _name = FocusNode();
  final FocusNode _mobileNumber = FocusNode();
  final FocusNode _email = FocusNode();
  final FocusNode _address = FocusNode();
  final FocusNode _password = FocusNode();
  final FocusNode _confirmPassword = FocusNode();

  final FocusNode _mobileNumberSignIn = FocusNode();
  final FocusNode _passwordSignIn = FocusNode();

  final FocusNode _panCardNumber = FocusNode();
  final FocusNode _bankAccountNumber = FocusNode();
  final FocusNode _ifscCode = FocusNode();

  @override
  void initState() {
    super.initState();
    rcDone = false;
    licenceDone = false;
    insuranceDone = false;
    roadTaxDone = false;
    rtoPassingDone = false;
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    panCardNumberController.dispose();
    bankAccountNumberController.dispose();
    ifscCodeController.dispose();

    otpController.dispose();

    mobileNumberControllerSignIn.dispose();
    passwordControllerSignIn.dispose();

    super.dispose();
  }

  Future<bool> postSignUpRequest(BuildContext _context) async {
    var url = "https://developers.thegraphe.com/transport/api/drivers/register";
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['d_name'] = nameController.text.toString();
    request.fields['d_email'] = emailController.text.toString();
    request.fields['d_phone_code'] = '91';
    request.fields['d_phone'] = mobileNumberController.text.toString();
    request.fields['d_password'] = passwordController.text.toString();
    request.fields['d_cnf_password'] =
        confirmPasswordController.text.toString();
    request.fields['d_address'] = addressController.text.toString();
    request.files.add(await http.MultipartFile.fromPath('d_rc', rcFile.path));
    request.files
        .add(await http.MultipartFile.fromPath('d_license', rcFile.path));
    request.files
        .add(await http.MultipartFile.fromPath('d_insurance', rcFile.path));
    request.files
        .add(await http.MultipartFile.fromPath('d_road_tax', rcFile.path));
    request.files.add(await http.MultipartFile.fromPath('d_rto', rcFile.path));
    request.fields['d_pan'] = panCardNumberController.text.toString();
    request.fields['d_bank'] = bankAccountNumberController.text.toString();
    request.fields['d_ifsc'] = ifscCodeController.text.toString();

    var result = await request.send();
    var finalResult = await http.Response.fromStream(result);
    PostResultOne postResultOne =
        PostResultOne.fromJson(json.decode(finalResult.body));
    setState(() {
      final snackBar = SnackBar(
        backgroundColor: postResultOne.success ? Colors.green : Colors.red,
        content: Text(postResultOne.message),
      );
      Scaffold.of(_context).showSnackBar(snackBar);
    });
    return postResultOne.success;
  }

  Future<bool> postOtpVerificationRequest(BuildContext _context) async {
    var url = "https://developers.thegraphe.com/transport/api/drivers/register";

    var result = await http.post(url, body: {
      'phone_number': mobileNumberController.text.toString(),
      'otp': otpController.text.toString()
    });
    PostResultOne postResultOne =
        PostResultOne.fromJson(json.decode(result.body));
    setState(() {
      final snackBar = SnackBar(
        backgroundColor: postResultOne.success ? Colors.green : Colors.red,
        content: Text(postResultOne.message),
      );
      Scaffold.of(_context).showSnackBar(snackBar);
    });
    return postResultOne.success;
  }

  Future<bool> postSignInRequest(BuildContext _context) async {
    var url = "https://developers.thegraphe.com/transport/api/drivers/login";

    var result = await http.post(url, body: {
      'phone_code': '91',
      'phone': mobileNumberControllerSignIn.text.toString(),
      'password': passwordControllerSignIn.text.toString()
    });
    var jsonResult = json.decode(result.body);
    if (jsonResult['success'] == '1') {
      postResultSignIn = PostResultSignIn.fromJson(jsonResult);
      setState(() {
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text("Welcome, ${postResultSignIn.dName}!"),
        );
        Scaffold.of(_context).showSnackBar(snackBar);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userData', jsonResult);
      return postResultSignIn.success;
    } else {
      PostResultOne postResultOne = PostResultOne.fromJson(jsonResult);
      setState(() {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(postResultOne.message),
        );
        Scaffold.of(_context).showSnackBar(snackBar);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      return postResultOne.success;
    }
  }

  Future<bool> postResendOtpRequest(BuildContext _context) async {
    var url = "https://developers.thegraphe.com/transport/api/drivers/register";

    var result = await http.post(url, body: {
      'resend_otp': mobileNumberController.text.toString(),
    });
    PostResultOne postResultOne =
        PostResultOne.fromJson(json.decode(result.body));
    setState(() {
      final snackBar = SnackBar(
        backgroundColor: postResultOne.success ? Colors.green : Colors.red,
        content: Text(postResultOne.message),
      );
      Scaffold.of(_context).showSnackBar(snackBar);
    });
    return postResultOne.success;
  }

  void clearControllers() {
    nameController.clear();
    mobileNumberController.clear();
    emailController.clear();
    addressController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    panCardNumberController.clear();
    bankAccountNumberController.clear();
    ifscCodeController.clear();

    otpController.clear();

    mobileNumberControllerSignIn.clear();
    passwordControllerSignIn.clear();

    rcDone = false;
    licenceDone = false;
    insuranceDone = false;
    roadTaxDone = false;
    rtoPassingDone = false;
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
                selectedWidgetMarker = WidgetMarker.credentials;
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

  Widget getCredentialsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyCredentials,
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
                            selectedWidgetMarker = WidgetMarker.options;
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
                controller: nameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _name,
                onFieldSubmitted: (term) {
                  _name.unfocus();
                  FocusScope.of(context).requestFocus(_mobileNumber);
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
                      controller: mobileNumberController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _mobileNumber,
                      onFieldSubmitted: (term) {
                        _mobileNumber.unfocus();
                        FocusScope.of(context).requestFocus(_email);
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _email,
                onFieldSubmitted: (term) {
                  _email.unfocus();
                  FocusScope.of(context).requestFocus(_address);
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
                controller: addressController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _address,
                onFieldSubmitted: (term) {
                  _address.unfocus();
                  FocusScope.of(context).requestFocus(_password);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on),
                  labelText: "Your Address",
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
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  focusNode: _password,
                  onFieldSubmitted: (term) {
                    _password.unfocus();
                    FocusScope.of(context).requestFocus(_confirmPassword);
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
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                focusNode: _confirmPassword,
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
                      passwordController.text.toString()) {
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
                    if (_formKeyCredentials.currentState.validate()) {
                      setState(() {
                        selectedWidgetMarker = WidgetMarker.documents;
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

  Future<void> getRcFile() async {
    rcFile = await FilePicker.getFile();
    if (rcFile.existsSync()) {
      setState(() {
        rcDone = true;
      });
    }
  }

  Future<void> getLicenceFile() async {
    licenceFile = await FilePicker.getFile();
    if (licenceFile.existsSync()) {
      setState(() {
        licenceDone = true;
      });
    }
  }

  Future<void> getInsuranceFile() async {
    insuranceFile = await FilePicker.getFile();
    if (insuranceFile.existsSync()) {
      setState(() {
        insuranceDone = true;
      });
    }
  }

  Future<void> getRoadTaxFile() async {
    roadTaxFile = await FilePicker.getFile();
    if (roadTaxFile.existsSync()) {
      setState(() {
        roadTaxDone = true;
      });
    }
  }

  Future<void> getRtoPassingFile() async {
    rtoPassingFile = await FilePicker.getFile();
    if (rtoPassingFile.existsSync()) {
      setState(() {
        rtoPassingDone = true;
      });
    }
  }

  Widget getDocumentsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyDocuments,
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
                            selectedWidgetMarker = WidgetMarker.credentials;
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
                            selectedWidgetMarker = WidgetMarker.options;
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
                readOnly: true,
                onTap: () => getRcFile(),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    rcDone ? Icons.check_box : Icons.add_box,
                    size: 35.0,
                    color: rcDone ? Colors.green : Color(0xff252427),
                  ),
                  border: InputBorder.none,
                  hintText: "Upload RC Book",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                readOnly: true,
                onTap: () => getLicenceFile(),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    licenceDone ? Icons.check_box : Icons.add_box,
                    size: 35.0,
                    color: licenceDone ? Colors.green : Color(0xff252427),
                  ),
                  border: InputBorder.none,
                  hintText: "Upload Driver's License",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                readOnly: true,
                onTap: () => getInsuranceFile(),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    insuranceDone ? Icons.check_box : Icons.add_box,
                    size: 35.0,
                    color: insuranceDone ? Colors.green : Color(0xff252427),
                  ),
                  border: InputBorder.none,
                  hintText: "Upload Insurance",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                readOnly: true,
                onTap: () => getRoadTaxFile(),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    roadTaxDone ? Icons.check_box : Icons.add_box,
                    size: 35.0,
                    color: roadTaxDone ? Colors.green : Color(0xff252427),
                  ),
                  border: InputBorder.none,
                  hintText: "Upload Road Tax Certificate",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                readOnly: true,
                onTap: () => getRtoPassingFile(),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    rtoPassingDone ? Icons.check_box : Icons.add_box,
                    size: 35.0,
                    color: rtoPassingDone ? Colors.green : Color(0xff252427),
                  ),
                  border: InputBorder.none,
                  hintText: "Upload RTO Passing",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (rcDone &&
                        licenceDone &&
                        insuranceDone &&
                        roadTaxDone &&
                        rtoPassingDone) {
                      setState(() {
                        selectedWidgetMarker = WidgetMarker.ownerDetails;
                      });
                    } else {
                      final snackBar = SnackBar(
                        content: Text('Please Upload All the Documents'),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
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

  Widget getOwnerDetailsBottomSheetWidget(
      context, ScrollController scrollController) {
    return ListView(controller: scrollController, children: <Widget>[
      SingleChildScrollView(
        child: Form(
          key: _formKeyOwnerDetails,
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
                            selectedWidgetMarker = WidgetMarker.documents;
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
                            selectedWidgetMarker = WidgetMarker.options;
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
                controller: panCardNumberController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                focusNode: _panCardNumber,
                onFieldSubmitted: (term) {
                  _panCardNumber.unfocus();
                  FocusScope.of(context).requestFocus(_bankAccountNumber);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.dialpad),
                  labelText: "PAN Card Number",
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
                controller: bankAccountNumberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _bankAccountNumber,
                onFieldSubmitted: (term) {
                  _bankAccountNumber.unfocus();
                  FocusScope.of(context).requestFocus(_ifscCode);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.credit_card),
                  labelText: "Bank Account Number",
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
                controller: ifscCodeController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                focusNode: _ifscCode,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.code),
                  labelText: "IFSC Code",
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeyOwnerDetails.currentState.validate()) {
                      postSignUpRequest(context).then((value) {
                        if (value == true) {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.otpVerification;
                          });
                        }
                      });
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
                            selectedWidgetMarker = WidgetMarker.documents;
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
                            selectedWidgetMarker = WidgetMarker.options;
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
                textInputAction: TextInputAction.next,
                focusNode: _name,
                onFieldSubmitted: (term) {
                  _name.unfocus();
                  FocusScope.of(context).requestFocus(_mobileNumber);
                },
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
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    postResendOtpRequest(context);
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
                    setState(() {
                      otpController.clear();
                    });
                    if (_formKeyOtp.currentState.validate()) {
                      postOtpVerificationRequest(context).then((value) {
                        if (value == true) {
                          print("OTP Verification Done");
                        }
                      });
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
                            selectedWidgetMarker = WidgetMarker.options;
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
                controller: passwordControllerSignIn,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: true,
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_formKeySignIn.currentState.validate()) {
                      postSignInRequest(context).then((value) {
                        if (value == true) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context, FadeRoute(page: HomePage()));
                        }
                      });
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
          GestureDetector(
            onTap: () {
              Navigator.push(context, FadeRoute(page: DriverUpcomingOrder()));
            },
            child: Icon(
              Icons.arrow_forward,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget getCredentialsWidget(context) {
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

  Widget getDocumentsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Upload",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Documents",
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

  Widget getOwnerDetailsWidget(context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3 - 20,
          ),
          Text(
            "Owner",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Details",
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
      case WidgetMarker.options:
        return getOptionsWidget(context);
      case WidgetMarker.credentials:
        return getCredentialsWidget(context);
      case WidgetMarker.documents:
        return getDocumentsWidget(context);
      case WidgetMarker.ownerDetails:
        return getOwnerDetailsWidget(context);
      case WidgetMarker.otpVerification:
        return getOtpVerificationWidget(context);
      case WidgetMarker.signIn:
        return getSignInWidget(context);
    }
    return getOptionsWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.options:
        return getOptionsBottomSheetWidget(context, scrollController);
      case WidgetMarker.credentials:
        return getCredentialsBottomSheetWidget(context, scrollController);
      case WidgetMarker.documents:
        return getDocumentsBottomSheetWidget(context, scrollController);
      case WidgetMarker.ownerDetails:
        return getOwnerDetailsBottomSheetWidget(context, scrollController);
      case WidgetMarker.otpVerification:
        return getOtpVerificationBottomSheetWidget(context, scrollController);
      case WidgetMarker.signIn:
        return getSignInBottomSheetWidget(context, scrollController);
    }
    return getOptionsBottomSheetWidget(context, scrollController);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.options:
        return Future.value(true);
      case WidgetMarker.credentials:
        setState(() {
          clearControllers();
          selectedWidgetMarker = WidgetMarker.options;
        });
        return Future.value(false);
      case WidgetMarker.documents:
        setState(() {
          selectedWidgetMarker = WidgetMarker.credentials;
        });
        return Future.value(false);
      case WidgetMarker.ownerDetails:
        setState(() {
          selectedWidgetMarker = WidgetMarker.documents;
        });
        return Future.value(false);
      case WidgetMarker.otpVerification:
        setState(() {
          selectedWidgetMarker = WidgetMarker.ownerDetails;
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
                    child:
                        getCustomBottomSheetWidget(context, scrollController),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
