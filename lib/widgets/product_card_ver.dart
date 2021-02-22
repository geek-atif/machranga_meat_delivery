import 'package:Machranga/screens/product_detail_screen.dart';
import 'package:Machranga/util/images.dart';
import 'package:Machranga/util/util_function.dart';

import '../util/my_singleton.dart';
import '../models/cart_quantity_model.dart';
import '../util/constant.dart';
import '../widgets/add_quantity.dart';
import '../models/product_model.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

import 'hero_widget.dart';

class ProductCardVer extends StatefulWidget {
  final Size screenSize;
  ProductModel productModels;
  CartQuantityModel cartQuantityModel;
  ProductCardVer({
    @required this.screenSize,
    @required this.productModels,
    @required this.cartQuantityModel,
  });

  @override
  _ProductCardVerState createState() => _ProductCardVerState(
      screenSize: screenSize,
      productModels: productModels,
      cartQuantityModel: cartQuantityModel);
}

class _ProductCardVerState extends State<ProductCardVer> {
  final Size screenSize;
  ProductModel productModels;
  CartQuantityModel cartQuantityModel;
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  _ProductCardVerState({
    @required this.screenSize,
    @required this.productModels,
    @required this.cartQuantityModel,
  });

  var heroTagNumber = UtilFunction().getRandomNumber().toString();

  HeroWidget _buildHeroWidget(String imageUrl, String heroTagNumber) {
    return HeroWidget(
      heroTag: heroTagNumber,
      builder: (BuildContext context) {
        return Container(
          width: screenSize.width * 0.8,
          //height:screenSize.height * 0.4 ,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder,
              image: productModels.imageURL,
              fit: BoxFit.cover,
              //height: screenSize.height * 0.35,
              //width: screenSize.width * 0.8,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('${productModels.productId} : ${productModels.isAdded}');
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: screenSize.height * 0.48,
      width: screenSize.width * 0.8,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    UtilFunction.createProductDetailsRoute(
                      ProductDetailScreen(
                        productModel: productModels,
                        heroTagNumber: heroTagNumber,
                      ),
                    ),
                  );
                },
                child: _buildHeroWidget(productModels.imageURL, heroTagNumber),
              ),
            ),
            SizedBox(
              height: screenSize.width * 0.04,
            ),
            Flexible(
              flex: 0,
              child: Container(
                width: screenSize.width * 0.7,
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  productModels.productTitle,
                  style: TextStyle(
                    fontFamily: 'Galano Grotesque',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: Container(
                width: screenSize.width * 0.7,
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  productModels.productSlug,
                  style: TextStyle(
                    fontFamily: 'Muli',
                    fontSize: 12,
                    color: AppTheme.gryTextColor,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 0,
              fit: FlexFit.loose,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 12),
                      child: Text(
                        '₹${productModels.sellingPrice}',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.redButtonColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    productModels.productStock <= 0
                        ? Container(
                            margin: EdgeInsets.only(right: 7),
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
                        : productModels.isAdded
                            ? Container(
                                margin: EdgeInsets.only(right: 10),
                                child: AddQuantity(
                                  cartQuantityModel: cartQuantityModel,
                                  productModel: productModels,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  MySingleton.shared.utilFunction
                                      .addProductToCartSingle(
                                          1, productModels, context, keyLoader)
                                      .then((value) {
                                    if (value == 1) {
                                      setState(() {
                                        productModels.isAdded = true;
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 12),
                                  padding: EdgeInsets.all(9.0),
                                  decoration: BoxDecoration(
                                    color: AppTheme.redButtonColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ADD TO CART',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Galano Grotesque'),
                                    ),
                                  ),
                                ),
                              ),

                    // Container(
                    //     height: screenSize.height * 0.045,
                    //     margin: EdgeInsets.only(right: 10),
                    //     child: RaisedButton(
                    //       elevation: 1,
                    //       color: AppTheme.redButtonColor,
                    //       onPressed: () {
                    //  UtilFunction.addProductToCart(1, productModels, context);
                    // setState(() {
                    //   productModels.isAdded = true;
                    // });
                    //       },
                    //       child: Text(
                    //         'ADD TO CART',
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
                //width: screenSize.width * 0.75,
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            )
          ],
        ),
      ),
    );
  }
}
