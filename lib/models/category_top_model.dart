import 'package:Machranga/models/cart_quantity_model.dart';

import '../models/product_model.dart';

class CategoryProductModel {
  List<ProductModel> productModel;
  List<CategoryTopModel> categoryTopModel;
  List<CartQuantityModel> cartQuantityModels;
}

class CategoryTopModel {
  int categoryId;
  String categoryName;
  String categorySlug;
  String productFeatures;
  String imageURL;
  int setOnHome;
  BigInt createdAt;
  int selected;
}
