import 'package:Machranga/widgets/hero_widget.dart';

import '../util/constant.dart';
import '../util/my_singleton.dart';
import '../util/styling.dart';
import '../models/product_model.dart';
import '../util/util_function.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;
  final String heroTagNumber;
  ProductDetailScreen(
      {@required this.productModel, @required this.heroTagNumber});
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState(
      productModel: productModel, heroTagNumber: heroTagNumber);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductModel productModel;
  final String heroTagNumber;
  _ProductDetailScreenState({this.productModel, this.heroTagNumber});
  bool isAddToCartClicked = false;

  final GlobalKey<State> keyLoader = new GlobalKey<State>();

  HeroWidget _buildHeroWidget(BuildContext context, String imageUrl) {
    return HeroWidget(
      heroTag: heroTagNumber,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.softLight),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var productModel =
    //     ModalRoute.of(context).settings.arguments as ProductModel;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: displayScreen(context, productModel, screenSize),
    );
  }

  Widget displayScreen(
      BuildContext context, ProductModel productModel, Size screenSize) {
    return Stack(children: <Widget>[
      // Background with gradient
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeroWidget(context, productModel.imageURL),
          Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: Text(
              productModel.productTitle,
              style: TextStyle(fontFamily: 'Galano Grotesque', fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              productModel.productDesc,
              style: TextStyle(fontFamily: 'Muli', fontSize: 14),
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'Details',
              style: TextStyle(fontFamily: 'Galano Grotesque', fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              productModel.productDesc,
              style: TextStyle(fontFamily: 'Muli', fontSize: 14),
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'Delivery instructions',
              style: TextStyle(fontFamily: 'Galano Grotesque', fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              MySingleton.shared.deliveryInstruction,
              style: TextStyle(fontFamily: 'Muli', fontSize: 14),
            ),
          ),
        ],
      ),
      // Positioned to take only AppBar size
      Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: AppBar(
          leading: BackButton(color: Colors.white),
          // Add AppBar here only
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            productModel.productTitle,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),

      Positioned(
        bottom: 0.0,
        child: Column(
          children: <Widget>[
            Divider(
              height: 5,
              color: Colors.black,
            ),
            Container(
              color: Colors.white,
              height: 74,
              width: screenSize.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '₹${productModel.sellingPrice}',
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.redButtonColor),
                    ),
                  ),
                  isAddToCartClicked
                      ? proceedToCheckout(context)
                      : addToCartButton(productModel, context),
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  GestureDetector addToCartButton(
      ProductModel productModel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        MySingleton.shared.utilFunction
            .addProductToCartSingle(1, productModel, context, keyLoader);
        setState(() {
          isAddToCartClicked = true;
        });
      },
      child: productModel.productStock <= 0
          ? Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: AppTheme.gryButtonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  'OUT OF STOCK',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.gryTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: AppTheme.redButtonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  'ADD TO CART',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
    );
  }
}

GestureDetector proceedToCheckout(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context)
          .pushReplacementNamed(Constant.BOTTOM_NAVIGATION_NAME, arguments: 1);
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.redButtonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'Go To Cart',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  '₹‎${UtilFunction.getTotalAmountSum()}',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 40.0,
              ),
            ],
          )
        ],
      ),
    ),
  );
}

