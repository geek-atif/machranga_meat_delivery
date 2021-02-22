import '../models/home_page_model.dart';
import 'package:flutter/material.dart';
import 'feature_product.dart';
import 'my_carousel_slider.dart';
import 'popular_product.dart';
import 'product_category.dart';

class HomeWidgets extends StatelessWidget {
  const HomeWidgets({
    Key key,
    @required this.screenSize,
    @required HomePageModel homePageModel,
  })  : _homePageModel = homePageModel,
        super(key: key);

  final Size screenSize;
  final HomePageModel _homePageModel;

  @override
  Widget build(BuildContext context) {
    return 
    _homePageModel.errorStatus==null?Text(''):
    Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          child: MyCarouselSlider(
            bannerModel: _homePageModel.bannerModel,
            productModel: _homePageModel.productModel,
            cartQuantityModel: _homePageModel.cartQuantityModel,
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.03,
        ),
        ProductCategory(
          categoryModel: _homePageModel.categoryModel,
          productModel: _homePageModel.productModel,
          cartQuantityModel: _homePageModel.cartQuantityModel,
        ),
        Container(
          margin: EdgeInsets.only(left: screenSize.width * 0.040),
          width: screenSize.width,
          child: Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'Galano Grotesque',
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          child: FeatureProduct(
            productModel: _homePageModel.productModel,
            cartQuantityModels: _homePageModel.cartQuantityModel,
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        Container(
          margin: EdgeInsets.only(left: screenSize.width * 0.040),
          width: screenSize.width,
          child: Text(
            'Hot Deals',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'Galano Grotesque',
            ),
            textAlign: TextAlign.start,
          ),
        ),
        PopularProduct(
          productModel: _homePageModel.productModel,
          cartQuantityModels: _homePageModel.cartQuantityModel,
        ),
        SizedBox(
          height: screenSize.height * 0.01,
        ),
      ],
    );
  }
}
