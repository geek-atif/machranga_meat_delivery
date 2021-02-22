import 'package:Machranga/util/images.dart';

import '../util/constant.dart';
import '../util/my_singleton.dart';
import '../widgets/my_dialogs.dart';
import '../models/checkout_item.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';
import 'add_quantity_cart.dart';

class CartRow extends StatefulWidget {
  final Size screenSize;
  final CheckOutItem checkOutItem;
  CartRow({this.screenSize, this.checkOutItem});

  @override
  _CartRowState createState() => _CartRowState();
}

class _CartRowState extends State<CartRow> {
  final GlobalKey<State> keyLoader = new GlobalKey<State>();

  removeItemFromCart(BuildContext context, CheckOutItem checkOutItem) {
    Dialogs.showLoadingDialog(context, keyLoader);
    MySingleton.shared.utilFunction
        .removeItemFromCart(
            MySingleton.shared.userId,
            checkOutItem.productId.toString(),
            '1',
            MySingleton.shared.orderPlaceRepository , context)
        .then((cartModel) {
      Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
      if (cartModel.errorStatus) {
        MySingleton.shared.utilFunction..showToast(cartModel.message);
      } else {
        print('eles');
        //(context as Element).reassemble();
        Navigator.of(context).pushReplacementNamed(
            Constant.BOTTOM_NAVIGATION_NAME,
            arguments: 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                image: widget.checkOutItem.imageURL,
                fit: BoxFit.cover,
                width: widget.screenSize.width * 0.4,
              ),
              // Image.network(
              //   widget.checkOutItem.imageURL,
              //   fit: BoxFit.cover,
              //   width: widget.screenSize.width * 0.4,
              // ),
              SizedBox(
                width: widget.screenSize.width * 0.02,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.checkOutItem.productStock == 0)
                    GestureDetector(
                      onTap: () {
                        removeItemFromCart(context, widget.checkOutItem);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 2.0),
                        alignment: Alignment.topRight,
                        width: widget.screenSize.width * 0.53,
                        child: Icon(
                          Icons.close,
                          color: AppTheme.redButtonColor,
                          size: 24.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                    ),
                  Container(
                    width: widget.screenSize.width * 0.53,
                    child: Text(
                      widget.checkOutItem.title,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Galano Grotesque'),
                    ),
                  ),
                  Container(
                    width: widget.screenSize.width * 0.45,
                    child: Text(
                      widget.checkOutItem.subTitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.gryTextColor,
                          fontFamily: 'Muli'),
                    ),
                  ),
                  SizedBox(
                    height: widget.screenSize.height * 0.032,
                  ),
                  Container(
                    width: widget.screenSize.width * 0.47,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '₹‎${widget.checkOutItem.productPrice}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppTheme.redButtonColor,
                              fontFamily: 'Muli'),
                        ),
                        // SizedBox(width: screenSize.width*0.09,),
                        widget.checkOutItem.productStock == 0
                            ? Container(
                                //margin: EdgeInsets.only(right: 3),
                                padding: EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                  color: AppTheme.gryButtonColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'OUT OF STOCK',
                                    style: TextStyle(
                                        color: AppTheme.gryTextColor,
                                        fontSize: 12,
                                        fontFamily: 'Galano Grotesque'),
                                  ),
                                ),
                              )
                            : AddQuantityCart(
                                widget.screenSize, widget.checkOutItem),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(
            color: AppTheme.gryButtonColor,
          ),
        ],
      ),
    );
  }
}
