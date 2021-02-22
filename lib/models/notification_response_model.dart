class NotificationResponseModel {
  bool errorStatus;
  String message;
  List<NotificationData> notificationData;
}

class NotificationData {
  int id;
  String title;
  String desc;
  String type;
  String productId;
  String bannerId;
  String orderId;
}