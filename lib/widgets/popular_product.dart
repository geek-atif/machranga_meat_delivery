import 'package:Machranga/models/cart_quantity_model.dart';

import '../models/product_model.dart';
import 'package:flutter/material.dart';
import 'horizontal_row_product.dart';

class PopularProduct extends StatelessWidget {
  List<ProductModel> productModel;
  List<CartQuantityModel> cartQuantityModels;

  PopularProduct({
    @required this.productModel,
    @required this.cartQuantityModels,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: screenSize.width * 0.028),
      height: screenSize.height * 0.4,
      width: screenSize.width,
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: productModel.length,
          itemBuilder: (BuildContext context, int index) {
            if (productModel[index].todayDeal == 1) {
              return HorizontalRowProduct(
                screenSize: screenSize,
                productModel: productModel[index],
                cartQuantityModel: cartQuantityModels.firstWhere(
                    (element) =>
                        element.productId == productModel[index].productId,
                    orElse: () => null),
              );
            } else {
              return Text('');
            }
          }),
    );
  }
}
