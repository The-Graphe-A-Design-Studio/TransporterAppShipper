import 'package:flutter/material.dart';

class AccountBottomSheetDummyLoading extends StatelessWidget {
  final ScrollController scrollController;

  AccountBottomSheetDummyLoading(this.scrollController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ListView(controller: scrollController, children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "Fetching Data...",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200.0,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),),
            ),
          ),
        ]),
      ),
    );
  }
}
