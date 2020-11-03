import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/PostLoad.dart';
import 'package:shipperapp/Models/User.dart';
import 'package:shipperapp/MyConstants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipperapp/DialogScreens/DialogFailed.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountBottomSheetLoggedIn extends StatefulWidget {
  final ScrollController scrollController;
  final UserTransporter userTransporter;
  final List<PostLoad1> activeLoads;
  final List<PostLoad1> inactiveLoads;

  AccountBottomSheetLoggedIn({
    Key key,
    @required this.scrollController,
    this.userTransporter,
    this.activeLoads,
    this.inactiveLoads,
  }) : super(key: key);

  @override
  _AccountBottomSheetLoggedInState createState() =>
      _AccountBottomSheetLoggedInState();
}

class _AccountBottomSheetLoggedInState
    extends State<AccountBottomSheetLoggedIn> {
  Map<dynamic, dynamic> map;
  PickedFile file;

  Future getImageFromGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      file = image;
    });
  }

  Widget _listItem(
    String url,
    bool verified,
    int no,
  ) =>
      Stack(
        children: [
          Container(
            width: 150.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                image: (!verified && file != null)
                    ? FileImage(File(file.path))
                    : NetworkImage('https://truckwale.co.in/$url'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.only(
                left: 14.0,
                bottom: 4.0,
              ),
              height: 20.0,
              width: 20.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.0,
                  color: Colors.white,
                ),
              ),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 10.0,
              ),
            ),
          ),
          if (verified)
            Container(
              width: 150.0,
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 10.0),
              child: Container(
                width: 80.0,
                height: 30.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 150.0,
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () {
                  if (!verified && file != null) {
                    print('update');
                    if (no == 0) {
                      DialogProcessing().showCustomDialog(context,
                          title: "Uploading Pan Card",
                          text: "Processing, Please Wait!");
                      HTTPHandler().uploadDocsPic([
                        widget.userTransporter.mobileNumber,
                        "cu_pan_card",
                        file.path
                      ]).then((value) async {
                        if (value.success) {
                          Navigator.pop(context);
                          DialogSuccess().showCustomDialog(context,
                              title: "Uploading Pan Card");
                          await Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              file = null;
                            });
                          });
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          DialogFailed().showCustomDialog(context,
                              title: "Uploading Pan Card", text: value.message);
                          await Future.delayed(Duration(seconds: 3), () {});
                          Navigator.pop(context);
                        }
                      }).catchError((error) async {
                        Navigator.pop(context);
                        DialogFailed().showCustomDialog(context,
                            title: "Uploading Pan Card", text: "Network Error");
                        await Future.delayed(Duration(seconds: 3), () {});
                        Navigator.pop(context);
                      });
                    } else if (no == 3) {
                      DialogProcessing().showCustomDialog(context,
                          title: "Uploading Selfie",
                          text: "Processing, Please Wait!");
                      HTTPHandler().uploadDocsPic([
                        widget.userTransporter.mobileNumber,
                        "cu_selfie",
                        file.path
                      ]).then((value) async {
                        if (value.success) {
                          Navigator.pop(context);
                          DialogSuccess().showCustomDialog(context,
                              title: "Uploading Selfie");
                          await Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              file = null;
                            });
                          });
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          DialogFailed().showCustomDialog(context,
                              title: "Uploading Selfie", text: value.message);
                          await Future.delayed(Duration(seconds: 3), () {});
                          Navigator.pop(context);
                        }
                      }).catchError((error) async {
                        Navigator.pop(context);
                        DialogFailed().showCustomDialog(context,
                            title: "Uploading Selfie", text: "Network Error");
                        await Future.delayed(Duration(seconds: 3), () {});
                        Navigator.pop(context);
                      });
                    } else if (no == 4) {
                      DialogProcessing().showCustomDialog(context,
                          title: "Uploading Office Address Proof",
                          text: "Processing, Please Wait!");
                      HTTPHandler().uploadOfficeAddPic([
                        widget.userTransporter.mobileNumber,
                        map['company name'],
                        file.path
                      ]).then((value) async {
                        if (value.success) {
                          Navigator.pop(context);
                          DialogSuccess().showCustomDialog(context,
                              title: "Uploading Office Address Proof");
                          await Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              file = null;
                            });
                          });
                          Navigator.pop(context);
                          SharedPreferences.getInstance().then((value) {
                            value.setString(
                                "DocNumber${widget.userTransporter.id}", "4");
                          });
                        } else {
                          Navigator.pop(context);
                          DialogFailed().showCustomDialog(context,
                              title: "Uploading Office Address Proof",
                              text: value.message);
                          await Future.delayed(Duration(seconds: 3), () {});
                          Navigator.pop(context);
                        }
                      }).catchError((error) async {
                        Navigator.pop(context);
                        DialogFailed().showCustomDialog(context,
                            title: "Uploading Office Address Proof",
                            text: "Network Error");
                        await Future.delayed(Duration(seconds: 3), () {});
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    print('change');
                    getImageFromGallery();
                  }
                },
                child: Container(
                  width: 80.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    (!verified && file != null) ? 'Update' : 'Change',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            )
        ],
      );

  _getDocs() {
    HTTPHandler().getUserDocumentsData(widget.userTransporter.id).then((value) {
      setState(() {
        this.map = value;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: (map == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              controller: widget.scrollController,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 60.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        'https://truckwale.co.in/${map['selfie']}'),
                  ),
                  title: Text(
                    widget.userTransporter.compName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '+${widget.userTransporter.mobileNumberCode} ${widget.userTransporter.mobileNumber}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 30.0,
                    left: 30.0,
                  ),
                  width: double.infinity,
                  child: Text(
                    'Upload all docs to be verified',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  height: 175.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _listItem(
                        map['pan card'],
                        (map['pan card verified'].contains('1')) ? true : false,
                        0,
                      ),
                      _listItem(
                        map['address front'],
                        (map['address front verified'].contains('1'))
                            ? true
                            : false,
                        1,
                      ),
                      _listItem(
                        map['address back'],
                        (map['address back verified'].contains('1'))
                            ? true
                            : false,
                        2,
                      ),
                      _listItem(
                        map['selfie'],
                        (map['selfie verified'].contains('1')) ? true : false,
                        3,
                      ),
                      _listItem(
                        map['office address'],
                        (map['office address verified'].contains('1'))
                            ? true
                            : false,
                        4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      subscription,
                      arguments: widget.userTransporter,
                    );
                  },
                  leading: Icon(
                    Icons.toc,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Your Subscription',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'View Plan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      viewLoads,
                      arguments: [
                        widget.activeLoads,
                        widget.inactiveLoads,
                      ],
                    );
                  },
                  leading: Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Your Loads',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      myDel,
                      arguments: widget.userTransporter,
                    );
                  },
                  leading: Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                  ),
                  title: Text(
                    'My Deliveries',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    HTTPHandler().signOut(
                      context,
                      userMobile: widget.userTransporter.mobileNumber,
                    );
                  },
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
