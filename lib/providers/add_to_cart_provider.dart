import 'dart:convert';
import '../models/checkout_item.dart';
import '../models/order_place_model.dart';
import '../repository/order_place_repository.dart';
import '../util/my_singleton.dart';
import '../util/util_function.dart';
import 'package:flutter/material.dart';

class AddToCartProvider with ChangeNotifier {
  bool currentvisiablity = false;
  double totalAmount;
  int currentQuantity = 0;

  OrderPlaceRepository _orderPlaceRepository;
  AddToCartProvider() {
    _orderPlaceRepository = OrderPlaceRepository();
  }

  void updateVisiable(bool isVisibel) {
    print('updateVisiable');
    currentvisiablity = isVisibel;
    totalAmount = UtilFunction.getTotalAmountSum();
    notifyListeners();
  }

  void updateQuantity(int value) {
    print('updateQuantity ${value}');
    currentQuantity = value;
    notifyListeners();
  }

  // void updateAmount(double totalAmountR) {
  //   totalAmount = totalAmountR;
  //   notifyListeners();
  // }

  Future<OrderPlaceModel> placeOrder(
      int userId,
      String addressId,
      String address,
      String paymentType,
      String paymentId,
      String razorpayOrderId,
      List<CheckOutItem> checkOutItems) async {
    try {
      String orderData = jsonEncode(checkOutItems);
      if (orderData != null) {
        OrderPlaceModel orderPlaceModel =
            await _orderPlaceRepository.orderPlace(userId, orderData, addressId,
                paymentType, paymentId, razorpayOrderId);

        if (!orderPlaceModel.errorStatus) {
          orderPlaceModel.data = MySingleton.shared.checkoutMap;
          orderPlaceModel.address = address;
          MySingleton.shared.checkoutMap = {};
          MySingleton.shared.totalAmount = 0.0;
          MySingleton.shared.discountAmounts = '';
          MySingleton.shared.discount = '';
          updateVisiable(false);
        }
        notifyListeners();
        return orderPlaceModel;
      }
    } catch (ex) {
      print('Ex: $ex');
      OrderPlaceModel orderPlaceModel = OrderPlaceModel();
      orderPlaceModel.errorStatus = true;
      orderPlaceModel.message = ex.toString();
      return orderPlaceModel;
    }
  }

  Future<OrderPlaceModel> allProductAvailable(
      int userId,
      String addressId,
      String address,
      String paymentType,
      String paymentId,
      String razorpayOrderId,
      List<CheckOutItem> checkOutItems) async {
    String orderData = jsonEncode(checkOutItems);
    if (orderData != null) {
      try {
        OrderPlaceModel orderPlaceModel =
            await _orderPlaceRepository.allProductAvailable(userId, orderData,
                addressId, paymentType, paymentId, razorpayOrderId);

        return orderPlaceModel;
      } catch (ex) {
        print('Ex: $ex');
        OrderPlaceModel orderPlaceModel = OrderPlaceModel();
        orderPlaceModel.errorStatus = true;
        orderPlaceModel.message = ex.toString();
        return orderPlaceModel;
      }
    }
  }
}
