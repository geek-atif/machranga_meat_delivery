import '../models/cart_quantity_model.dart';
import '../models/category_model.dart';
import '../models/home_page_model.dart';
import '../models/product_model.dart';
import '../util/my_singleton.dart';
import '../models/banner_model.dart';

class HomeResponse {
  HomePageModel homePageModel;

  HomeResponse.gethomeData(Map<String, dynamic> json) {
    homePageModel = new HomePageModel();
    homePageModel.errorStatus = json['errorStatus'];
    homePageModel.message = json['message'];

    if (json['data']['cartItem'] != '') {
      List<CartQuantityModel> cartQuantityModels =
          new List<CartQuantityModel>();
      json['data']['cartItem'].forEach(
        (v) {
          cartQuantityModels.add(parseCartItemData(v));
        },
      );
      homePageModel.cartQuantityModel = cartQuantityModels;
    }

    if (json['data']['banner'] != '') {
      List<BannerModel> banner = new List<BannerModel>();
      json['data']['banner'].forEach(
        (v) {
          banner.add(parseBannerData(v));
        },
      );
      homePageModel.bannerModel = banner;
    }

    if (json['data']['product'] != '') {
      List<ProductModel> product = new List<ProductModel>();
      json['data']['product'].forEach(
        (v) {
          product.add(parseProductData(v, homePageModel.cartQuantityModel));
        },
      );
      homePageModel.productModel = product;
    }

    if (json['data']['category'] != '') {
      List<CategoryModel> category = new List<CategoryModel>();
      json['data']['category'].forEach(
        (v) {
          category.add(parseCategoryData(v));
        },
      );
      homePageModel.categoryModel = category;
    }

    if (json['data']['settingData'] != '') {
      json['data']['settingData'].forEach(
        (v) {
          MySingleton.shared.deliveryCharge = v['delivery_charge'];
          MySingleton.shared.deliveryInstruction = v['delivery_instruction'];
          MySingleton.shared.codModelEnable = v['cod_status'];
          MySingleton.shared.razorpayEnable = v['razorpay_status'];
        },
      );
    }
  }

  BannerModel parseBannerData(v) {
    BannerModel bannerData = new BannerModel();
    bannerData.bannerId = v['id'];
    bannerData.bannerTitle = v['banner_title'];
    bannerData.bannerSlug = v['banner_slug'];
    bannerData.bannerDesc = v['banner_desc'];
    bannerData.imageUrl = v['banner_image_android'];
    bannerData.productIds = v['product_ids'].toString();
    return bannerData;
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
    productModel.is_featured = v['is_featured'];

    if (cartQuantityModels != null) {
      int itemFound = -1;
      itemFound = cartQuantityModels.indexWhere((cartQuantityModel) =>
          cartQuantityModel.productId == productModel.productId);

      productModel.isAdded = itemFound == -1 ? false : true;
    }
    return productModel;
  }

  CategoryModel parseCategoryData(v) {
    CategoryModel categoryModel = new CategoryModel();
    categoryModel.categoryId = v['id'];
    categoryModel.categoryName = v['category_name'];
    categoryModel.categorySlug = v['category_slug'];
    categoryModel.productFeatures = v['product_features'];
    categoryModel.imageURL = v['category_image'];
    categoryModel.setOnHome = v['set_on_home'];
    //categoryModel.createdAt = v['created_at'];
    return categoryModel;
  }

  CartQuantityModel parseCartItemData(v) {
    CartQuantityModel cartQuantityModel = CartQuantityModel();
    cartQuantityModel.cartId = v['cartId'];
    cartQuantityModel.productId = v['productId'];
    cartQuantityModel.userId = v['userId'];
    cartQuantityModel.productQty = v['productQty'];
    return cartQuantityModel;
  }
}
