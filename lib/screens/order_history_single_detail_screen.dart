import '../models/order_history_model.dart';
import '../util/images.dart';
import '../util/styling.dart';
import '../widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class OrderHistorySingleDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orderHistory =
        ModalRoute.of(context).settings.arguments as OrderHistory;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        title: 'ORDER DETAILS',
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Order ID: ${orderHistory.order_unique_id}',
                  style: TextStyle(
                      fontFamily: 'Muli',
                      fontSize: 14,
                      color: AppTheme.gryTextColor),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              Container(
                child: Column(
                  children: [
                    ...orderHistory.orderItem
                        .map(
                          (orderItem) => CartRow(
                            screenSize: screenSize,
                            orderItem: orderItem,
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.017,
              ),
              Container(
                child: Text(
                  'DELIVERING HERE',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Galano Grotesque'),
                ),
              ),
              Container(
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      orderHistory.order_address,
                      style: TextStyle(fontFamily: 'Muli', fontSize: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.017,
              ),
              Container(
                child: Text(
                  'ORDER STATUS',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Galano Grotesque'),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              if (orderHistory.order_status == 1)
                Container(
                  child: Image.asset(Images.placedOrder),
                ),
              if (orderHistory.order_status == 2)
                Container(
                  child: Image.asset(Images.confirmedOrder),
                ),
              if (orderHistory.order_status == 3)
                Container(
                  child: Image.asset(Images.delivedOrderForDelivery),
                ),
              if (orderHistory.order_status == 4)
                Container(
                  child: Image.asset(Images.delivedOrder),
                ),
              SizedBox(
                height: screenSize.height * 0.017,
              ),
              Container(
                child: Text(
                  'BILLING DETAILS',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Galano Grotesque'),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Price(${orderHistory.orderItem.length} items):',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.05,
                  ),
                  Container(
                    child: Text(
                      '‎₹‎${orderHistory.total_amt}',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      '‎₹‎${35}',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Total:',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.05,
                  ),
                  Container(
                    child: Text(
                      '‎₹‎${orderHistory.total_amt}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartRow extends StatelessWidget {
  final Size screenSize;
  final OrderItem orderItem;
  CartRow({this.screenSize, this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                orderItem.image_url,
                fit: BoxFit.cover,
                width: screenSize.width * 0.4,
              ),
              SizedBox(
                width: screenSize.width * 0.02,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: screenSize.width * 0.53,
                    child: Text(
                      'title',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Galano Grotesque'),
                    ),
                  ),
                  Container(
                    width: screenSize.width * 0.45,
                    child: Text(
                      orderItem.product_slug,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.gryTextColor,
                          fontFamily: 'Muli'),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.032,
                  ),
                  Container(
                    width: screenSize.width * 0.5,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Qty: ‎${orderItem.product_qty}',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.gryTextColor,
                              fontFamily: 'Muli'),
                        ),
                        Text(
                          '₹‎${orderItem.selling_price}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.redButtonColor,
                              fontFamily: 'Muli'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            child: Divider(
              color: AppTheme.gryButtonColor,
            ),
          ),
        ],
      ),
    );
  }
}
