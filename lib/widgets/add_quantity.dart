import 'package:Machranga/util/my_singleton.dart';

import '../models/cart_quantity_model.dart';
import '../util/util_function.dart';
import '../models/product_model.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class AddQuantity extends StatefulWidget {
  ProductModel productModel;
  CartQuantityModel cartQuantityModel;
  AddQuantity({
    @required this.productModel,
    @required this.cartQuantityModel,
  });

  @override
  _AddQuantityState createState() => _AddQuantityState(
        productModel: productModel,
        cartQuantityModel: cartQuantityModel,
      );
}

class _AddQuantityState extends State<AddQuantity>
    with AutomaticKeepAliveClientMixin {
  int _currentQuantity = 1;
  ProductModel productModel;
  CartQuantityModel cartQuantityModel;
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  _AddQuantityState({
    @required this.productModel,
    @required this.cartQuantityModel,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('AddQuantity didChangeDependencies called');
    if (cartQuantityModel != null) {
      if (productModel.productId == cartQuantityModel.productId) {
        _currentQuantity = cartQuantityModel.productQty;
      }
    }
  }

  static int fromJson(json) {
    return json['productQuantity'];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(233, 233, 233, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.remove,
              color: AppTheme.redButtonColor,
            ),
          ),
          onTap: () {
            if (_currentQuantity > 0) {
              MySingleton.shared.utilFunction
                  .subProductToCart(
                      _currentQuantity, productModel, context, keyLoader)
                  .then((value) {
                setState(() {
                  _currentQuantity -= value;
                });
              });
            }
          },
        ),
        SizedBox(width: 12),
        Text(
          "$_currentQuantity",
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(width: 12),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(233, 233, 233, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.add,
              color: AppTheme.redButtonColor,
            ),
          ),
          onTap: () {
            MySingleton.shared.utilFunction
                .addProductToCart(
                    _currentQuantity, productModel, context, keyLoader)
                .then((value) {
              setState(() {
                _currentQuantity += value;
              });
            });
          },
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
