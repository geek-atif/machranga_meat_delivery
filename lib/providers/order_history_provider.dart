import 'dart:async';
import '../repository/order_history_repository.dart';
import '../models/order_history_model.dart';
import 'package:flutter/material.dart';

class OrderHistoryProvider with ChangeNotifier {
  OrderHistoryRepository _orderHistoryRepository;
  OrderHistoryProvider() {
    _orderHistoryRepository = new OrderHistoryRepository();
  }

  Future<OrderHistoryModel> getOrderHistory(int userId) async {
    try {
      OrderHistoryModel orderHistoryModel =
          await _orderHistoryRepository.getOrderHistory(userId);
      notifyListeners();
      return orderHistoryModel;
    } catch (ex) {
      print('Ex: $ex');
      OrderHistoryModel productListModel = OrderHistoryModel();
      productListModel.errorStatus = true;
      productListModel.message = ex.toString();
      return productListModel;
    }
  }
}
