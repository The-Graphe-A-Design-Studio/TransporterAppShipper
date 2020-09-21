import 'package:flutter/material.dart';
import 'package:shipperapp/Models/PostLoad.dart';
import 'package:shipperapp/MyConstants.dart';

class ViewLoadsScreen extends StatefulWidget {
  final List<PostLoad> activeLoads;
  final List<PostLoad> inactiveLoads;

  ViewLoadsScreen({
    Key key,
    @required this.activeLoads,
    @required this.inactiveLoads,
  }) : super(key: key);

  @override
  _ViewLoadsScreenState createState() => _ViewLoadsScreenState();
}

class _ViewLoadsScreenState extends State<ViewLoadsScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Loads'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: widget.activeLoads
                  .map((e) => Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        height: 310.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          children: [
                            infoRow(
                                'From', '${e.source[0].substring(0, 20)}...'),
                            infoRow('To',
                                '${e.destination[e.destination.length - 1].substring(0, 20)}...'),
                            infoRow('Material', '${e.material}'),
                            infoRow('Tonnage', '${e.tonnage}'),
                            infoRow('Truck Preferences', '${e.truckPref}'),
                            infoRow('Expected Price', '${e.exPrice}'),
                            infoRow('Payment Mode', '${e.payMode}'),
                            infoRow('Created On', '${e.createdOn}'),
                            infoRow('Expires On', '${e.expiresOn}'),
                            infoRow('Contact Person', '${e.contactPerson}'),
                            infoRow('Contact Person phone No.',
                                '${e.contactPhone}'),
                            Divider(),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, viewBids,
                                    arguments: e),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 40.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'View Bid',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            Column(
              children: widget.inactiveLoads
                  .map((e) => Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            width: MediaQuery.of(context).size.width,
                            height: 310.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: [
                                infoRow('From',
                                    '${e.source[0].substring(0, 20)}...'),
                                infoRow('To',
                                    '${e.destination[e.destination.length - 1].substring(0, 20)}...'),
                                infoRow('Material', '${e.material}'),
                                infoRow('Tonnage', '${e.tonnage}'),
                                infoRow('Truck Preferences', '${e.truckPref}'),
                                infoRow('Expected Price', '${e.exPrice}'),
                                infoRow('Payment Mode', '${e.payMode}'),
                                infoRow('Created On', '${e.createdOn}'),
                                infoRow('Expires On', '${e.expiresOn}'),
                                infoRow('Contact Person', '${e.contactPerson}'),
                                infoRow('Contact Person phone No.',
                                    '${e.contactPhone}'),
                                Divider(),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 40.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                      'View Bid',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: 0.5,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 10.0,
                              ),
                              padding: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width,
                              height: 310.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
