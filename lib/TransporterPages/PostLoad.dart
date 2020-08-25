import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shipperapp/BottomSheets/AccountBottomSheetDummy.dart';
import 'package:shipperapp/CommonPages/LoadingBody.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/GooglePlaces.dart';
import 'package:shipperapp/Models/MaterialType.dart';
import 'package:shipperapp/Models/TruckCategory.dart';
import 'package:shipperapp/Models/TruckPref.dart';
import 'package:shipperapp/MyConstants.dart';

class PostLoad extends StatefulWidget {
  PostLoad({Key key}) : super(key: key);

  @override
  _PostLoadState createState() => _PostLoadState();
}

class _PostLoadState extends State<PostLoad> {
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyFrom = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<GooglePlaces>> keyTo = new GlobalKey();
  final GlobalKey<FormState> _formPostLoad = GlobalKey<FormState>();

  AutoCompleteTextField fromTextField;
  AutoCompleteTextField toTextField;
  final truckLoadController = TextEditingController();
  final timeController = TextEditingController();
  final contactController = TextEditingController();
  bool tripType = false;
  List<GooglePlaces> suggestedCityFrom = [];
  List<GooglePlaces> suggestedCityTo = [];

  TruckCategory selectedTruckCategory;
  LoadMaterialType selectedLoadMaterialType;
  TruckPref selectedTruckPref;
  String selectedPriceUnit;
  String selectedPayTerm;
  List<LoadMaterialType> loadMaterialType=[];
  List<TruckCategory> truckType=[];
  List<TruckPref> truckPref=[];
  List<String> priceUnit = ["Tonnage", "Truck"];
  List<String> payTerms = ["Negotiable", "Fixed"];
  bool loadData = true;
  bool loadPref = false;

  final FocusNode _from = FocusNode();
  final FocusNode _to = FocusNode();
  final FocusNode _time = FocusNode();
  final FocusNode _contact = FocusNode();

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
      var result = await http.get(autoCompleteLink + input);
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
      var result = await http.get(autoCompleteLink + input);
      suggestedCityTo.clear();
      for (var i in json.decode(result.body)["predictions"]) {
        suggestedCityTo.add(GooglePlaces.fromJson(i));
      }
      setState(() {});
    } catch (error) {
      print(error);
    }
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

  void  getTruckPrefData() async {
    HTTPHandler().getTruckPref([selectedTruckCategory.truckCatID]).then((value) {
      setState(() {
        truckPref = value;
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
          ),
        ),
        Divider(),
      ],
    );
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
                        Divider(color: Colors.white,),
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
                              fromTextField =
                                  AutoCompleteTextField<GooglePlaces>(
                                key: keyFrom,
                                textInputAction: TextInputAction.next,
                                focusNode: _from,
                                clearOnSubmit: false,
                                textChanged: (value) {
                                  print("here" + value);
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
                                  hintText: "From",
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
                                    fromTextField.textField.controller.text =
                                        item.description;
                                  });
                                  _from.unfocus();
                                  FocusScope.of(context).requestFocus(_to);
                                },
                                itemBuilder: (context, item) {
                                  return row(item);
                                },
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              toTextField = AutoCompleteTextField<GooglePlaces>(
                                key: keyTo,
                                textInputAction: TextInputAction.done,
                                focusNode: _to,
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
                                  hintText: "To",
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
                                    toTextField.textField.controller.text =
                                        item.description;
                                  });
                                },
                                itemBuilder: (context, item) {
                                  return row(item);
                                },
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
                              Divider(color: Colors.white,),
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
                                items: loadMaterialType.map((LoadMaterialType item) {
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
                                    child: TextFormField(
                                      controller: truckLoadController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      decoration: InputDecoration(
                                        suffixText: "Tons",
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.white),
                                        hintText: "Weight",
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
                                    ),
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
                              Divider(color: Colors.white,),
                              SizedBox(
                                height: 20.0,
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
                                height: 60.0,
                              ),
                              Text(
                                "Additional (Expiry & Point of Contact)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 21.0),
                              ),
                              Divider(color: Colors.white,),
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
                                  suffixText: "Days",
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.date_range),
                                  hintText: "Load Expires In",
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
                                height: 50.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (_formPostLoad.currentState.validate()) {
                                      final snackBar = SnackBar(
                                        content: Text('Request Sent'),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
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
