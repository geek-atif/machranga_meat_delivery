import 'package:Machranga/models/order_history_model.dart';

class OrderHistoryResponse {
  OrderHistoryModel orderHistoryModel;
  OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    orderHistoryModel = new OrderHistoryModel();
    orderHistoryModel.errorStatus = json['errorStatus'];
    orderHistoryModel.message = json['message'];
    if (json['data'] != '') {
      List<OrderHistory> orderHistory = new List<OrderHistory>();
      json['data']['orderHistory'].forEach(
        (v) {
          orderHistory.add(parssData(v));
        },
      );
      orderHistoryModel.orderHistory = orderHistory;
    }
  }

  OrderHistory parssData(v) {
    OrderHistory orderHistory = new OrderHistory();
    orderHistory.order_unique_id = v['order_unique_id'];
    orderHistory.order_id = v['order_id'];
    orderHistory.order_address = v['order_address'];
    orderHistory.total_amt = v['total_amt'].toString();
    orderHistory.order_date = v['order_date'].toString();
    orderHistory.order_status = v['order_status'];

    List<OrderItem> orderItem = new List<OrderItem>();
    v['OrderItem'].forEach(
      (v) {
        orderItem.add(parsOrderItem(v));
      },
    );
    orderHistory.orderItem = orderItem;

    return orderHistory;
  }

  OrderItem parsOrderItem(v) {
    OrderItem orderItem = OrderItem();
    orderItem.product_id = v['product_id'];
    orderItem.image_url = v['image_url'];
    orderItem.product_qty = v['product_qty'];
    orderItem.selling_price = v['selling_price'].toString();
    orderItem.product_slug = v['product_slug'];
    return orderItem;
  }
}
