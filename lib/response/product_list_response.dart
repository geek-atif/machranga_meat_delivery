import '../models/cart_quantity_model.dart';
import '../models/product_model.dart';
import '../models/product_list_model.dart';

class ProductListResponse {
  ProductListModel productListModel;
  List<CartQuantityModel> cartQuantityModels;
  ProductListResponse.fromJson(Map<String, dynamic> json) {
    productListModel = ProductListModel();
    productListModel.errorStatus = json['errorStatus'];
    productListModel.message = json['message'];
    if (json['data']['cartItem'] != '') {
      cartQuantityModels = new List<CartQuantityModel>();
      json['data']['cartItem'].forEach(
        (v) {
          cartQuantityModels.add(parseCartItemData(v));
        },
      );
      productListModel.cartQuantityModel = cartQuantityModels;
    }

    if (json['data']['product'] != '') {
      List<ProductModel> product = new List<ProductModel>();
      json['data']['product'].forEach(
        (v) {
          product.add(parseProductData(v, cartQuantityModels));
        },
      );
      productListModel.productModels = product;
    }
  }

  CartQuantityModel parseCartItemData(v) {
    CartQuantityModel cartQuantityModel = CartQuantityModel();
    cartQuantityModel.cartId = v['cartId'];
    cartQuantityModel.productId = v['productId'];
    cartQuantityModel.userId = v['userId'];
    cartQuantityModel.productQty = v['productQty'];
    return cartQuantityModel;
  }

  ProductModel parseProductData(v, List<CartQuantityModel> cartQuantityModels) {
    ProductModel productModel = new ProductModel();
    productModel.productId = v['id'];
    productModel.categoryId = v['category_id'];
    productModel.subCategoryId = v['sub_category_id'];
    productModel.productTitle = v['product_title'];
    productModel.productSlug = v['product_slug'];
    productModel.productDesc = v['product_desc'];
    productModel.imageURL = v['featured_image'];
    productModel.sellingPrice = v['selling_price'].toString();
    productModel.productStock = v['productQuantityStock'];
    productModel.todayDeal = v['today_deal'];
    //productModel.todayDealDate = v['today_deal_date'];
    productModel.is_featured = v['is_featured'];

    if (cartQuantityModels != null) {
      int itemFound = -1;
      itemFound = cartQuantityModels.indexWhere((cartQuantityModel) =>
          cartQuantityModel.productId == productModel.productId);

      productModel.isAdded = itemFound == -1 ? false : true;
    }
    return productModel;
  }
}
