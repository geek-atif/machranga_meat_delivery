import 'banner_model.dart';
import 'cart_quantity_model.dart';
import 'category_model.dart';
import 'product_model.dart';

class HomePageModel{
  bool errorStatus;
  String message;
  List<BannerModel> bannerModel;
  List<ProductModel> productModel;
  List<CategoryModel> categoryModel;
  List<CartQuantityModel> cartQuantityModel;
}