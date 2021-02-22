import '../models/product_model.dart';
import 'cart_quantity_model.dart';

class ProductListModel {
  bool errorStatus;
  String message;
  List<ProductModel> productModels;
  List<CartQuantityModel> cartQuantityModel;
}
