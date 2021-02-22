import '../response/order_history_response.dart';
import '../models/order_history_model.dart';
import '../api_base_helper/api_base_helper.dart';

class OrderHistoryRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<OrderHistoryModel> getOrderHistory(int userId) async {
    final response = await _helper.get("/getOrderHistory?userId=$userId");
    OrderHistoryModel homeModel =
        OrderHistoryResponse.fromJson(response).orderHistoryModel;
    return homeModel;
  }

  Future<OrderHistoryModel> getOrderHistoryById(String orderId) async {
    final response =
        await _helper.get("/getOrderHistoryByOrderId?orderId=$orderId");
    OrderHistoryModel homeModel =
        OrderHistoryResponse.fromJson(response).orderHistoryModel;
    return homeModel;
  }
  
}
