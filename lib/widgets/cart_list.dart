import '../models/checkout_item.dart';
import '../widgets/cart_row.dart';
import 'package:flutter/material.dart';

class CartList extends StatelessWidget {
  Size screenSize;
  List<CheckOutItem> checkOutItem;
  CartList({this.screenSize, this.checkOutItem});

  @override
  Widget build(BuildContext context) {
    return checkOutItem.length == 0
        ? Text('')
        : ListView.builder(
            itemCount: checkOutItem.length,
            itemBuilder: (BuildContext context, int index) => CartRow(
              screenSize: screenSize,
              checkOutItem: checkOutItem[index],
            ),
          );
  }

  
}
