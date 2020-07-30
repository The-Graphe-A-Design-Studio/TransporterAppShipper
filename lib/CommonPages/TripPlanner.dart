import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/LENOVO/Desktop/transporter-app/lib/BottomSheets/AccountBottomSheetDummy.dart';

class TripPlanner extends StatefulWidget {
  TripPlanner({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TripPlannerState createState() => _TripPlannerState();
}

class _TripPlannerState extends State<TripPlanner> {
  final GlobalKey<FormState> _formTripPlanner = GlobalKey<FormState>();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  String brandSelected = "Select Brand";
  String modelSelected = "Select Model";
  String fuelSelected = "Select Fuel Type";

  final FocusNode _from = FocusNode();
  final FocusNode _to = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
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
                        "Trip",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                      Text(
                        "Planner",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 4, bottom: 4, left: 1.0),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xff252427),
                                    size: 20.0,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 11.5,
                              ),
                              Text(
                                "One Way",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                            ],
                          )),
                      SizedBox(
                        height: 30.0,
                      ),
                      Form(
                        key: _formTripPlanner,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              controller: fromController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              focusNode: _from,
                              onFieldSubmitted: (term) {
                                _from.unfocus();
                                FocusScope.of(context).requestFocus(_to);
                              },
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
                              controller: toController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              focusNode: _to,
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
                              value: brandSelected,
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
                                  brandSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Brand',
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
                              height: 16.0,
                            ),
                            DropdownButton<String>(
                              value: modelSelected,
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
                                  modelSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Model',
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
                              height: 16.0,
                            ),
                            DropdownButton<String>(
                              value: fuelSelected,
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
                                  fuelSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Fuel Type',
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
                                  if (_formTripPlanner.currentState
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
