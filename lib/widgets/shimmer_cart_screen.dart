import '../util/styling.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'add_quantity_cart.dart';

class ShimmerCartScreen extends StatelessWidget {
  Size screenSize;
  ShimmerCartScreen({this.screenSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 2),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'CART',
                    style: TextStyle(
                        fontFamily: 'Galano Grotesque',
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Container(
                        color: Colors.black,
                        height: screenSize.height * 0.15,
                        width: screenSize.width * 0.4,
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'title',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Galano Grotesque'),
                        ),
                        Text(
                          'subTitle',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.gryTextColor,
                              fontFamily: 'Muli'),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.032,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '₹‎ productPrice',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppTheme.redButtonColor,
                                  fontFamily: 'Muli'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: AppTheme.gryButtonColor,
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Row(
                  children: <Widget>[
                    // Container(
                    //   color: Colors.red,
                    //   height: screenSize.height * 0.15,
                    //   width: screenSize.width * 0.4,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Container(
                        color: Colors.black,
                        height: screenSize.height * 0.15,
                        width: screenSize.width * 0.4,
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'title',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Galano Grotesque'),
                        ),
                        Text(
                          'subTitle',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.gryTextColor,
                              fontFamily: 'Muli'),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.032,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '₹‎ productPrice',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppTheme.redButtonColor,
                                  fontFamily: 'Muli'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: AppTheme.gryButtonColor,
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Have a promo code?',
                    style:
                        TextStyle(color: AppTheme.redButtonColor, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Divider(
                  color: AppTheme.gryTextColor,
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Price(items):',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.05,
                    ),
                    Text(
                      '‎₹‎',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Delivery Fees:',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.05,
                    ),
                    Container(
                      child: Text(
                        '‎₹‎',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Discount: ',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.05,
                    ),
                    Container(
                      child: Text(
                        '₹‎',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: AppTheme.gryTextColor,
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    '‎Total : ₹‎',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            baseColor: Colors.grey[350],
            highlightColor: Colors.grey[100]),
      ),
    );
  }
}
