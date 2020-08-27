import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shipperapp/BottomSheets/AccountBottomSheetDummy.dart';
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
  UserTransporter userTransporter;

  PostLoad({Key key, this.userTransporter}) : super(key: key);

  @override
  _PostLoadState createState() => _PostLoadState();
}

class _PostLoadState extends State<PostLoad> {
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyFrom1 =
      new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyTo1 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyFrom2 =
      new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyTo2 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyFrom3 =
      new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyTo3 = new GlobalKey();
  final GlobalKey<FormState> _formPostLoad = GlobalKey<FormState>();

  AutoCompleteTextField from1TextField;
  AutoCompleteTextField to1TextField;
  AutoCompleteTextField from2TextField;
  AutoCompleteTextField to2TextField;
  AutoCompleteTextField from3TextField;
  AutoCompleteTextField to3TextField;
  final truckLoadController = TextEditingController();
  final expectedPriceController = TextEditingController();
  final advancePayController = TextEditingController();
  final timeController = TextEditingController();
  final contactController = TextEditingController();
  final contactPhoneController = TextEditingController();
  bool tripType = false;
  List<GooglePlaces> suggestedCityFrom = [];
  List<GooglePlaces> suggestedCityTo = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TruckCategory selectedTruckCategory;
  LoadMaterialType selectedLoadMaterialType;
  TruckPref selectedTruckPref;
  String selectedPriceUnit;
  String selectedPayTerm;
  List<LoadMaterialType> loadMaterialType = [];
  List<TruckCategory> truckType = [];
  List<TruckPref> truckPref = [];
  List<String> priceUnit = ["Tonnage", "Truck"];
  List<String> payTerms = [
    "Negotiable",
    "Advance",
    "Full Pay to Driver after Unloading"
  ];
  bool loadData = true;
  bool loadPref = false;

  final FocusNode _from1 = FocusNode();
  final FocusNode _to1 = FocusNode();
  final FocusNode _from2 = FocusNode();
  final FocusNode _to2 = FocusNode();
  final FocusNode _from3 = FocusNode();
  final FocusNode _to3 = FocusNode();
  final FocusNode _time = FocusNode();
  final FocusNode _contact = FocusNode();
  final FocusNode _contactPhone = FocusNode();

