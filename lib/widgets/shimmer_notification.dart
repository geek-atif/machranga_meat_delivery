import '../util/images.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNotification extends StatelessWidget {
  Size screenSize;
  ShimmerNotification({this.screenSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          period: Duration(seconds: 2),
          child: SingleChildScrollView(
            child: Column(
              children: [0, 1, 2, 3, 4, 5, 6,7, 8 , 9 , 10,11,12,13,14]
                  .map(
                    (_) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Image.asset(Images.notificationList),
                            title: Text(
                              'Title',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Galano Grotesque',
                              ),
                            ),
                            subtitle: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Muli',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          baseColor: Colors.grey[350],
          highlightColor: Colors.grey[100]),
    );
  }
}
