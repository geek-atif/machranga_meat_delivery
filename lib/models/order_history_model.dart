class OrderHistoryModel {
  bool errorStatus;
  String message;
  List<OrderHistory> orderHistory;
}

class OrderHistory {
  String  order_unique_id;
  int order_id;
  String order_address;
  String total_amt;
  String order_date ;
  int order_status;
  List<OrderItem> orderItem;
}

class OrderItem {
  int  product_id;
  String  image_url;
  int product_qty;
  String selling_price;
  String product_slug ;
  
}


               