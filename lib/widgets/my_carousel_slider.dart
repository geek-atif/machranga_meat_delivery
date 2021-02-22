import 'package:Machranga/models/cart_quantity_model.dart';
import 'package:Machranga/util/images.dart';

import '../models/category_top_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/banner_model.dart';
import '../models/product_model.dart';
import 'package:flutter/material.dart';
import '../util/constant.dart';
/*
class MyCarouselSlider extends StatelessWidget {
  List<BannerModel> bannerModel;
  List<ProductModel> productModel;
  MyCarouselSlider({this.bannerModel, this.productModel});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    void openBannerDetailScreen(BannerModel bannerModel) {
      print('openBannerDetailScreen productIds:  ${bannerModel.productIds}');
      if (bannerModel.productIds == null || bannerModel.productIds.isEmpty)
        return;

      List<List<ProductModel>> productModelNextData =
          List<List<ProductModel>>();
      List<String> productIds = bannerModel.productIds.split(",");
      productIds.forEach((productIds) {
        ProductModel pd = ProductModel();
        productModelNextData.add(productModel
            .where(
                (element) => element.productId.toString().contains(productIds))
            .toList());
      });

      Map bannerDetails = {
        "bannerTitle": bannerModel.bannerTitle,
        "productDetails": productModelNextData,
      };

      Navigator.of(context).pushNamed(Constant.BANNER_DETAILS_ROUTE_NAME,
          arguments: bannerDetails);
    }

    return Container(
      margin: EdgeInsets.only(left: screenSize.width * 0.010),
      height: screenSize.height * 0.25,
      width: screenSize.width * 0.94,
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: bannerModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  openBannerDetailScreen(bannerModel[index]);
                },
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Image.network(
                        bannerModel[index].imageUrl,
                        fit: BoxFit.cover,
                        width: screenSize.width * 0.93,
                        height: screenSize.height * 0.25,
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
*/

class MyCarouselSlider extends StatelessWidget {
  List<BannerModel> bannerModel;
  List<ProductModel> productModel;
  List<CartQuantityModel> cartQuantityModel;
  MyCarouselSlider({
    @required this.bannerModel,
    @required this.productModel,
    @required this.cartQuantityModel,
  });

  CarouselSlider carouselSlider;
  int _current = 0;

  List imgList = [];

  List<T> mapM<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  void openBannerDetailScreen(
      List<BannerModel> bannerModels, BuildContext context, String imageURl) {
    BannerModel bannerModel;
    int flag = 0;
    bannerModels.forEach((element) {
      if (imageURl == element.imageUrl) {
        bannerModel = element;
        flag = 1;
      }
    });

    if (flag == 0) {
      return;
    }

    if (bannerModel.productIds == null || bannerModel.productIds.isEmpty)
      return;
    /*
    List<List<ProductModel>> productModelNextData = List<List<ProductModel>>();
    List<String> productIds = bannerModel.productIds.split(",");
    productIds.forEach((productIds) {
      ProductModel pd = ProductModel();
      productModelNextData.add(productModel
          .where((element) => element.productId.toString().contains(productIds))
          .toList());
    });

    Map bannerDetails = {
      "bannerTitle": bannerModel.bannerTitle,
      "productDetails": productModelNextData,
      "cartQuantityModel": cartQuantityModel,
    };
     */

    Navigator.of(context)
        .pushNamed(Constant.BANNER_DETAILS_ROUTE_NAME, arguments: bannerModel);
  }

  items(BuildContext context, Size screenSize) {
    bannerModel.forEach((element) {
      imgList.add(element.imageUrl);
    });

    return imgList.map((imgUrl) {
      return Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              openBannerDetailScreen(bannerModel, context, imgUrl);
            },
            child: Container(
              width: screenSize.width,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      image: imgUrl,
                      fit: BoxFit.fill,
                      width: screenSize.width * 0.8,
                      height: screenSize.height * 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.25,
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: items(context, screenSize),
            options: CarouselOptions(
              disableCenter: true,
              height: screenSize.height * 0.25,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: true,
              //reverse: true,
              autoPlayInterval: Duration(seconds: 3),
              //autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              //onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
