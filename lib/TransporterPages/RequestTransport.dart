import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetLoggedIn.dart';

class RequestTransport extends StatefulWidget {
  RequestTransport({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RequestTransportState createState() => _RequestTransportState();
}

class _RequestTransportState extends State<RequestTransport> {
  final GlobalKey<FormState> _formRequestTransport = GlobalKey<FormState>();

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final departureController = TextEditingController();
  final weightController = TextEditingController();
  final remarkController = TextEditingController();

  final FocusNode _from = FocusNode();
  final FocusNode _to = FocusNode();
  final FocusNode _departure = FocusNode();
  final FocusNode _weight = FocusNode();
  final FocusNode _remark = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    departureController.dispose();
    weightController.dispose();
    remarkController.dispose();
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
                        "Request",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40.0),
                      ),
                      Text(
                        "Transport",
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
                        key: _formRequestTransport,
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
                              textInputAction: TextInputAction.next,
                              focusNode: _to,
                              onFieldSubmitted: (term) {
                                _to.unfocus();
                                FocusScope.of(context).requestFocus(_departure);
                              },
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
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    controller: departureController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _departure,
                                    onFieldSubmitted: (term) {
                                      _departure.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_weight);
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      errorStyle:
                                          TextStyle(color: Colors.white),
                                      prefixIcon: Icon(Icons.calendar_today),
                                      hintText: "Departure Date",
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
                                SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    controller: weightController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _weight,
                                    onFieldSubmitted: (term) {
                                      _weight.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_remark);
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      errorStyle:
                                          TextStyle(color: Colors.white),
                                      prefixIcon: Icon(Icons.event_seat),
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
                            TextFormField(
                                controller: remarkController,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                focusNode: _remark,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.text_fields),
                                  hintText: "Remark",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
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
                              height: 50.0,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (_formRequestTransport.currentState
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
                    child:
                        AccountBottomSheetLoggedIn(scrollController: scrollController)),
              );
            },
          ),
        ],
      ),
    );
  }
}
