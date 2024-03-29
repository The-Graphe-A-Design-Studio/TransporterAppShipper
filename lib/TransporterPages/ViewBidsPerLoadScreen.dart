import 'package:flutter/material.dart';
import 'package:shipperapp/DialogScreens/DialogFailed.dart';
import 'package:shipperapp/DialogScreens/DialogProcessing.dart';
import 'package:shipperapp/DialogScreens/DialogSuccess.dart';
import 'package:shipperapp/HttpHandler.dart';
import 'package:shipperapp/Models/Bidder.dart';
import 'package:shipperapp/Models/PostLoad.dart';

class ViewBidsPerLoadScreen extends StatefulWidget {
  final PostLoad1 load;

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
              child: Text(
                'No Bids Yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
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
                  children: bids.map((e) {
                    print(e.price);
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width,
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
                          infoRow(
                              'Bid Status',
                              (e.bidStatus == '1')
                                  ? 'Accepted by Admin'
                                  : 'Accepted by Shipper'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (e.bidStatus == '1')
                                RaisedButton.icon(
                                  onPressed: () {
                                    print('accept');
                                    DialogProcessing().showCustomDialog(context,
                                        title: "Accpeting Bid",
                                        text: "Processing, Please Wait!");
                                    HTTPHandler()
                                        .acceptBid(widget.load.postId, e.bidId)
                                        .then((value) async {
                                      Navigator.of(context).pop();
                                      if (value.success) {
                                        Navigator.pop(context);
                                        DialogSuccess().showCustomDialog(
                                            context,
                                            title: "Accpeting Bid");
                                        Navigator.pop(context);
                                        await Future.delayed(
                                            Duration(seconds: 1), () {});
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                        DialogFailed().showCustomDialog(context,
                                            title: "Accpeting Bid",
                                            text: value.message);

                                        await Future.delayed(
                                            Duration(seconds: 3), () {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    }).catchError((error) async {
                                      Navigator.pop(context);
                                      DialogFailed().showCustomDialog(context,
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
                              if (e.bidStatus == '2')
                                RaisedButton.icon(
                                  onPressed: () {
                                    print('reject');
                                    DialogProcessing().showCustomDialog(context,
                                        title: "Rejecting Bid",
                                        text: "Processing, Please Wait!");
                                    HTTPHandler()
                                        .rejectBid(e.bidId)
                                        .then((value) async {
                                      Navigator.of(context).pop();
                                      if (value.success) {
                                        Navigator.pop(context);
                                        DialogSuccess().showCustomDialog(
                                            context,
                                            title: "Rejecting Bid");
                                        Navigator.pop(context);
                                        await Future.delayed(
                                            Duration(seconds: 1), () {});
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                        DialogFailed().showCustomDialog(context,
                                            title: "Rejecting Bid",
                                            text: value.message);
                                        await Future.delayed(
                                            Duration(seconds: 3), () {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    }).catchError((error) async {
                                      Navigator.pop(context);
                                      DialogFailed().showCustomDialog(context,
                                          title: "Rejecting Bid",
                                          text: "Network Error");
                                      await Future.delayed(
                                          Duration(seconds: 3), () {});
                                      Navigator.pop(context);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: Text('Reject'),
                                ),
                              SizedBox(width: 20.0),
                              RaisedButton.icon(
                                onPressed: () {
                                  print('delete');
                                  DialogProcessing().showCustomDialog(context,
                                      title: "Deleting Bid",
                                      text: "Processing, Please Wait!");
                                  HTTPHandler()
                                      .deleteBid(e.bidId)
                                      .then((value) async {
                                    Navigator.of(context).pop();
                                    if (value.success) {
                                      Navigator.pop(context);
                                      DialogSuccess().showCustomDialog(context,
                                          title: "Deleting Bid");
                                      Navigator.pop(context);
                                      await Future.delayed(
                                          Duration(seconds: 1), () {});
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);
                                      DialogFailed().showCustomDialog(context,
                                          title: "Deleting Bid",
                                          text: value.message);
                                      await Future.delayed(
                                          Duration(seconds: 3), () {});
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  }).catchError((error) async {
                                    Navigator.pop(context);
                                    DialogFailed().showCustomDialog(context,
                                        title: "Deleting Bid",
                                        text: "Network Error");
                                    await Future.delayed(
                                        Duration(seconds: 3), () {});
                                    Navigator.pop(context);
                                  });
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
                    );
                  }).toList(),
                ),
    );
  }
}
