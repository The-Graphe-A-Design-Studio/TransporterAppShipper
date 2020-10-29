import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:shipperapp/CommonPages/LoadingBody.dart';
import 'package:shipperapp/DialogScreens/DialogFailed.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/GooglePlaces.dart';
import 'package:shipperapp/Models/MaterialType.dart';
import 'package:shipperapp/Models/TruckCategory.dart';
import 'package:shipperapp/Models/TruckPref.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';

class PostLoad extends StatefulWidget {
  final UserTransporter userTransporter;

  PostLoad({Key key, this.userTransporter}) : super(key: key);

  @override
  _PostLoadState createState() => _PostLoadState();
}

class _PostLoadState extends State<PostLoad> {
  final GlobalKey<FormState> _formPostLoad = GlobalKey<FormState>();

  List<DynamicText> fromListText = [new DynamicText("Source Location")];
  List<DynamicText> toListText = [new DynamicText("Destination Location")];
  int fromCount = 1, toCount = 1;
  final truckLoadController = TextEditingController();
  final expectedPriceController = TextEditingController();
  final advancePayController = TextEditingController();
  final timeController = TextEditingController();
  final contactController = TextEditingController();
  final contactPhoneController = TextEditingController();
  bool tripType = false;
  List<GooglePlaces> suggestedCityFrom = [];
  List<FilterChipWidget> filterChipList = [];
  List<GooglePlaces> suggestedCityTo = [];
  List<String> selectedTruckPrefs = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TruckCategory selectedTruckCategory;
  LoadMaterialType selectedLoadMaterialType;
  String selectedPriceUnit;
  String selectedPayTerm;
  List<LoadMaterialType> loadMaterialType = [];
  List<TruckCategory> truckType = [];
  List<TruckPref> truckPref = [];
  List<String> priceUnit = ["Tonnage", "Truck"];
  List<String> payTerms = [
    // "Negotiable",
    "Advance",
    "Full Pay to Driver after Unloading"
  ];
  bool loadData = true;
  bool loadPref = false;

  final FocusNode _contact = FocusNode();
  final FocusNode _contactPhone = FocusNode();

  @override
  void initState() {
    super.initState();
    contactController.text = widget.userTransporter.compName;
    contactPhoneController.text = widget.userTransporter.mobileNumber;
    setState(() {});
  }

  void update() {
    setState(() {});
  }

  @override
  void dispose() {
    timeController.dispose();
    truckLoadController.dispose();
    contactController.dispose();
    super.dispose();
  }

