import 'package:Machranga/models/cart_quantity_model.dart';

import '../models/checkout_item.dart';
import '../models/cart_model.dart';

class CartModelResponse {
  CartModel cartModel;
  CartModelResponse.fromJson(Map<String, dynamic> json) {
    cartModel = CartModel();
    cartModel.errorStatus = json['errorStatus'];
    cartModel.message = json['message'];

    if (json['data']['cartItem'] != '' && json['data']['cartData'] != '') {
      List<CheckOutItem> checkOutItems = List<CheckOutItem>();
      List<CartQuantityModel> cartQuantityModels = List<CartQuantityModel>();
      json['data']['cartData'].forEach(
        (v) {
          cartQuantityModels.add(parseCartQuantity(v));
        },
      );

      json['data']['cartItem'].forEach(
        (v) {
          checkOutItems.add(parseCartItem(v, cartQuantityModels));
        },
      );
      cartModel.checkOutItem = checkOutItems;
    }
  }

  CartQuantityModel parseCartQuantity(v) {
    CartQuantityModel cartQuantityModel = CartQuantityModel();
    cartQuantityModel.cartId = v['cartId'];
    cartQuantityModel.productId = v['productId'];
    cartQuantityModel.userId = v['userId'];
    cartQuantityModel.productQty = v['productQty'];
   
    return cartQuantityModel;
  }

  CheckOutItem parseCartItem(v, List<CartQuantityModel> cartQuantityModels) {
  CheckOutItem checkOutItem = CheckOutItem();
    checkOutItem.productId = v['product_id'];
    checkOutItem.productPrice = v['selling_price'].toString();
    checkOutItem.imageURL = v['image_url'];
    checkOutItem.title = v['product_title'];
    checkOutItem.subTitle = v['product_slug'];
    checkOutItem.productQuantity = cartQuantityModels.firstWhere((element) => element.productId==checkOutItem.productId).productQty;
    checkOutItem.productStock = v['productQuantityStock'];
    return checkOutItem;
  }

   CartModelResponse.fromJsonForCat(Map<String, dynamic> json) {
    cartModel = CartModel();
    cartModel.errorStatus = json['errorStatus'];
    cartModel.message = json['message'];
   }

}

