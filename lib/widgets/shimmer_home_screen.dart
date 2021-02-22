import 'package:Machranga/util/images.dart';
import 'package:Machranga/util/styling.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHomeScreen extends StatelessWidget {
  Size screenSize;
  ShimmerHomeScreen({this.screenSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: Center(
        child: Shimmer.fromColors(
            direction: ShimmerDirection.ltr,
            period: Duration(seconds: 5),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Container(
                    color: Colors.black,
                    width: screenSize.width,
                    height: screenSize.height * 0.25,
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.25,
                  height: screenSize.height * 0.022,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            color: Colors.black,
                            height: screenSize.height * 0.05,
                            width: screenSize.width * 0.2,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                            width: screenSize.width * 0.2,
                          ),
                          Container(
                            height: screenSize.height * 0.022,
                            width: screenSize.width * 0.2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                      width: screenSize.width * 0.05,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            color: Colors.black,
                            height: screenSize.height * 0.05,
                            width: screenSize.width * 0.2,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                            width: screenSize.width * 0.2,
                          ),
                          Container(
                            height: screenSize.height * 0.022,
                            width: screenSize.width * 0.2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                      width: screenSize.width * 0.05,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            color: Colors.black,
                            height: screenSize.height * 0.05,
                            width: screenSize.width * 0.2,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                            width: screenSize.width * 0.2,
                          ),
                          Container(
                            height: screenSize.height * 0.022,
                            width: screenSize.width * 0.2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                      width: screenSize.width * 0.03,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            color: Colors.black,
                            height: screenSize.height * 0.05,
                            width: screenSize.width * 0.2,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                            width: screenSize.width * 0.2,
                          ),
                          Container(
                            height: screenSize.height * 0.022,
                            width: screenSize.width * 0.2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: screenSize.width * 0.25,
                  height: screenSize.height * 0.022,
                ),
                Container(
                  margin: EdgeInsets.only(left: screenSize.width * 0.01),
                  width: screenSize.width,
                  child: Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Galano Grotesque',
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [0, 1, 2, 3, 4, 5]
                        .map(
                          (_) => Container(
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: screenSize.width * 0.7,
                                      height: screenSize.height * 0.25,
                                      child: Image.asset(Images.placeholder),
                                    ),
                                    SizedBox(
                                      height: screenSize.width * 0.02,
                                    ),
                                    Container(
                                      width: screenSize.width * 0.7,
                                      margin: EdgeInsets.only(left: 8),
                                      child: Text(
                                        'productTitle',
                                        style: TextStyle(
                                          fontFamily: 'Galano Grotesque',
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenSize.width * 0.7,
                                      margin: EdgeInsets.only(left: 8),
                                      child: Text(
                                        'productSlug',
                                        style: TextStyle(
                                          fontFamily: 'Muli',
                                          fontSize: 12,
                                          color: AppTheme.gryTextColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenSize.width * 0.7,
                                      child: Row(
                                        //mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 12),
                                            child: Text(
                                              '₹200',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      AppTheme.redButtonColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 25),
                                            padding: EdgeInsets.all(9.0),
                                            decoration: BoxDecoration(
                                              color: AppTheme.redButtonColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'ADD TO CART',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'Galano Grotesque'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenSize.width * 0.05,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.25,
                  height: screenSize.height * 0.022,
                ),
                Container(
                  margin: EdgeInsets.only(left: screenSize.width * 0.01),
                  width: screenSize.width,
                  child: Text(
                    'Hot Products',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Galano Grotesque',
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [0, 1, 2, 3, 4, 5]
                        .map(
                          (_) => Container(
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: screenSize.width * 0.7,
                                      height: screenSize.height * 0.25,
                                      child: Image.asset(Images.placeholder),
                                    ),
                                    SizedBox(
                                      height: screenSize.width * 0.02,
                                    ),
                                    Container(
                                      width: screenSize.width * 0.7,
                                      margin: EdgeInsets.only(left: 8),
                                      child: Text(
                                        'productTitle',
                                        style: TextStyle(
                                          fontFamily: 'Galano Grotesque',
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenSize.width * 0.7,
                                      margin: EdgeInsets.only(left: 8),
                                      child: Text(
                                        'productSlug',
                                        style: TextStyle(
                                          fontFamily: 'Muli',
                                          fontSize: 12,
                                          color: AppTheme.gryTextColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenSize.width * 0.7,
                                      child: Row(
                                        //mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 12),
                                            child: Text(
                                              '₹200',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      AppTheme.redButtonColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 25),
                                            padding: EdgeInsets.all(9.0),
                                            decoration: BoxDecoration(
                                              color: AppTheme.redButtonColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'ADD TO CART',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'Galano Grotesque'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenSize.width * 0.05,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
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
