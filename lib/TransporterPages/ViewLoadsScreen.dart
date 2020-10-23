import 'package:flutter/material.dart';
import 'package:shipperapp/Models/PostLoad.dart';
import 'package:shipperapp/MyConstants.dart';

class ViewLoadsScreen extends StatefulWidget {
  final List<PostLoad1> activeLoads;
  final List<PostLoad1> inactiveLoads;

  ViewLoadsScreen({
    Key key,
    @required this.activeLoads,
    @required this.inactiveLoads,
  }) : super(key: key);

  @override
  _ViewLoadsScreenState createState() => _ViewLoadsScreenState();
}

class _ViewLoadsScreenState extends State<ViewLoadsScreen> {

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
                        // height: 310.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 15.0,
                                  height: 15.0,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.green[600],
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    '${e.source[0]}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 3.0,
                              ),
                              height: 16.0,
                              width: 1.5,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 15.0,
                                  height: 15.0,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red[600],
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    '${e.destination[0]}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Truck Type',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${e.truckPref}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30.0),
                                Text(
                                  '${e.truckType[0]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Products',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${e.material}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30.0),
                                if (e.exPrice.contains('truck'))
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '${e.noTruck}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expected Price',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${e.exPrice}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Payment Mode',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${e.payMode}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Created On',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${e.createdOn}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expires On',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${e.expiresOn}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                            // height: 310.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 15.0,
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.green[600],
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      (e.source[0].length >= 40)
                                          ? '${e.source[0].substring(0, 40)}...'
                                          : '${e.source[0]}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 3.0,
                                  ),
                                  height: 5.0,
                                  width: 1.5,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 3.0,
                                  ),
                                  height: 5.0,
                                  width: 1.5,
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 15.0,
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.red[600],
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      (e.destination[0].length >= 40)
                                          ? '${e.destination[0].substring(0, 40)}...'
                                          : '${e.destination[0]}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Truck Type',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          '${e.truckPref}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 30.0),
                                    Text(
                                      '${e.truckType[0]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Products',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '${e.material}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
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
                              height: 250.0,
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