  @override
  void initState() {
    super.initState();
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
    HTTPHandler().postNewLoad([
      widget.userTransporter.id,
      from1TextField.textField.controller.text,
      tripType ? from2TextField.textField.controller.text : "",
      tripType ? from3TextField.textField.controller.text : "",
      to1TextField.textField.controller.text,
      tripType ? to2TextField.textField.controller.text : "",
      tripType ? to3TextField.textField.controller.text : "",
      selectedLoadMaterialType.name,
      (priceUnit.indexOf(selectedPriceUnit) + 1).toString(),
      truckLoadController.text,
      selectedTruckCategory.truckCatID,
      selectedTruckPref.name,
      selectedTruckPref.name,
      selectedTruckPref.name,
      expectedPriceController.text,
      (payTerms.indexOf(selectedPayTerm) + 1).toString(),
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
        loadPref = false;
      });
    });
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
      print("00");
      getData();
    }
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: (truckType.isEmpty || loadMaterialType.isEmpty || loadPref)
          ? LoadingBody()
          : Stack(
              children: [
                SingleChildScrollView(
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
                              from1TextField =
                                  AutoCompleteTextField<GooglePlaces>(
                                key: keyFrom1,
                                textInputAction: TextInputAction.next,
                                focusNode: _from1,
                                clearOnSubmit: false,
                                textChanged: (value) {
                                  getNewCityFrom(value);
                                },
                                suggestions: suggestedCityFrom,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.flight_takeoff),
                                  hintText: tripType
                                      ? "Source Address 1"
                                      : "Source Address",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                itemFilter: (item, query) {
                                  return true;
                                },
                                itemSorter: (a, b) {
                                  return a.description.compareTo(b.description);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    from1TextField.textField.controller.text =
                                        item.description;
                                  });
                                  _from1.unfocus();
                                  if (tripType) {
                                    FocusScope.of(context).requestFocus(_from2);
                                  } else {
                                    FocusScope.of(context).requestFocus(_to1);
                                  }
                                },
                                itemBuilder: (context, item) {
                                  return row(item);
                                },
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              tripType
                                  ? from2TextField =
                                      AutoCompleteTextField<GooglePlaces>(
                                      key: keyFrom2,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _from2,
                                      clearOnSubmit: false,
                                      textChanged: (value) {
                                        getNewCityFrom(value);
                                      },
                                      suggestions: suggestedCityFrom,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(Icons.flight_takeoff),
                                        hintText: "Source Address 2",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      itemFilter: (item, query) {
                                        return true;
                                      },
                                      itemSorter: (a, b) {
                                        return a.description
                                            .compareTo(b.description);
                                      },
                                      itemSubmitted: (item) {
                                        setState(() {
                                          from2TextField.textField.controller
                                              .text = item.description;
                                        });
                                        _from2.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_from3);
                                      },
                                      itemBuilder: (context, item) {
                                        return row(item);
                                      },
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                    ),
                              tripType
                                  ? SizedBox(
                                      height: 16.0,
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                    ),
                              tripType
                                  ? from3TextField =
                                      AutoCompleteTextField<GooglePlaces>(
                                      key: keyFrom3,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _from3,
                                      clearOnSubmit: false,
                                      textChanged: (value) {
                                        getNewCityFrom(value);
                                      },
                                      suggestions: suggestedCityFrom,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(Icons.flight_takeoff),
                                        hintText: "Source Address 3",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      itemFilter: (item, query) {
                                        return true;
                                      },
                                      itemSorter: (a, b) {
                                        return a.description
                                            .compareTo(b.description);
                                      },
                                      itemSubmitted: (item) {
                                        setState(() {
                                          from3TextField.textField.controller
                                              .text = item.description;
                                        });
                                        _from3.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_to1);
                                      },
                                      itemBuilder: (context, item) {
                                        return row(item);
                                      },
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                    ),
                              tripType
                                  ? SizedBox(
                                      height: 16.0,
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                    ),
                              to1TextField =
                                  AutoCompleteTextField<GooglePlaces>(
                                key: keyTo1,
                                textInputAction: tripType
                                    ? TextInputAction.next
                                    : TextInputAction.done,
                                focusNode: _to1,
                                clearOnSubmit: false,
                                textChanged: (value) {
                                  getNewCityTo(value);
                                },
                                suggestions: suggestedCityTo,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.flight_land),
                                  hintText: tripType
                                      ? "Destination Address 1"
                                      : "Destination Address",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                itemFilter: (item, query) {
                                  return true;
                                },
                                itemSorter: (a, b) {
                                  return a.description.compareTo(b.description);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    to1TextField.textField.controller.text =
                                        item.description;
                                  });
                                  if (tripType) {
                                    _to1.unfocus();
                                    FocusScope.of(context).requestFocus(_to2);
                                  }
                                },
                                itemBuilder: (context, item) {
                                  return row(item);
                                },
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              tripType
                                  ? to2TextField =
                                      AutoCompleteTextField<GooglePlaces>(
                                      key: keyTo2,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _to2,
                                      clearOnSubmit: false,
                                      textChanged: (value) {
                                        getNewCityTo(value);
                                      },
                                      suggestions: suggestedCityTo,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(Icons.flight_land),
                                        hintText: "Destination Address 2",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      itemFilter: (item, query) {
                                        return true;
                                      },
                                      itemSorter: (a, b) {
                                        return a.description
                                            .compareTo(b.description);
                                      },
                                      itemSubmitted: (item) {
                                        setState(() {
                                          to2TextField.textField.controller
                                              .text = item.description;
                                        });
                                        _to2.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_to3);
                                      },
                                      itemBuilder: (context, item) {
                                        return row(item);
                                      },
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                    ),
                              tripType
                                  ? SizedBox(
                                      height: 16.0,
                                    )
                                  : SizedBox(
                                      height: 0.0,
                                    ),
                              tripType
                                  ? to3TextField =
                                      AutoCompleteTextField<GooglePlaces>(
                                      key: keyTo3,
                                      textInputAction: TextInputAction.done,
                                      focusNode: _to3,
                                      clearOnSubmit: false,
                                      textChanged: (value) {
                                        getNewCityTo(value);
                                      },
                                      suggestions: suggestedCityTo,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        prefixIcon: Icon(Icons.flight_land),
                                        hintText: "Destination Address 3",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.amber,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      itemFilter: (item, query) {
                                        return true;
                                      },
                                      itemSorter: (a, b) {
                                        return a.description
                                            .compareTo(b.description);
                                      },
                                      itemSubmitted: (item) {
                                        setState(() {
                                          to3TextField.textField.controller
                                              .text = item.description;
                                        });
                                      },
                                      itemBuilder: (context, item) {
                                        return row(item);
                                      },
                                    )
                                  : SizedBox(
                                      height: 0.0,
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
                                    loadPref = true;
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
                              DropdownButton(
                                isExpanded: true,
                                hint: Text(
                                  "Select Truck Preferences",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: selectedTruckPref,
                                dropdownColor: Color(0xff252427),
                                style: TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (TruckPref value) {
                                  setState(() {
                                    selectedTruckPref = value;
                                  });
                                },
                                items: truckPref.map((TruckPref item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                }).toList(),
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
                                controller: timeController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                focusNode: _time,
                                onFieldSubmitted: (term) {
                                  _time.unfocus();
                                  FocusScope.of(context).requestFocus(_contact);
                                },
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
                                items: payTerms.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                controller: advancePayController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  suffixText: "%",
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  hintText: "Advance (In %)",
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
                        child: AccountBottomSheetDummy(),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
