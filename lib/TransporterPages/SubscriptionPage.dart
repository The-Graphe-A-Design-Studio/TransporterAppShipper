import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubsriptionPage extends StatefulWidget {
  SubsriptionPage({Key key}) : super(key: key);

  @override
  _SubsriptionPageState createState() => _SubsriptionPageState();
}

class _SubsriptionPageState extends State<SubsriptionPage> {
  DateTime trialPeriodEnd;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      trialPeriodEnd = DateTime.parse(value.getString('trial_period_upto'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
