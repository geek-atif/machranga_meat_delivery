import '../models/cart_quantity_model.dart';
import '../models/product_model.dart';
import '../widgets/product_card_ver.dart';
import 'package:flutter/material.dart';

class VerticalColumnProduct extends StatelessWidget {
  List<ProductModel> productModels;
  List<CartQuantityModel> cartQuantityModels;
  VerticalColumnProduct({
    @required this.productModels,
    @required this.cartQuantityModels,
  });
  int id = 1;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (BuildContext context, int index) => Container(
          child: ProductCardVer(
            screenSize: screenSize,
            productModels: productModels[index],
            cartQuantityModel: cartQuantityModels.firstWhere(
                (element) =>
                    element.productId == productModels[index].productId,
                orElse: () => null),
          ),
        ),
      ),
    );
  }
}
