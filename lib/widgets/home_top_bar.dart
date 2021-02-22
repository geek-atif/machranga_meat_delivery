import 'package:Machranga/util/styling.dart';
import 'package:flutter/material.dart';
import '../util/images.dart';

class HomeTopBar extends StatelessWidget {
  final Size screenSize;
  String pinCode;
  HomeTopBar(this.screenSize, this.pinCode);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Image.asset(
            Images.homeTopLogo,
            fit: BoxFit.fill,
            height: screenSize.height * 0.065,
            //width: 45,
          ),
        ),
        GestureDetector(
          onTap: () {}, //HomeScreen().},
          child: Container(
            margin: EdgeInsets.only(right: screenSize.width * 0.07),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Delivering at',
                    style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 12,
                      color: AppTheme.gryTextColor,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      Images.loc,
                      fit: BoxFit.fill,
                      height: screenSize.height * 0.022,
                    ),
                    SizedBox(
                      width: screenSize.width * 0.01,
                    ),
                    Text(
                      pinCode==null?'':pinCode,
                      style: TextStyle(
                        fontFamily: 'Galano Grotesque',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: screenSize.height * 0.013),
          child: Image.asset(
            Images.icIcon,
            fit: BoxFit.fill,
            height: screenSize.height * 0.03,
            //width: 45,
          ),
        ),
      ],
    );
  }
}
