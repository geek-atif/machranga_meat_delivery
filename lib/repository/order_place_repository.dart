import '../response/cart_model_response.dart';
import '../models/cart_model.dart';
import '../models/order_place_model.dart';
import '../response/order_place_response.dart';
import '../util/my_singleton.dart';
import '../util/util_function.dart';
import '../api_base_helper/api_base_helper.dart';

class OrderPlaceRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<OrderPlaceModel> orderPlace(
      int userId,
      String orderData,
      String addressId,
      String paymentType,
      String paymentId,
      String razorpayOrderId) async {
    dynamic body = {
      'userId': userId.toString(),
      'addressId': addressId,
      'productData': orderData,
      'totalAmount': UtilFunction.getTotalAmountSum().toString(),
      'payAmount': UtilFunction.getCheckOutTotalAmount().toString(),
      'discountAmount': UtilFunction.getDiscountAmount().toString(),
      'discount': MySingleton.shared.discount.toString(),
      'paymentType': paymentType,
      'paymentId': paymentId,
      'razorpayOrderId': razorpayOrderId,
    };
    final response = await _helper.post("/addProduct", body);
    OrderPlaceModel orderPlaceModel =
        OrderPlaceResponse.fromJson(response).orderPlaceModel;
    return orderPlaceModel;
  }

  Future<CartModel> getCartDetail(int userId) async {
    final response =
        await _helper.get("/getCartDetail?userId=${userId.toString()}");
    CartModel cartModel = CartModelResponse.fromJson(response).cartModel;
    return cartModel;
  }

  Future<CartModel> addToCart(
      int userId, String productId, String productQty) async {
    dynamic body = {
      'userId': userId.toString(),
      'productId': productId,
      'productQty': productQty,
    };
    final response = await _helper.post("/addToCart", body);
    CartModel cartModel = CartModelResponse.fromJsonForCat(response).cartModel;
    return cartModel;
  }

  Future<CartModel> deleteFromCart(
      int userId, String productId, String productQty) async {
    dynamic body = {
      'userId': userId.toString(),
      'productId': productId,
      'productQty': productQty,
    };
    final response = await _helper.post("/subItemFromCart", body);

    CartModel cartModel = CartModelResponse.fromJsonForCat(response).cartModel;
    return cartModel;
  }

  Future<CartModel> removeItemFromCart(
      int userId, String productId, String productQty) async {
    dynamic body = {
      'userId': userId.toString(),
      'productId': productId,
      'productQty': productQty,
    };
    final response = await _helper.post("/removeItemFromCart", body);
    print('removeItemFromCart response : ${response}');
    CartModel cartModel = CartModelResponse.fromJsonForCat(response).cartModel;
    return cartModel;
  }

  Future<OrderPlaceModel> allProductAvailable(
      int userId,
      String orderData,
      String addressId,
      String paymentType,
      String paymentId,
      String razorpayOrderId) async {
    dynamic body = {
      'userId': userId.toString(),
      'addressId': addressId,
      'productData': orderData,
      'totalAmount': UtilFunction.getTotalAmountSum().toString(),
      'payAmount': UtilFunction.getCheckOutTotalAmount().toString(),
      'discountAmount': UtilFunction.getDiscountAmount().toString(),
      'discount': MySingleton.shared.discount.toString(),
      'paymentType': paymentType,
      'paymentId': paymentId,
      'razorpayOrderId': razorpayOrderId,
    };
    final response = await _helper.post("/allProductAvailable", body);
    OrderPlaceModel orderPlaceModel =
        OrderPlaceResponse.fromJson(response).orderPlaceModel;
    return orderPlaceModel;
  }
}
