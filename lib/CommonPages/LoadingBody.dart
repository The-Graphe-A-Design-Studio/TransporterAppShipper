import 'package:flutter/material.dart';
import 'package:shipperapp/BottomSheets/AccountBottomSheetDummyLoading.dart';

class LoadingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Spacer(),
            Center(
              child: Image(
                image: AssetImage('assets/images/logo_white.png'),
                height: 200.0,
                width: 200.0,
              ),
            ),
            SizedBox(height: 120.0,),
            Spacer(),
          ],
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.15,
          minChildSize: 0.15,
          maxChildSize: 0.15,
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
                  child: AccountBottomSheetDummyLoading(scrollController)),
            );
          },
        ),
      ],
    );
  }
}
