import 'package:flutter/material.dart';
import 'package:shipperapp/DialogScreens/DialogFailed.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/Bidder.dart';
import 'package:shipperapp/Models/PostLoad.dart';

class ViewBidsPerLoadScreen extends StatefulWidget {
  final PostLoad load;

  ViewBidsPerLoadScreen({Key key, @required this.load}) : super(key: key);

  @override
  _ViewBidsPerLoadScreenState createState() => _ViewBidsPerLoadScreenState();
}

class _ViewBidsPerLoadScreenState extends State<ViewBidsPerLoadScreen> {
  List<Bidder> bids;

  Widget infoRow(String title, String value) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(height: 5.0),
        ],
      );

  @override
  void initState() {
    super.initState();
    HTTPHandler().getBids(widget.load.postId).then((value) {
      setState(() {
        bids = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bids'),
      ),
      body: (bids == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (bids.length == 0)
              ? Center(
                  child: Text(
                  'No Bids Yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ))
              : Column(
                  children: bids
                      .map((e) => Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                            height: 170.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: [
                                infoRow('Bidder Type', e.type),
                                infoRow('Bidder Name', e.bidderName),
                                infoRow('Bidder Contact', e.bidderContact),
                                Divider(),
                                infoRow('Bidder Price', e.price),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton.icon(
                                      onPressed: () {
                                        print('accept');
                                        DialogProcessing().showCustomDialog(
                                            context,
                                            title: "Accpeting Bid",
                                            text: "Processing, Please Wait!");
                                        HTTPHandler()
                                            .acceptBid(
                                                widget.load.postId, e.bidId)
                                            .then((value) async {
                                          Navigator.of(context).pop();
                                          if (value.success) {
                                            Navigator.pop(context);
                                            DialogSuccess().showCustomDialog(
                                                context,
                                                title: "Accpeting Bid");
                                            await Future.delayed(
                                                Duration(seconds: 1), () {});
                                            Navigator.pop(context);
                                          } else {
                                            Navigator.pop(context);
                                            DialogFailed().showCustomDialog(
                                                context,
                                                title: "Accpeting Bid",
                                                text: value.message);
                                            await Future.delayed(
                                                Duration(seconds: 3), () {});
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        }).catchError((error) async {
                                          Navigator.pop(context);
                                          DialogFailed().showCustomDialog(
                                              context,
                                              title: "Accpeting Bid",
                                              text: "Network Error");
                                          await Future.delayed(
                                              Duration(seconds: 3), () {});
                                          Navigator.pop(context);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.done,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      label: Text('Accept'),
                                    ),
                                    RaisedButton.icon(
                                      onPressed: () {
                                        print('accept');
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      label: Text('Reject'),
                                    ),
                                    RaisedButton.icon(
                                      onPressed: () {
                                        print('delete');
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      label: Text('Delete'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
    );
  }
}
