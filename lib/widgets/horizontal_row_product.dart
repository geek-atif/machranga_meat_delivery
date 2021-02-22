import 'package:Machranga/models/cart_quantity_model.dart';

import '../models/product_model.dart';
import '../widgets/product_card_hoz.dart';
import 'package:flutter/material.dart';

class HorizontalRowProduct extends StatelessWidget {
  final Size screenSize;
  final ProductModel productModel;
  final CartQuantityModel cartQuantityModel;
  const HorizontalRowProduct({
    Key key,
    @required this.screenSize,
    @required this.productModel,
    @required this.cartQuantityModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //   boxShadow: [
            //     BoxShadow(
            //       offset: Offset(
            //         5.0, // Move to right 10  horizontally
            //         5.0, // Move to bottom 10 Vertically
            //       ),
            //       //spreadRadius: 20,
            //       color: AppTheme.boxShadow,
            //       blurRadius: 15.0,
            //     ),
            //   ],
            // ),

            child: ProductCardHoz(
              screenSize: screenSize,
              productModel: productModel,
              cartQuantityModel: cartQuantityModel,
            ),
          ),
          Container(
            width: screenSize.width * 0.015,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
