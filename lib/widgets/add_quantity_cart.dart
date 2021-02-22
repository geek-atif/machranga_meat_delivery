import 'package:Machranga/util/my_singleton.dart';
import '../models/checkout_item.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class AddQuantityCart extends StatefulWidget {
  Size screenSize;
  CheckOutItem checkOutItem;
  AddQuantityCart(this.screenSize, this.checkOutItem);

  @override
  _AddQuantityCartState createState() =>
      _AddQuantityCartState(screenSize, checkOutItem);
}

class _AddQuantityCartState extends State<AddQuantityCart>
    with AutomaticKeepAliveClientMixin {
  Size screenSize;
  CheckOutItem checkOutItem;
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  _AddQuantityCartState(this.screenSize, this.checkOutItem);
  int _currentQuantity = 0;

  @override
  void initState() {
    super.initState();
    print('initState() called');
    _currentQuantity = checkOutItem.productQuantity;
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
                  .subProductToCartForCartScreen(
                      _currentQuantity, checkOutItem, context, keyLoader)
                  .then((increment) {
                print('increment : ${increment}');
                setState(() {
                  _currentQuantity = _currentQuantity - increment;
                });
              });
            }
          },
        ),
        SizedBox(width: 12),
        Text(
          "${_currentQuantity}",
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
                .addProductToCartForCartScreen(
                    _currentQuantity, checkOutItem, context, keyLoader)
                .then((increment) {
              print('increment : ${increment}');
              setState(() {
                _currentQuantity = _currentQuantity + increment;
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
