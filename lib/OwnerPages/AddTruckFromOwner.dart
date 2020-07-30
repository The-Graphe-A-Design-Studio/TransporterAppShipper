import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/DialogScreens/DialogFailed.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/DialogScreens/DialogProcessing.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/DialogScreens/DialogSuccess.dart';
import 'package:transportationapp/HttpHandler.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/Models/TruckCategory.dart';
import 'package:transportationapp/Models/User.dart';

class AddTruckOwner extends StatefulWidget {
  final UserOwner userOwner;

  AddTruckOwner({Key key, this.userOwner}) : super(key: key);

  @override
  _AddTruckOwnerState createState() => _AddTruckOwnerState();
}

enum WidgetMarker {
  credentials,
  documents,
}

class _AddTruckOwnerState extends State<AddTruckOwner> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.credentials;

  final GlobalKey<FormState> _formKeyCredentials = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDocuments = GlobalKey<FormState>();

  final truckNumberController = TextEditingController();
  final truckLoadController = TextEditingController();
  final truckDriverNameController = TextEditingController();
  final truckDriverMobileNumberController = TextEditingController();
  TruckCategory selectedTruckCategory;
  List<TruckCategory> listOfCat = [];
  bool loadCat = true;

  File rcFile, licenceFile, insuranceFile, roadTaxFile, rtoPassingFile;
  bool rcDone, licenceDone, insuranceDone, roadTaxDone, rtoPassingDone;

  final FocusNode _truckNumber = FocusNode();
  final FocusNode _truckLoad = FocusNode();
  final FocusNode _truckDriverName = FocusNode();
  final FocusNode _truckDriverNumber = FocusNode();

  @override
  void initState() {
    super.initState();
    selectedWidgetMarker = WidgetMarker.credentials;
    rcDone = false;
    licenceDone = false;
    insuranceDone = false;
    roadTaxDone = false;
    rtoPassingDone = false;
  }

  @override
  void dispose() {
    truckNumberController.dispose();
    truckLoadController.dispose();
    truckDriverNameController.dispose();
    truckDriverMobileNumberController.dispose();

    super.dispose();
  }

  void clearControllers() {
    truckNumberController.clear();
    truckLoadController.clear();
    truckDriverNameController.clear();
    truckDriverMobileNumberController.clear();

    rcDone = false;
    licenceDone = false;
    insuranceDone = false;
    roadTaxDone = false;
    rtoPassingDone = false;
  }

  void postAddTruckRequest(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Adding Truck", text: "Processing, Please Wait!");
    HTTPHandler().addTrucksOwner([
      widget.userOwner.oId.toString(),
      selectedTruckCategory.truckCatID.toString(),
      truckNumberController.text.toString(),
      truckLoadController.text.toString(),
      truckDriverNameController.text.toString(),
      '91',
      truckDriverMobileNumberController.text.toString(),
      rcFile.path.toString(),
      licenceFile.path.toString(),
      insuranceFile.path.toString(),
      roadTaxFile.path.toString(),
      rtoPassingFile.path.toString()
    ]).then((value) async {
      Navigator.pop(context);
      if (value.success) {
        DialogSuccess().showCustomDialog(context, title: "Adding Truck");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        DialogFailed().showCustomDialog(context,
            title: "Adding Truck", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    })/*.catchError((error) async {
      print(error);
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Adding Truck", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    })*/;
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
                          Navigator.pop(context);
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
              DropdownButton(
                isExpanded: true,
                hint: Text("Select Truck Category"),
                value: selectedTruckCategory,
                onChanged: (TruckCategory value) {
                  setState(() {
                    selectedTruckCategory = value;
                  });
                },
                dropdownColor: Colors.white,
                items: listOfCat.map((TruckCategory item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.truckCatName),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: truckNumberController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                focusNode: _truckNumber,
                onFieldSubmitted: (term) {
                  _truckNumber.unfocus();
                  FocusScope.of(context).requestFocus(_truckLoad);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Truck Number",
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
                  controller: truckLoadController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  focusNode: _truckLoad,
                  onFieldSubmitted: (term) {
                    _truckLoad.unfocus();
                    FocusScope.of(context).requestFocus(_truckDriverName);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.event_seat),
                    labelText: "Truck Capacity (In Tons)",
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
                controller: truckDriverNameController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _truckDriverName,
                onFieldSubmitted: (term) {
                  _truckDriverName.unfocus();
                  FocusScope.of(context).requestFocus(_truckDriverNumber);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Driver Name",
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
                      controller: truckDriverMobileNumberController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: _truckDriverNumber,
                      decoration: InputDecoration(
                        labelText: "Driver Mobile Number",
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (selectedTruckCategory != null) {
                      if (_formKeyCredentials.currentState.validate()) {
                        setState(() {
                          selectedWidgetMarker = WidgetMarker.documents;
                        });
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.black,
                        content: Text(
                          "Please Choose a Truck Category",
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
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
                            Navigator.pop(context);
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
                      postAddTruckRequest(context);
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

  Widget getCustomWidget(context) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.credentials:
        return getCredentialsWidget(context);
      case WidgetMarker.documents:
        return getDocumentsWidget(context);
    }
    return getCredentialsWidget(context);
  }

  Widget getCustomBottomSheetWidget(
      context, ScrollController scrollController) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.credentials:
        return getCredentialsBottomSheetWidget(context, scrollController);
      case WidgetMarker.documents:
        return getDocumentsBottomSheetWidget(context, scrollController);
    }
    return getCredentialsBottomSheetWidget(context, scrollController);
  }

  Future<bool> onBackPressed() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.credentials:
        return Future.value(true);
      case WidgetMarker.documents:
        setState(() {
          selectedWidgetMarker = WidgetMarker.credentials;
        });
        return Future.value(false);
    }
    return Future.value(true);
  }

  void getCategories() async {
    listOfCat = await HTTPHandler().getTruckCategory();
  }

  @override
  Widget build(BuildContext context) {
    if (loadCat) {
      loadCat = false;
      getCategories();
    }
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
