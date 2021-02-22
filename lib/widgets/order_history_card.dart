import 'package:Machranga/util/images.dart';

import '../models/order_history_model.dart';
import '../util/constant.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class OrderHistoryCard extends StatelessWidget {
  Size screenSize;
  OrderHistory orderHistory;
  OrderHistoryCard({this.screenSize, this.orderHistory});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Constant.ORDER_HISTORY_SINGLE_SCREEN,
            arguments: orderHistory);
      },
      child: Container(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Order ID: ${orderHistory.order_unique_id}',
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 12,
                          color: AppTheme.gryTextColor),
                    ),
                    Container(
                      //margin: EdgeInsets.only(right: 100),
                      child: Text(
                        '${orderHistory.order_date}',
                        style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 12,
                            color: AppTheme.gryTextColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    //Text('${orderHistory.orderItem.length}'),
                    if (orderHistory.orderItem.length >= 1)
                      FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: orderHistory.orderItem[0].image_url,
                        width: 53,
                        height: 52,
                      ),
                    SizedBox(
                      width: screenSize.width * 0.025,
                    ),
                    if (orderHistory.orderItem.length >= 2)
                      FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: orderHistory.orderItem[1].image_url,
                        width: 53,
                        height: 52,
                      ),
                    SizedBox(
                      width: screenSize.width * 0.025,
                    ),
                    if (orderHistory.orderItem.length >= 3)
                       FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image:orderHistory.orderItem[2].image_url,
                        width: 53,
                        height: 52,
                      ),
                  ],
                ),
                if (orderHistory.order_status == 1 ||
                    orderHistory.order_status == 2 ||
                    orderHistory.order_status == 3)
                  Text(
                    'Processing ',
                    style: TextStyle(
                        fontFamily: 'Muli',
                        fontSize: 12,
                        color: AppTheme.processingColor),
                  ),
                if (orderHistory.order_status == 4)
                  Text(
                    'Completed ',
                    style: TextStyle(
                        fontFamily: 'Muli', fontSize: 12, color: Colors.green),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
