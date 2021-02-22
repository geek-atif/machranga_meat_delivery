import 'dart:async';
import 'package:Machranga/models/product_list_model.dart';
import '../models/home_page_model.dart';
import '../repository/home_repository.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  HomeRepository _homeRepository;
  HomeProvider() {
    _homeRepository = new HomeRepository();
  }

  Future<HomePageModel> getHomeData(int userId) async {
    try{
    HomePageModel homePageModel =
        await _homeRepository.getHomePageData(userId.toString());
    notifyListeners();
    return homePageModel;
    } catch (ex) {
      print('Ex: $ex');
      HomePageModel productListModel = HomePageModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<ProductListModel> getProductDetails(int userId) async {
    try {
      ProductListModel productListModel =
          await _homeRepository.getProductDetails(userId.toString());
      return productListModel;
    } catch (ex) {
      print('Ex: $ex');
      ProductListModel productListModel = ProductListModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<ProductListModel> getBannerProduct(int userId, int bannerId) async {
    try {
      ProductListModel productListModel = await _homeRepository
          .getBannerProduct(userId.toString(), bannerId.toString());
      return productListModel;
    } catch (ex) {
      print('Ex: $ex');
      ProductListModel productListModel = ProductListModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }

  Future<ProductListModel> getSearchProduct(
      int userId, String searchWord) async {
    try {
      ProductListModel productListModel =
          await _homeRepository.getSearchProduct(userId.toString(), searchWord);
      //print('productListModel ${productListModel.productModels}');
      return productListModel;
    } catch (ex) {
      print('Ex: $ex');
      ProductListModel productListModel = ProductListModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }
}
