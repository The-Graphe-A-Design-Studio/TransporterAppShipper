import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transportationapp/AccountBottomSheetDummy.dart';

class TollCalculator extends StatefulWidget {
  TollCalculator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TollCalculatorState createState() => _TollCalculatorState();
}

class _TollCalculatorState extends State<TollCalculator> {
  final GlobalKey<FormState> _formTollCalculator = GlobalKey<FormState>();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  String vehicleTypeSelected = "Select Vehicle Type";

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
                        "Toll",
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
                        key: _formTollCalculator,
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
                              value: vehicleTypeSelected,
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
                                  vehicleTypeSelected = newValue;
                                });
                              },
                              items: <String>[
                                'Select Vehicle Type',
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
                                  if (_formTollCalculator.currentState
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
