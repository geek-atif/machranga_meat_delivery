import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_list_model.dart';
import '../response/product_list_response.dart';
import '../models/home_page_model.dart';
import '../response/home_response.dart';
import '../api_base_helper/api_base_helper.dart';
import '../models/coupon_detail_model.dart';
import '../response/coupon_response.dart';

class HomeRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  final storage = FlutterSecureStorage();
  
  Future<HomePageModel> getHomePageData(String userId) async {
    final response = await _helper.get("/gethomeData?userId=${userId}");
    HomePageModel homeModel = HomeResponse.gethomeData(response).homePageModel;
    return homeModel;
  }

  Future<CouponDetailModel> getCoupon() async {
    final response = await _helper.get("/getCouponDetail");
    CouponDetailModel couponDetailModel =
        CouponCodeResponse.fromJson(response).couponDetailModel;
    return couponDetailModel;
  }

  Future<ProductListModel> getProductDetails(String userId) async {
    final response = await _helper.get("/getProductList?userId=${userId}");
    ProductListModel productListModel =
        ProductListResponse.fromJson(response).productListModel;
    return productListModel;
  }

  Future<ProductListModel> getBannerProduct(
      String userId, String bannerId) async {
    final response = await _helper
        .get("/getBannerProduct?userId=${userId}&bannerId=${bannerId}");
    ProductListModel productListModel =
        ProductListResponse.fromJson(response).productListModel;
    return productListModel;
  }

  Future<ProductListModel> getSearchProduct(
      String userId, String searchWord) async {
    final response = await _helper
        .get("/serachProduct?serachKeyWord=${searchWord}&userId=${userId}");
    ProductListModel productListModel =
        ProductListResponse.fromJson(response).productListModel;
    return productListModel;
  }

  Future<ProductListModel> getProductById(String productID, String userId) async {
    final response =
        await _helper.get("/getProductListById?productId=${productID}&userId=${userId}");
    ProductListModel productModel =
        ProductListResponse.fromJson(response).productListModel;
    return productModel;
  }
  
}
