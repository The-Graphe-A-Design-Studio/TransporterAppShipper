import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetDummy.dart';
import 'package:shipperapp/Models/GooglePlaces.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:http/http.dart' as http;

class FreightCalculator extends StatefulWidget {
  FreightCalculator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FreightCalculatorState createState() => _FreightCalculatorState();
}

class _FreightCalculatorState extends State<FreightCalculator> {
  final GlobalKey<FormState> _formFreightCalculator = GlobalKey<FormState>();

  final fromTextField = TextEditingController();
  final toTextField = TextEditingController();
  String truckTypeSelected = "Select Truck Type";
  List<GooglePlaces> suggestedCityFrom = [];
  List<GooglePlaces> suggestedCityTo = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    return Scaffold(
      backgroundColor: Color(0xff252427),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
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
                        "Freight",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                      Text(
                        "Calculator",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Form(
                        key: _formFreightCalculator,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: fromTextField,
                              readOnly: true,
                              onTap: () async {
                                Prediction p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: GoogleApiKey,
                                    mode: Mode.overlay,
                                    language: "en",
                                    startText: fromTextField.text,
                                    components: [
                                      Component(Component.country, "in")
                                    ],
                                    types: [
                                      "address"
                                    ]);
                                if (p != null) {
                                  fromTextField.text = p.description;
                                }
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(color: Colors.white),
                                hintText: "Source Location",
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
                            TextFormField(
                              controller: toTextField,
                              readOnly: true,
                              onTap: () async {
                                Prediction p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: GoogleApiKey,
                                    mode: Mode.overlay,
                                    language: "en",
                                    startText: toTextField.text,
                                    components: [
                                      Component(Component.country, "in")
                                    ],
                                    types: [
                                      "address"
                                    ]);
                                if (p != null) {
                                  toTextField.text = p.description;
                                }
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: TextStyle(color: Colors.white),
                                hintText: "Destination Location",
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
                            DropdownButton<String>(
                              value: truckTypeSelected,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 40,
                              elevation: 30,
                              isExpanded: true,
                              dropdownColor: Color(0xff252427),
                              style: TextStyle(color: Colors.white),
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  truckTypeSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Truck Type',
                                'One',
                                'Two',
                                'Free',
                                'Four'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (_formFreightCalculator.currentState
                                      .validate()) {
                                    final snackBar = SnackBar(
                                      content: Text('Request Sent'),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  child: Center(
                                    child: Text(
                                      "Submit",
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.08,
            minChildSize: 0.08,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
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
