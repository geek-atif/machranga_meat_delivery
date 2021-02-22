import 'dart:convert';
import '../widgets/my_button.dart';
import '../models/order_place_model.dart';
import '../models/checkout_item.dart';
import '../util/constant.dart';
import '../util/images.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    Map responseData = ModalRoute.of(context).settings.arguments;
    List<CheckOutItem> checkOutItems = List<CheckOutItem>();
    OrderPlaceModel orderPlaceModel;
    responseData.forEach((key, value) {
      if (key == 'orderPlaceModel') {
        orderPlaceModel = value;
      }

      if (key == 'checkOutItems') {
        checkOutItems = value;
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: AppTheme.redButtonColor,
              height: screenSize.height * 0.32,
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height * 0.05,
                  ),
                  Image.asset(Images.success, height: 76, width: 76),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  Text(
                    'Ordered Successfull',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Galano Grotesque'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          Constant.BOTTOM_NAVIGATION_NAME);
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 100, left: 100),
                      child: MyButton(
                        buttonText: 'GO To HOME',
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 15,
                top: 8,
              ),
              child: Text(
                'ORDER STATUS',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Galano Grotesque'),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                  left: 8,
                  top: 5,
                  right: 8,
                ),
                child: Image.asset(Images.placedOrder)),
            Container(
              margin: EdgeInsets.only(
                left: 12,
                top: 8,
              ),
              child: Text(
                'ORDER DETAILS',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Galano Grotesque'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 8,
              ),
              height: screenSize.height * 0.3,
              child: ListView.builder(
                itemCount: checkOutItems.length,
                itemBuilder: (BuildContext context, int index) => CartRow(
                  screenSize: screenSize,
                  checkOutItem: checkOutItems[index],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 12,
                top: 6,
              ),
              child: Text(
                'DELIVERING HERE',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Galano Grotesque'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    orderPlaceModel.address,
                    style: TextStyle(fontFamily: 'Muli', fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartRow extends StatelessWidget {
  final Size screenSize;
  final CheckOutItem checkOutItem;
  CartRow({this.screenSize, this.checkOutItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                checkOutItem.imageURL,
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
                      checkOutItem.title,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Galano Grotesque'),
                    ),
                  ),
                  Container(
                    width: screenSize.width * 0.45,
                    child: Text(
                      checkOutItem.subTitle,
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
                    width: screenSize.width * 0.45,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Qty: ‎${checkOutItem.productQuantity}',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.gryTextColor,
                              fontFamily: 'Muli'),
                        ),
                        Text(
                          '₹‎${checkOutItem.productPrice}',
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
            margin: EdgeInsets.only(
              right: 20,
            ),
            child: Divider(
              color: AppTheme.gryButtonColor,
            ),
          ),
        ],
      ),
    );
  }
}
