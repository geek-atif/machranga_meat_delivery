import 'dart:convert';
import 'dart:math';

import '../util/constant.dart';
import '../util/sharedpreferences_constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
import '../repository/order_place_repository.dart';
import '../models/cart_quantity_model.dart';
import '../widgets/my_dialogs.dart';
import '../providers/add_to_cart_provider.dart';
import '../util/styling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../models/checkout_item.dart';
import '../models/product_model.dart';
import '../util/my_singleton.dart';

class UtilFunction {
  static int fromJson(json) {
    return json['productQuantity'];
  }

  int getUserID() {
    var userId;
    userId = MySingleton.shared.userId;
    if (userId != null || userId != 0) {
      return userId;
    }

    SharedPreferences.getInstance().then((pref) {
      MySingleton.shared.userId = pref.getInt(SharedpreferencesConstant.userId);
    });

    return MySingleton.shared.userId;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: AppTheme.redButtonColor,
        textColor: Colors.white);
  }

  void showToastGreen(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  Future<CartModel> addToCart(int userId, String productId, String productQty,
      OrderPlaceRepository orderPlaceRepository, BuildContext context) async {
    CartModel cartModel;
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
    } else {
      cartModel =
          await orderPlaceRepository.addToCart(userId, productId, productQty);
    }
    return cartModel;
  }

  Future<CartModel> deleteFromCart(
      int userId,
      String productId,
      String productQty,
      OrderPlaceRepository orderPlaceRepository,
      BuildContext context) async {
    CartModel cartModel;
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
    } else {
      cartModel = await orderPlaceRepository.deleteFromCart(
          userId, productId, productQty);
    }

    return cartModel;
  }

  Future<CartModel> removeItemFromCart(
      int userId,
      String productId,
      String productQty,
      OrderPlaceRepository orderPlaceRepository,
      BuildContext context) async {
    CartModel cartModel;
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
    } else {
      cartModel = await orderPlaceRepository.removeItemFromCart(
          userId, productId, productQty);
    }
    return cartModel;
  }

  static double getTotalAmountSum() {
    if (MySingleton.shared.totalAmount <= 0.0) return 0.0;

    return double.parse(MySingleton.shared.totalAmount.toStringAsFixed(2));
  }

  static double getTotalAmountSumForCheckOut(List<CheckOutItem> checkOutItems) {
    print('${MySingleton.shared.totalAmount}');
    if (checkOutItems == null) return 0.0;
    if (getTotalAmountSum() <= 0.0) return 0.0;
    double totalAmount = getTotalAmountSum();
    double deliveryCharge = MySingleton.shared.deliveryCharge;
    String discountAmounts = MySingleton.shared.discountAmounts;
    if (discountAmounts.isNotEmpty && discountAmounts != null) {
      if (double.parse(discountAmounts) > 0) {
        return double.parse(
            (totalAmount - double.parse(discountAmounts) + deliveryCharge)
                .toStringAsFixed(2));
      }
    }

    return double.parse((totalAmount + deliveryCharge).toStringAsFixed(2));
  }

  static double getTotalAmountSumForCartScreen(
      List<CheckOutItem> checkOutItems) {
    if (checkOutItems == null) return 0.0;
    double totalAmount = 0.0;

    checkOutItems.forEach((checkOutItem) {
      totalAmount += double.parse(checkOutItem.productPrice) *
          checkOutItem.productQuantity;
    });
    MySingleton.shared.totalAmount = 0.0;
    MySingleton.shared.totalAmount =
        double.parse((totalAmount).toStringAsFixed(2));
    return MySingleton.shared.totalAmount;
  }

  static double getTotalAmountSumForProducts(
    List<ProductModel> productModels,
    List<CartQuantityModel> cartQuantityModels,
    BuildContext context,
  ) {
    if (cartQuantityModels == null) return 0.0;
    double localTotalAmount = 0.0;
    cartQuantityModels.forEach((cartQuantityModel) {
      var productModel = productModels.firstWhere(
          (productModel) =>
              productModel.productId == cartQuantityModel.productId,
          orElse: () => null);

      if (productModel != null) {
        var productPrice = productModel.sellingPrice;
        localTotalAmount +=
            double.parse(productPrice) * cartQuantityModel.productQty;
      }
    });

    if (localTotalAmount <= 0.0) return 0.0;
    MySingleton.shared.totalAmount = 0.0;
    MySingleton.shared.totalAmount = double.parse((localTotalAmount).toStringAsFixed(2));
    Provider.of<AddToCartProvider>(context, listen: false).updateVisiable(true);
    return MySingleton.shared.totalAmount;
  }

  Future<int> addProductToCartSingle(int quantity, ProductModel productModel,
      BuildContext context, GlobalKey<State> keyLoader) async {
    int counter = 0;
    if (quantity >= 0) {
      Dialogs.showLoadingDialog(context, keyLoader);
      CartModel cartModel = await UtilFunction().addToCart(
          getUserID(),
          productModel.productId.toString(),
          '1',
          MySingleton.shared.orderPlaceRepository,
          context);
      if (!cartModel.errorStatus) {
        MySingleton.shared.totalAmount +=
            double.parse(productModel.sellingPrice);
        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(true);
        counter = 1;
      } else {
        showToast(cartModel.message);
        UtilFunction().showToast(cartModel.message);
      }
      Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
    }
    return counter;
  }

  Future<int> addProductToCart(int quantity, ProductModel productModel,
      BuildContext context, GlobalKey<State> keyLoader) async {
    int counter = 0;
    if (quantity >= 0) {
      Dialogs.showLoadingDialog(context, keyLoader);
      CartModel cartModel = await UtilFunction().addToCart(
          getUserID(),
          productModel.productId.toString(),
          '1',
          MySingleton.shared.orderPlaceRepository,
          context);
      if (!cartModel.errorStatus) {
        var totalAmount = getTotalAmountSum();
        totalAmount += double.parse(productModel.sellingPrice);
        MySingleton.shared.totalAmount =
            double.parse(totalAmount.toStringAsFixed(2));

        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(true);
        counter = 1;
      } else {
        showToast(cartModel.message);
      }
      Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
    }
    return counter;
  }

  Future<int> subProductToCart(int quantity, ProductModel productModel,
      BuildContext context, GlobalKey<State> keyLoader) async {
    int counter = 0;
    if (quantity >= 0) {
      Dialogs.showLoadingDialog(context, keyLoader);
      CartModel cartModel = await UtilFunction().deleteFromCart(
          getUserID(),
          productModel.productId.toString(),
          '1',
          MySingleton.shared.orderPlaceRepository,
          context);
      if (!cartModel.errorStatus) {
        var totalAmount = getTotalAmountSum();
        totalAmount -= double.parse(productModel.sellingPrice);
        MySingleton.shared.totalAmount =
            double.parse(totalAmount.toStringAsFixed(2));

        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(true);
        counter = 1;
      } else {
        showToast(cartModel.message);
      }
      Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();

      if (UtilFunction.getTotalAmountSum() <= 0.0)
        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(false);
    }
    return counter;
  }

  Future<int> addProductToCartForCartScreen(int quantity, CheckOutItem checkot,
      BuildContext context, GlobalKey<State> keyLoader) async {
    int counter = 0;
    if (quantity >= 0) {
      Dialogs.showLoadingDialog(context, keyLoader);
      CartModel cartModel = await UtilFunction().addToCart(
          getUserID(),
          checkot.productId.toString(),
          '1',
          MySingleton.shared.orderPlaceRepository,
          context);
      if (!cartModel.errorStatus) {
        Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
        var totalAmount = getTotalAmountSum();
        totalAmount += double.parse(checkot.productPrice);
        MySingleton.shared.totalAmount =
            double.parse(totalAmount.toStringAsFixed(2));
        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(true);
        counter = 1;
      } else {
        Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
        showToast(cartModel.message);
      }
      return counter;
    }
  }

  Future<int> subProductToCartForCartScreen(int quantity, CheckOutItem checkot,
      BuildContext context, GlobalKey<State> keyLoader) async {
    int counter = 0;
    if (quantity >= 0) {
      OrderPlaceRepository orderPlaceRepository = OrderPlaceRepository();
      Dialogs.showLoadingDialog(context, keyLoader);
      CartModel cartModel = await UtilFunction().deleteFromCart(getUserID(),
          checkot.productId.toString(), '1', orderPlaceRepository, context);

      if (!cartModel.errorStatus) {
        var totalAmount = getTotalAmountSum();
        totalAmount -= double.parse(checkot.productPrice);
        MySingleton.shared.totalAmount =
            double.parse(totalAmount.toStringAsFixed(2));
        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(true);
        counter = 1;
      } else {
        showToast(cartModel.message);
      }
      Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();

      if (UtilFunction.getTotalAmountSum() <= 0.0)
        Provider.of<AddToCartProvider>(context, listen: true)
            .updateVisiable(false);
    }
    return counter;
  }

  static double getCheckOutTotalAmount() {
    double totalAmount = MySingleton.shared.totalAmount;
    double deliveryCharge = MySingleton.shared.deliveryCharge;
    String discountAmounts = MySingleton.shared.discountAmounts;
    if (totalAmount <= 0.0) return totalAmount;
    double finalTotalAmount = double.parse((totalAmount).toStringAsFixed(2));

    if (discountAmounts.isNotEmpty && discountAmounts != null) {
      if (double.parse(discountAmounts) > 0) {
        print('discountAmounts : ${discountAmounts}');
        return double.parse(
            (finalTotalAmount - double.parse(discountAmounts) + deliveryCharge)
                .toStringAsFixed(2));
      }
    }
    return finalTotalAmount + deliveryCharge;
  }

  static double getDiscountAmount() {
    if (MySingleton.shared.discountAmounts == null ||
        MySingleton.shared.discountAmounts.isEmpty) return 0.0;
    return double.parse(MySingleton.shared.discountAmounts);
  }

  Future<CartModel> getCartDetail(int userId, BuildContext context) async {
    CartModel cartModel;
    var isJWTValid = await UtilFunction.isJWTValid();
    if (!isJWTValid) {
      UtilFunction.logout(context);
    } else {
      cartModel =
          await MySingleton.shared.orderPlaceRepository.getCartDetail(userId);
    }
    return cartModel;
  }

  int getRandomNumber() {
    var rng = new Random();
    return rng.nextInt(100);
  }

  static PageRoute<Object> createProductDetailsRoute(Widget widget) {
    print('_createTutorialDetailRoute');
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))
              .animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.ease))
                .animate(animation),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => widget,
    );
  }

  static Future<String> get jwtOrEmpty async {
    final storage = FlutterSecureStorage();
    var jwt = await storage.read(key: SharedpreferencesConstant.jwt);
    if (jwt == null) return "abc";
    return jwt;
  }

  static Future<bool> isJWTValid() async {
    var jwt = await jwtOrEmpty;
    var jwtA = jwt.split(".");
    if (jwtA.length != 3) {
      return false;
    }
    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwtA[1]))));

    if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
        .isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  static void logout(BuildContext context) {
    final storage = FlutterSecureStorage();
    storage.delete(key: SharedpreferencesConstant.jwt);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(SharedpreferencesConstant.userId, 0);
      prefs.setBool(SharedpreferencesConstant.isLogin, false);
      Navigator.pushNamedAndRemoveUntil(
          context, Constant.LOGIN_ROUTE_NAME, (r) => false);
    });
  }
}
