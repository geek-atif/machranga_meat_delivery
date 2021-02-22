import 'package:Machranga/models/order_history_model.dart';
import 'package:Machranga/util/styling.dart';
import 'package:flutter/material.dart';

import 'order_history_card.dart';

class OrderHistoryList extends StatelessWidget {
  Size screenSize;
  List<OrderHistory> orderHistory;
  OrderHistoryList({this.screenSize, this.orderHistory});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Text(
            'ORDER HISTORY',
            style: TextStyle(
                fontFamily: 'Galano Grotesque',
                color: Colors.black,
                fontSize: 18),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          height: screenSize.height * 0.78,
          child: ListView.builder(
            itemCount: orderHistory.length,
            itemBuilder: (BuildContext context, int index) => OrderHistoryCard(
              screenSize: screenSize,
              orderHistory: orderHistory[index],
            ),
          ),
        ),
        SizedBox(height: screenSize.height * 0.1,)
      ],
    );
  }
}
