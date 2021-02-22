import 'package:flutter/material.dart';
class NoData extends StatelessWidget {
  String image;
  String title;
  String subTitle;

  NoData({this.image, this.title, this.subTitle});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            image,
            height: 99,
            width: 152,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Galano Grotesque',
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Muli',
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
