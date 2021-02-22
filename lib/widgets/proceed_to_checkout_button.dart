
import '../util/styling.dart';
import 'package:flutter/material.dart';

class ProceedToCheckOutButtion extends StatelessWidget {
  double totalAmount;
  String buttonContent;
  ProceedToCheckOutButtion({@required this.totalAmount , @required this.buttonContent});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30),
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: AppTheme.redButtonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              buttonContent,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  '₹‎${totalAmount}',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 40.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
