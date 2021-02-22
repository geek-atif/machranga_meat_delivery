import '../util/util_function.dart';
import '../models/cart_quantity_model.dart';
import '../screens/product_detail_screen.dart';
import '../util/images.dart';
import '../util/my_singleton.dart';
import '../widgets/hero_widget.dart';
import '../widgets/add_quantity.dart';
import '../models/product_model.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class ProductCardHoz extends StatefulWidget {
  final Size screenSize;
  final ProductModel productModel;
  final CartQuantityModel cartQuantityModel;
  ProductCardHoz(
      {@required this.screenSize,
      @required this.productModel,
      @required this.cartQuantityModel});

  @override
  _ProductCardHozState createState() => _ProductCardHozState(
      screenSize: screenSize,
      productModel: productModel,
      cartQuantityModel: cartQuantityModel);
}

class _ProductCardHozState extends State<ProductCardHoz> {
  final Size screenSize;
  final ProductModel productModel;
  final CartQuantityModel cartQuantityModel;
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  _ProductCardHozState(
      {@required this.screenSize,
      @required this.productModel,
      @required this.cartQuantityModel});

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
              image: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Material(
              child: InkWell(
                splashColor: Colors.red.withOpacity(0.5),
                highlightColor: Colors.red.withOpacity(0.5),
                onTap: () {
                  Navigator.of(context).push(
                    UtilFunction.createProductDetailsRoute(
                      ProductDetailScreen(
                        productModel: productModel,
                        heroTagNumber: heroTagNumber,
                      ),
                    ),
                  );
                },
                child: _buildHeroWidget(productModel.imageURL, heroTagNumber),
              ),
            ),
          ),
          SizedBox(
            height: screenSize.width * 0.02,
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 0,
            child: Container(
              width: screenSize.width * 0.7,
              margin: EdgeInsets.only(left: 8),
              child: Text(
                productModel.productTitle,
                style: TextStyle(
                  fontFamily: 'Galano Grotesque',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 0,
            child: Container(
              width: screenSize.width * 0.7,
              margin: EdgeInsets.only(left: 8),
              child: Text(
                productModel.productSlug,
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 12,
                  color: AppTheme.gryTextColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenSize.width * 0.01,
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 0,
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    child: Text(
                      '₹${productModel.sellingPrice}',
                      style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.redButtonColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  productModel.productStock <= 0
                      ? Container(
                          margin: EdgeInsets.only(left: 4),
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
                      : productModel.isAdded
                          ? AddQuantity(
                              productModel: productModel,
                              cartQuantityModel: cartQuantityModel,
                            )
                          : GestureDetector(
                              onTap: () {
                                MySingleton.shared.utilFunction
                                    .addProductToCartSingle(
                                        1, productModel, context, keyLoader)
                                    .then((value) {
                                  if (value == 1) {
                                    setState(() {
                                      productModel.isAdded = true;
                                    });
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 4),
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
                ],
              ),
              width: screenSize.width * 0.75,
            ),
          ),
          SizedBox(
            height: screenSize.width * 0.05,
          ),
        ],
      ),
    );
  }
}
