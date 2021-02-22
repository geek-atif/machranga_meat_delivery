import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  MyButton(
      {@required this.buttonText,
      @required this.buttonColor,
      @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
     // margin: EdgeInsets.only(right: 20, left: 20),
      padding: EdgeInsets.all(13.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
              color: textColor, fontSize: 16, fontFamily: 'Galano Grotesque'),
        ),
      ),
    );
  }
}
