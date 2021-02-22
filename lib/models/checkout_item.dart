import 'package:flutter/material.dart';
class CheckOutItem {
  int productId;
  String productPrice;
  String imageURL;
  String title;
  String subTitle;
  int productQuantity = 0;
  int productStock;

  CheckOutItem({
    @required this.productId,
    @required this.productPrice,
    @required this.imageURL,
    @required this.title,
    @required this.subTitle,
    @required this.productQuantity,
  });

  Map toJson() => {
        'productId': productId,
        'productPrice': productPrice,
        'imageURL': imageURL,
        'title': title,
        'subTitle': subTitle,
        'productQuantity': productQuantity
      };

  factory CheckOutItem.fromJson(jsonData) {
    return CheckOutItem(
      productId: jsonData['productId'],
      productPrice: jsonData['productPrice'],
      imageURL: jsonData['imageURL'],
      title: jsonData['title'],
      subTitle: jsonData['subTitle'],
      productQuantity: jsonData['productQuantity'],
    );
  }
}
