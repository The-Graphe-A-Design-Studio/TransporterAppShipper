import 'package:flutter/material.dart';

class AccountBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  AccountBottomSheet({Key key, @required this.scrollController}) : super(key: key);

  @override
  _AccountBottomSheetState createState() => _AccountBottomSheetState();
}

class _AccountBottomSheetState extends State<AccountBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
      ],
    );
  }
}
