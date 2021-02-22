import '../models/notification_response_model.dart';

class NotificationResponse {
  NotificationResponseModel notificationResponseModel;
  NotificationResponse.fromJson(Map<String, dynamic> json) {
    notificationResponseModel = NotificationResponseModel();
    notificationResponseModel.errorStatus = json['errorStatus'];
    notificationResponseModel.message = json['message'];
    if (json['data'] != '') {
      List<NotificationData> notificationDatas =  List<NotificationData>();
      json['data'].forEach((v) {
        //print('id: ${v['id']}');
        notificationDatas.add(parseData(v));
      });

      notificationResponseModel.notificationData = notificationDatas;
    }
  }

  NotificationData parseData(v) {
    NotificationData notificationData = NotificationData();
    notificationData.id = v['id'];
    notificationData.title = v['noti_title'];
    notificationData.desc = v['noti_desc'];
    notificationData.type = v['type'];
    notificationData.productId = v['product_ids'].toString();
    notificationData.bannerId = v['banner_id'].toString();
    notificationData.orderId = v['order_id'].toString();
    return notificationData;
  }
}