  void getNewCityFrom(String input) async {
    try {
      var result = await http.get(autoCompleteLinkFullAdd + input);
      suggestedCityFrom.clear();
      for (var i in json.decode(result.body)["predictions"]) {
        suggestedCityFrom.add(GooglePlaces.fromJson(i));
      }
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void getNewCityTo(String input) async {
    try {
      var result = await http.get(autoCompleteLinkFullAdd + input);
      suggestedCityTo.clear();
      for (var i in json.decode(result.body)["predictions"]) {
        suggestedCityTo.add(GooglePlaces.fromJson(i));
      }
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void postNewLoad(BuildContext _context) {
    DialogProcessing().showCustomDialog(context,
        title: "Post Load", text: "Processing, Please Wait!");
    String sourceStr = "";
    String destinationStr = "";
    String typesStr = "";
    int ii = 1;
    for (var i in fromListText) {
      sourceStr += i.controller.text.toString().trim();
      if (ii < fromCount) sourceStr += "* ";
      ii++;
    }
    ii = 1;
    for (var i in toListText) {
      destinationStr += i.controller.text.toString().trim();
      if (ii < toCount) destinationStr += "* ";
      ii++;
    }
    ii = 1;
    List<String> tempId = [];
    for (var i in filterChipList) {
      if (i.isSelected) {
        tempId.add(i.truckPref.id);
      }
    }
    for (var i in tempId) {
      typesStr += i.toString().trim();
      if (ii < tempId.length) typesStr += "* ";
      ii++;
    }
    HTTPHandler().postNewLoad([
      widget.userTransporter.id,
      sourceStr,
      destinationStr,
      selectedLoadMaterialType.name,
      (priceUnit.indexOf(selectedPriceUnit) + 1).toString(),
      truckLoadController.text,
      selectedTruckCategory.truckCatID,
      typesStr,
      expectedPriceController.text,
      (payTerms.indexOf(selectedPayTerm) + 2).toString(),
      advancePayController.text,
      "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, "0")}-${selectedDate.day.toString().padLeft(2, "0")} ${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}:00",
      contactController.text,
      contactPhoneController.text
    ]).then((value) async {
      if (value.success) {
        Navigator.pop(context);
        DialogSuccess().showCustomDialog(context, title: "Post Load");
        await Future.delayed(Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context);
        DialogFailed()
            .showCustomDialog(context, title: "Post Load", text: value.message);
        await Future.delayed(Duration(seconds: 3), () {});
        Navigator.pop(context);
      }
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed()
          .showCustomDialog(context, title: "Post Load", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
  }

  void getData() async {
    HTTPHandler().getTruckCategory().then((value) {
      setState(() {
        truckType = value;
      });
    });
    HTTPHandler().getMaterialType().then((value) {
      setState(() {
        loadMaterialType = value;
      });
    });
  }

  dataPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1000)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  timePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void getTruckPrefData() async {
    DialogProcessing().showCustomDialog(context,
        title: "Truck Prefs", text: "Please Wait...");
    HTTPHandler()
        .getTruckPref([selectedTruckCategory.truckCatID]).then((value) {
      truckPref.clear();
      var temp = [];
      for (TruckPref i in value) {
        if (!temp.contains(i.name)) {
          truckPref.add(i);
          temp.add(i.name);
        }
      }
      setState(() {
        filterChipList = truckPref.map((TruckPref tpp) {
          return FilterChipWidget(
            truckPref: tpp,
            isSelected: false,
          );
        }).toList();
      });
      Navigator.pop(context);
    }).catchError((error) async {
      Navigator.pop(context);
      DialogFailed().showCustomDialog(context,
          title: "Truck Prefs", text: "Network Error");
      await Future.delayed(Duration(seconds: 3), () {});
      Navigator.pop(context);
    });
    ;
  }

  Widget row(GooglePlaces gp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            gp.description,
            style: TextStyle(fontSize: 16.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget getCustomTextField() {
    if (!priceUnit.contains(selectedPriceUnit)) {
      return TextFormField(
        controller: truckLoadController,
        readOnly: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(color: Colors.white),
          hintText: "Select Unit",
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
      );
    } else if (selectedPriceUnit == priceUnit[0]) {
      return TextFormField(
        controller: truckLoadController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: InputDecoration(
          suffixText: "Tons",
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(color: Colors.white),
          hintText: "Weight",
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
      );
    } else {
      return TextFormField(
        controller: truckLoadController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: InputDecoration(
          suffixText: "Truck(s)",
          fillColor: Colors.white,
          filled: true,
          errorStyle: TextStyle(color: Colors.white),
          hintText: "Trucks",
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadData) {
      loadData = false;
      getData();
    }
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: (truckType.isEmpty || loadMaterialType.isEmpty)
          ? LoadingBody()
          : Stack(
              children: [
                SingleChildScrollView(
                  primary: true,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 60.0,
                        ),
                        Text(
                          "Post",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40.0),
                        ),
                        Text(
                          "Load",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40.0),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Text(
                          "Loading and Unloading Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 21.0),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Single",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                Text(
                                  "Loading and Unloading",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Switch(
                              value: tripType,
                              onChanged: (value) {
                                setState(() {
                                  fromListText = [
                                    new DynamicText("Source Location")
                                  ];
                                  toListText = [
                                    new DynamicText("Destination Location")
                                  ];
                                  fromCount = 1;
                                  toCount = 1;
                                  tripType = value;
                                });
                              },
                              inactiveTrackColor: Colors.green.withOpacity(0.6),
                              activeTrackColor: Colors.blue.withOpacity(0.6),
                              activeColor: Colors.white,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Multiple",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                Text(
                                  "Loading and Unloading",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Form(
                          key: _formPostLoad,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Choose Source Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 18.0),
                                  ),
                                  Spacer(),
                                  tripType
                                      ? GestureDetector(
                                          onTap: () {
                                            if (fromCount > 1) {
                                              setState(() {
                                                fromCount--;
                                                fromListText.removeLast();
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.indeterminate_check_box,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  tripType
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              fromCount++;
                                              fromListText.add(new DynamicText(
                                                  "Source Location $fromCount"));
                                            });
                                          },
                                          child: Icon(
                                            Icons.add_box,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                itemCount: fromListText.length,
                                itemBuilder: (_, i) => fromListText[i],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Choose Destination Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 18.0),
                                  ),
                                  Spacer(),
                                  tripType
                                      ? GestureDetector(
                                          onTap: () {
                                            if (toCount > 1) {
                                              setState(() {
                                                toCount--;
                                                toListText.removeLast();
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.indeterminate_check_box,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  tripType
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              toCount++;
                                              toListText.add(new DynamicText(
                                                  "Destination Location $toCount"));
                                            });
                                          },
                                          child: Icon(
                                            Icons.add_box,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                itemCount: toListText.length,
                                itemBuilder: (_, i) => toListText[i],
                              ),
                              SizedBox(
                                height: 60.0,
                              ),
                              Text(
                                "Product & Truck Requirements",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 21.0),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              DropdownButton(
                                isExpanded: true,
                                hint: Text(
                                  "Select Material Type",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: selectedLoadMaterialType,
                                dropdownColor: Color(0xff252427),
                                style: TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (LoadMaterialType value) {
                                  setState(() {
                                    selectedLoadMaterialType = value;
                                  });
                                },
                                items: loadMaterialType
                                    .map((LoadMaterialType item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Text(
                                        "Select Price Unit",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      value: selectedPriceUnit,
                                      dropdownColor: Color(0xff252427),
                                      style: TextStyle(color: Colors.white),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          selectedPriceUnit = value;
                                        });
                                      },
                                      items: priceUnit.map((String item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Flexible(
                                    child: getCustomTextField(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              DropdownButton(
                                isExpanded: true,
                                hint: Text(
                                  "Select Truck Category",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: selectedTruckCategory,
                                dropdownColor: Color(0xff252427),
                                style: TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (TruckCategory value) {
                                  setState(() {
                                    selectedTruckCategory = value;
                                    selectedTruckPrefs.clear();
                                  });
                                  getTruckPrefData();
                                },
                                items: truckType.map((TruckCategory item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item.truckCatName),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Choose Truck Preferences",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                    Divider(),
                                    Wrap(
                                      spacing: 5.0,
                                      runSpacing: 5.0,
                                      children: filterChipList,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 60.0,
                              ),
                              Text(
                                "Price & Payment Terms",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 21.0),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: expectedPriceController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  prefixText: "Rs.  ",
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  hintText: "Expected Price",
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
                              DropdownButton(
                                isExpanded: true,
                                hint: Text(
                                  "Select Price & Payment Term",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: selectedPayTerm,
                                dropdownColor: Color(0xff252427),
                                style: TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    selectedPayTerm = value;
                                  });
                                },
                                items: (widget.userTransporter.planType == '3')
                                    ? [
                                        DropdownMenuItem(
                                          value: payTerms[0],
                                          child: Text(payTerms[0]),
                                        )
                                      ]
                                    : payTerms.map((String item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              selectedPayTerm == payTerms[0]
                                  ? TextFormField(
                                      controller: advancePayController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        suffixText: "%",
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        hintText: "Advance (In %)",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
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
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 60.0,
                              ),
                              Text(
                                "Additional (Expiry & Point of Contact)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 21.0),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      readOnly: true,
                                      onTap: () => dataPicker(context),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(Icons.date_range),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        hintText: selectedDate.day.toString() +
                                            " / " +
                                            selectedDate.month.toString() +
                                            " / " +
                                            selectedDate.year.toString(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      readOnly: true,
                                      onTap: () => timePicker(context),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(Icons.access_time),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        hintText: selectedTime.hour.toString() +
                                            " : " +
                                            selectedTime.minute.toString() +
                                            " : 00",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                controller: contactController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                focusNode: _contact,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.contact_phone),
                                  hintText: "Point of Contact",
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
                                controller: contactPhoneController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                focusNode: _contactPhone,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.dialpad),
                                  hintText: "Phone Number",
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
                                height: 50.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (_formPostLoad.currentState.validate()) {
                                      postNewLoad(context);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                        "Post Load",
                                        style: TextStyle(
                                            color: Color(0xff252427),
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2.0, color: Color(0xff252427)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.08,
                  minChildSize: 0.08,
                  maxChildSize: 0.9,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Hero(
                      tag: 'AnimeBottom',
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0),
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
                        // child: AccountBottomSheetDummy(),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final TruckPref truckPref;
  bool isSelected;

  FilterChipWidget({Key key, this.truckPref, this.isSelected})
      : super(key: key);

  @override
  FilterChipWidgetState createState() => FilterChipWidgetState();
}

class FilterChipWidgetState extends State<FilterChipWidget> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.truckPref.name),
      labelStyle: TextStyle(
          color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      selected: widget.isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.blue.withOpacity(0.6),
      onSelected: (selected) {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      checkmarkColor: Colors.white,
      selectedColor: Color(0xff252427),
    );
  }
}

class DynamicText extends StatelessWidget {
  final String hintText;

  DynamicText(this.hintText);

  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        Prediction p = await PlacesAutocomplete.show(
            context: context,
            apiKey: GoogleMapsKey,
            mode: Mode.overlay,
            language: "en",
            startText: controller.text,
            components: [Component(Component.country, "in")],
            types: ["address"]);
        if (p != null) {
          controller.text = p.description;
        }
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        errorStyle: TextStyle(color: Colors.white),
        hintText: hintText,
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
    );
  }
}
