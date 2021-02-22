import '../util/styling.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerOrderHistory extends StatelessWidget {
  Size screenSize;
  ShimmerOrderHistory({this.screenSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 2),
            child: SingleChildScrollView(
              child: Column(
                children: [0, 1, 2, 3, 4, 5]
                    .map(
                      (_) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Order ID: ORDERuztYncls',
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      fontSize: 14,
                                      color: AppTheme.gryTextColor),
                                ),
                                Container(
                                  //margin: EdgeInsets.only(right: 100),
                                  child: Text(
                                    ' Aug 02, 2020',
                                    style: TextStyle(
                                        fontFamily: 'Muli',
                                        fontSize: 14,
                                        color: AppTheme.gryTextColor),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenSize.height * 0.025,
                            ),
                            Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Container(
                                    color: Colors.black,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.025,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Container(
                                    color: Colors.black,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.025,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Container(
                                    color: Colors.black,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Processing',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            baseColor: Colors.grey[350],
            highlightColor: Colors.grey[100]),
      ),
    );
  }
}
